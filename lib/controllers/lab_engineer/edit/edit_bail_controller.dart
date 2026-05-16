import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:texops/Utiles/utiles.dart';
import '../../../controllers/lab_engineer/detail/bail_detail_controller.dart';
import '../../../data/fireStoreDB/labEnginner/edit_bail_data.dart'; // To refresh data after edit

class EditBaleController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;


  final typeController = TextEditingController();
  final quantityController = TextEditingController();
  final weightController = TextEditingController();
  final priceController = TextEditingController();


  final RxString selectedQualityStatus = 'Pending Check'.obs;
  final List<String> qualityOptions = ['Pending Check', 'Passed', 'Failed'];


  Map<String, dynamic> originalData = {};
  double oldPrice = 0.0;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null)
    {
      originalData = Get.arguments as Map<String, dynamic>;
      _prefillData();
    }
  }

  void _prefillData()
  {
    typeController.text = originalData['baleType']?.toString() ?? '';
    quantityController.text = originalData['quantity']?.toString() ?? '';
    weightController.text = originalData['weight']?.toString() ?? '';
    priceController.text = originalData['price']?.toString() ?? '';

    oldPrice = double.tryParse(priceController.text) ?? 0.0;

    bool isPassed = originalData['qualityStatus'] ?? false;
    selectedQualityStatus.value = isPassed ? 'Passed' : 'Pending Check';
  }

  String? validateNumber(String? value, String fieldName)
  {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    if (double.tryParse(value) == null) return 'Must be a valid number';
    return null;
  }

  Future<void> saveChanges() async
  {
    if (!formKey.currentState!.validate()) return;

    String? userId = originalData['engineerUID'] ?? FirebaseAuth.instance.currentUser?.uid;
    String baleId = originalData['baleId'] ?? '';

    if (userId == null || baleId.isEmpty) {
      Get.snackbar('Error', 'Missing critical IDs to update data.');
      return;
    }

    isLoading.value = true;


    double newPrice = double.tryParse(priceController.text) ?? 0.0;
    double priceDifference = newPrice - oldPrice;


    Map<String, dynamic> updatedFields = {
      'baleType': typeController.text.trim(),
      'quantity': quantityController.text.trim(),
      'weight': weightController.text.trim(),
      'price': priceController.text.trim(),
      'qualityStatus': selectedQualityStatus.value == 'Passed',
    };

    try {
      await EditBaleFirebaseService.updateBaleData(
        userId: userId,
        baleId: baleId,
        updatedFields: updatedFields,
        priceDifference: priceDifference,
      );


      if (Get.isRegistered<BailDetailController>())
      {
        final detailController = Get.find<BailDetailController>();
        detailController.bailData.addAll(updatedFields);
      }

      Get.back();
     Utils.toastMessegessuccess("Updated Successfully");

    } catch (e)
    {
     Utils.toastMesseges(e.toString());
    } finally
    {
      isLoading.value = false;
    }


  }

  @override
  void onClose()
  {
    typeController.dispose();
    quantityController.dispose();
    weightController.dispose();
    priceController.dispose();
    super.onClose();
  }
  
}