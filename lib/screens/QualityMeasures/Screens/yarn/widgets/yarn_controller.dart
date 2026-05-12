import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import the calculation class you just made
import 'yarn_calculations.dart';

class YarnTestingController extends GetxController {
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

  // ==========================================
  // 3. REACTIVE RESULTS (Shows in the Yellow UI)
  // ==========================================
  var actualCountResult = "-".obs;
  var tenacityResult = "-".obs;
  var elongationResult = "-".obs;
  var clspResult = "-".obs;
  var tpmResult = "-".obs;

  // ==========================================
  // 4. LIFECYCLE (Listen for user typing)
  // ==========================================
  @override
  void onInit() {
    super.onInit();

    // Actual Count Listeners
    void updateActualCount() {
      actualCountResult.value = YarnCalculations.calculateActualCount(
        lengthCtrl.text,
        weightCtrl.text,
      );
    }

    lengthCtrl.addListener(updateActualCount);
    weightCtrl.addListener(updateActualCount);

    // Tenacity Listeners
    void updateTenacity() {
      tenacityResult.value = YarnCalculations.calculateTenacity(
        forceCtrl.text,
        texCtrl.text,
      );
    }

    forceCtrl.addListener(updateTenacity);
    texCtrl.addListener(updateTenacity);

    // Elongation Listeners
    void updateElongation() {
      elongationResult.value = YarnCalculations.calculateElongation(
        finalLengthCtrl.text,
        originalLengthCtrl.text,
      );
    }

    finalLengthCtrl.addListener(updateElongation);
    originalLengthCtrl.addListener(updateElongation);

    // CLSP Listeners
    void updateCLSP() {
      clspResult.value = YarnCalculations.calculateCLSP(
        clspCountCtrl.text,
        strengthCtrl.text,
      );
    }

    clspCountCtrl.addListener(updateCLSP);
    strengthCtrl.addListener(updateCLSP);

    // TPM Listeners
    void updateTPM() {
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
    super.onClose();
  }
}
