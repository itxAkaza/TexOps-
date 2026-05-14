import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FibreTestingController extends GetxController {
  // --- UI STATE (Is it expanded?) ---
  var isFibreLengthExpanded = false.obs;
  var isFibreDenierExpanded = false.obs;

  void toggleFibreLength() {
    isFibreLengthExpanded.value = !isFibreLengthExpanded.value;
  }

  void toggleFibreDenier() {
    isFibreDenierExpanded.value = !isFibreDenierExpanded.value;
  }

  // --- TEXT EDITING CONTROLLERS (For Inputs) ---
  final fibreLengthCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final lengthCtrl = TextEditingController();

  final FocusNode fibreLengthFocus = FocusNode();
  final FocusNode weightFocus = FocusNode();
  final FocusNode lengthFocus = FocusNode();

  // --- DATA STATE (The calculated result) ---
  var calculatedDenierResult = "-".obs;

  // Called whenever the user types in the Weight or Length text fields
  void calculateDenier(String weightStr, String lengthStr) {
    double? weight = double.tryParse(weightStr);
    double? length = double.tryParse(lengthStr);

    if (weight != null && length != null && length > 0) {
      double result = (weight / length) * 9000;
      calculatedDenierResult.value = result.toStringAsFixed(1);
    } else {
      calculatedDenierResult.value = "-";
    }
  }

  @override
  void onInit() {
    super.onInit();

    // Denier Listeners
    void updateDenier() {
      calculateDenier(weightCtrl.text, lengthCtrl.text);
    }

    weightCtrl.addListener(updateDenier);
    lengthCtrl.addListener(updateDenier);
  }

  @override
  void onClose() {
    // Always dispose controllers to prevent memory leaks!
    fibreLengthCtrl.dispose();
    weightCtrl.dispose();
    lengthCtrl.dispose();
    fibreLengthFocus.dispose();
    weightFocus.dispose();
    lengthFocus.dispose();
    super.onClose();
  }
}
