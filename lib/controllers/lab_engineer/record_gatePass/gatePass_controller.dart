import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BaleEntryController extends GetxController {
  RxInt currentStep = 0.obs;

  // --- Gate Pass Controllers ---
  final gatePassRefController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final selectedSupplier = Rxn<String>();
  final arrivalTime =  DateFormat('dd MMMM yyyy, hh:mm a').format(DateTime.now());


  // --- Bale Inventory Controllers ---
  final RxString generatedBaleId = ''.obs;
  final baleTypeController = TextEditingController();
  final baleCountController = TextEditingController();
  final quantityController = TextEditingController();
  final weightController = TextEditingController();
  final priceController = TextEditingController();



  final EnginnerID="Abdullah";
  final bool QualityStatus=false;
  final bool ReadyforYarn=false;




  final List<String> suppliers = ['Supplier A', 'Supplier B', 'Supplier C'];
  final RxString qrData = ''.obs;



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
    Map<String, dynamic> baleData = {
      'gatePassRef': gatePassRefController.text.trim(),
      'vehicleNumber': vehicleNumberController.text.trim(),
      'supplier': selectedSupplier.value ?? 'N/A',
      'arrivalTime': arrivalTime,
      'baleId': generatedBaleId.value,
      'baleType': baleTypeController.text.trim(),
      'baleCount': baleCountController.text.trim(),
      'quantity': quantityController.text.trim(),
      'weight': weightController.text.trim(),
      'price': priceController.text.trim(),
      "engineerID":EnginnerID
    };


    qrData.value = jsonEncode(baleData);
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