import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BaleEntryController extends GetxController {
  RxInt currentStep = 0.obs;

  // --- Gate Pass Controllers ---
  final gatePassRefController = TextEditingController();
  final vehicleNumberController = TextEditingController();


  // --- Bale Inventory Controllers ---
  final baleTypeController = TextEditingController();
  final baleCountController = TextEditingController();
  final quantityController = TextEditingController();
  final weightController = TextEditingController();
  final priceController = TextEditingController();

  final arrivalTime =  DateFormat('dd MMMM yyyy, hh:mm a').format(DateTime.now());
  final RxString generatedBaleId = ''.obs;
  final selectedSupplier = Rxn<String>();
  final List<String> suppliers = ['Supplier A', 'Supplier B', 'Supplier C'];



  void goToNextStep()
  {
    if (currentStep.value == 0)
    {
      String gatePass = gatePassRefController.text.trim();

      String idDateFormatter = DateFormat('yyMMdd-HHmm').format(DateTime.now());

      generatedBaleId.value = '${gatePass}_$idDateFormatter';

      currentStep.value = 1;
    }
  }

  void goToPreviousStep() {
    if (currentStep.value == 1)
    {
      currentStep.value = 0;
    }
  }


  void submitData() {
    // Print to console to verify data is captured
    print('Submitting Gate Pass: ${gatePassRefController.text}');
    print('Submitting Bale Type: ${baleTypeController.text}');

    Get.snackbar(
      'Success',
      'Data saved and QR tag generated!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    gatePassRefController.dispose();
    vehicleNumberController.dispose();
    baleTypeController.dispose();
    baleCountController.dispose();
    quantityController.dispose();
    weightController.dispose();
    priceController.dispose();
    super.onClose();
  }
}