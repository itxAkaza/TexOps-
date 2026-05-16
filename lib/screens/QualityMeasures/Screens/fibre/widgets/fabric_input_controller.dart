import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FibreTestingController extends GetxController {
  bool didAutoExpand = false;
  bool didPrefill = false;
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

  bool _keepStoredResult(List<TextEditingController> inputs) {
    if (!didPrefill) return false;
    if (calculatedDenierResult.value == '-') return false;
    return inputs.every((controller) => controller.text.trim().isEmpty);
  }

  // Called whenever the user types in the Weight or Length text fields
  void calculateDenier(String weightStr, String lengthStr) {
    if (_keepStoredResult([weightCtrl, lengthCtrl])) {
      return;
    }
    double? weight = double.tryParse(weightStr);
    double? length = double.tryParse(lengthStr);

    if (weight != null && length != null && length > 0) {
      double result = (weight / length) * 9000;
      calculatedDenierResult.value = result.toStringAsFixed(1);
    } else {
      calculatedDenierResult.value = "-";
    }
  }

  void applyStoredMetrics(Map<String, dynamic> metrics) {
    final dynamic lengthValue = metrics['fibreLengthMm'];
    final dynamic denierValue = metrics['fibreDenier'];
    final dynamic inputWeight = metrics['inputWeight'];
    final dynamic inputLength = metrics['inputLength'];

    if (lengthValue != null) {
      fibreLengthCtrl.text = lengthValue.toString();
    }
    if (inputWeight != null) {
      weightCtrl.text = inputWeight.toString();
    }
    if (inputLength != null) {
      lengthCtrl.text = inputLength.toString();
    }
    if (denierValue != null) {
      calculatedDenierResult.value = denierValue.toString();
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
