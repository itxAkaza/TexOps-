import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import the calculation class you just made
import 'yarn_calculations.dart';

class YarnTestingController extends GetxController {
  bool didAutoExpand = false;
  bool didPrefill = false;
  // ==========================================
  // 1. EXPANSION STATES (To open/close cards)
  // ==========================================
  var isActualCountExpanded = false.obs;
  var isNominalCountExpanded = false.obs;
  var isTenacityExpanded = false.obs;
  var isElongationExpanded = false.obs;
  var isCLSPExpanded = false.obs;
  var isTPMExpanded = false.obs;

  void toggleActualCount() =>
      isActualCountExpanded.value = !isActualCountExpanded.value;
  void toggleNominalCount() =>
      isNominalCountExpanded.value = !isNominalCountExpanded.value;
  void toggleTenacity() => isTenacityExpanded.value = !isTenacityExpanded.value;
  void toggleElongation() =>
      isElongationExpanded.value = !isElongationExpanded.value;
  void toggleCLSP() => isCLSPExpanded.value = !isCLSPExpanded.value;
  void toggleTPM() => isTPMExpanded.value = !isTPMExpanded.value;

  // ==========================================
  // 2. TEXT EDITING CONTROLLERS (For Inputs)
  // ==========================================
  final lengthCtrl = TextEditingController();
  final weightCtrl = TextEditingController();

  final nominalCountCtrl = TextEditingController();

  final forceCtrl = TextEditingController();
  final texCtrl = TextEditingController();

  final finalLengthCtrl = TextEditingController();
  final originalLengthCtrl = TextEditingController();

  final clspCountCtrl = TextEditingController();
  final strengthCtrl = TextEditingController();

  final twistsCtrl = TextEditingController();
  final tpmLengthCtrl = TextEditingController();

  final FocusNode lengthFocus = FocusNode();
  final FocusNode weightFocus = FocusNode();
  final FocusNode nominalCountFocus = FocusNode();
  final FocusNode forceFocus = FocusNode();
  final FocusNode texFocus = FocusNode();
  final FocusNode finalLengthFocus = FocusNode();
  final FocusNode originalLengthFocus = FocusNode();
  final FocusNode clspCountFocus = FocusNode();
  final FocusNode strengthFocus = FocusNode();
  final FocusNode twistsFocus = FocusNode();
  final FocusNode tpmLengthFocus = FocusNode();

  // ==========================================
  // 3. REACTIVE RESULTS (Shows in the Yellow UI)
  // ==========================================
  var actualCountResult = "-".obs;
  var tenacityResult = "-".obs;
  var elongationResult = "-".obs;
  var clspResult = "-".obs;
  var tpmResult = "-".obs;

  bool _keepStoredResult(
    RxString result,
    List<TextEditingController> inputs,
  ) {
    if (!didPrefill) return false;
    if (result.value == '-') return false;
    return inputs.every((controller) => controller.text.trim().isEmpty);
  }

  void applyStoredMetrics(Map<String, dynamic> metrics) {
    final Map<String, dynamic> inputMap = {
      'inputLength': lengthCtrl,
      'inputWeight': weightCtrl,
      'inputForce': forceCtrl,
      'inputTex': texCtrl,
      'inputFinalLength': finalLengthCtrl,
      'inputOriginalLength': originalLengthCtrl,
      'inputClspCount': clspCountCtrl,
      'inputStrength': strengthCtrl,
      'inputTwists': twistsCtrl,
      'inputTpmLength': tpmLengthCtrl,
      'nominalCount': nominalCountCtrl,
    };

    inputMap.forEach((key, controller) {
      final dynamic value = metrics[key];
      if (value != null) {
        controller.text = value.toString();
      }
    });

    final dynamic actualCount = metrics['actualCount'];
    final dynamic tenacity = metrics['tenacity'];
    final dynamic elongation = metrics['elongationPercentage'];
    final dynamic clsp = metrics['clsp'];
    final dynamic tpm = metrics['tpm'];

    if (actualCount != null) {
      actualCountResult.value = actualCount.toString();
    }
    if (tenacity != null) {
      tenacityResult.value = tenacity.toString();
    }
    if (elongation != null) {
      elongationResult.value = elongation.toString();
    }
    if (clsp != null) {
      clspResult.value = clsp.toString();
    }
    if (tpm != null) {
      tpmResult.value = tpm.toString();
    }
  }

  // ==========================================
  // 4. LIFECYCLE (Listen for user typing)
  // ==========================================
  @override
  void onInit() {
    super.onInit();

    // Actual Count Listeners
    void updateActualCount() {
      if (_keepStoredResult(actualCountResult, [lengthCtrl, weightCtrl])) {
        return;
      }
      actualCountResult.value = YarnCalculations.calculateActualCount(
        lengthCtrl.text,
        weightCtrl.text,
      );
    }

    lengthCtrl.addListener(updateActualCount);
    weightCtrl.addListener(updateActualCount);

    // Tenacity Listeners
    void updateTenacity() {
      if (_keepStoredResult(tenacityResult, [forceCtrl, texCtrl])) {
        return;
      }
      tenacityResult.value = YarnCalculations.calculateTenacity(
        forceCtrl.text,
        texCtrl.text,
      );
    }

    forceCtrl.addListener(updateTenacity);
    texCtrl.addListener(updateTenacity);

    // Elongation Listeners
    void updateElongation() {
      if (_keepStoredResult(elongationResult, [finalLengthCtrl, originalLengthCtrl])) {
        return;
      }
      elongationResult.value = YarnCalculations.calculateElongation(
        finalLengthCtrl.text,
        originalLengthCtrl.text,
      );
    }

    finalLengthCtrl.addListener(updateElongation);
    originalLengthCtrl.addListener(updateElongation);

    // CLSP Listeners
    void updateCLSP() {
      if (_keepStoredResult(clspResult, [clspCountCtrl, strengthCtrl])) {
        return;
      }
      clspResult.value = YarnCalculations.calculateCLSP(
        clspCountCtrl.text,
        strengthCtrl.text,
      );
    }

    clspCountCtrl.addListener(updateCLSP);
    strengthCtrl.addListener(updateCLSP);

    // TPM Listeners
    void updateTPM() {
      if (_keepStoredResult(tpmResult, [twistsCtrl, tpmLengthCtrl])) {
        return;
      }
      tpmResult.value = YarnCalculations.calculateTPM(
        twistsCtrl.text,
        tpmLengthCtrl.text,
      );
    }

    twistsCtrl.addListener(updateTPM);
    tpmLengthCtrl.addListener(updateTPM);
  }

  @override
  void onClose() {
    // Always dispose controllers to prevent memory leaks!
    lengthCtrl.dispose();
    weightCtrl.dispose();
    nominalCountCtrl.dispose();
    forceCtrl.dispose();
    texCtrl.dispose();
    finalLengthCtrl.dispose();
    originalLengthCtrl.dispose();
    clspCountCtrl.dispose();
    strengthCtrl.dispose();
    twistsCtrl.dispose();
    tpmLengthCtrl.dispose();
    lengthFocus.dispose();
    weightFocus.dispose();
    nominalCountFocus.dispose();
    forceFocus.dispose();
    texFocus.dispose();
    finalLengthFocus.dispose();
    originalLengthFocus.dispose();
    clspCountFocus.dispose();
    strengthFocus.dispose();
    twistsFocus.dispose();
    tpmLengthFocus.dispose();
    super.onClose();
  }
}
