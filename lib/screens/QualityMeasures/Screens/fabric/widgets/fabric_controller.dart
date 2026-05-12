import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'fabric_calculations.dart';

class FabricTestingController extends GetxController {
  var isStiffnessExpanded = false.obs;
  var isWarpCountExpanded = false.obs;
  var isWeftCountExpanded = false.obs;
  var isGsmExpanded = false.obs;
  var isTensileStrengthExpanded = false.obs;
  var isTearingStrengthExpanded = false.obs;
  var isBurstingStrengthExpanded = false.obs;
  var isCreaseRecoveryExpanded = false.obs;
  var isKnitTypeExpanded = false.obs;
  var isWeaveTypeExpanded = false.obs;

  void toggleStiffness() => isStiffnessExpanded.value = !isStiffnessExpanded.value;
  void toggleWarpCount() => isWarpCountExpanded.value = !isWarpCountExpanded.value;
  void toggleWeftCount() => isWeftCountExpanded.value = !isWeftCountExpanded.value;
  void toggleGsm() => isGsmExpanded.value = !isGsmExpanded.value;
  void toggleTensileStrength() => isTensileStrengthExpanded.value = !isTensileStrengthExpanded.value;
  void toggleTearingStrength() => isTearingStrengthExpanded.value = !isTearingStrengthExpanded.value;
  void toggleBurstingStrength() => isBurstingStrengthExpanded.value = !isBurstingStrengthExpanded.value;
  void toggleCreaseRecovery() => isCreaseRecoveryExpanded.value = !isCreaseRecoveryExpanded.value;
  void toggleKnitType() => isKnitTypeExpanded.value = !isKnitTypeExpanded.value;
  void toggleWeaveType() => isWeaveTypeExpanded.value = !isWeaveTypeExpanded.value;

  final stiffnessWeightCtrl = TextEditingController();
  final stiffnessBendingCtrl = TextEditingController();

  final warpCountCtrl = TextEditingController();
  final weftCountCtrl = TextEditingController();

  final gsmWeightCtrl = TextEditingController();
  final gsmAreaCtrl = TextEditingController();

  final tensileForceCtrl = TextEditingController();
  final tearingForceCtrl = TextEditingController();
  final burstingPressureCtrl = TextEditingController();

  final creaseTheta1Ctrl = TextEditingController();
  final creaseTheta2Ctrl = TextEditingController();

  var stiffnessResult = '-'.obs;
  var warpCountResult = '-'.obs;
  var weftCountResult = '-'.obs;
  var gsmResult = '-'.obs;
  var tensileStrengthResult = '-'.obs;
  var tearingStrengthResult = '-'.obs;
  var burstingStrengthResult = '-'.obs;
  var creaseRecoveryResult = '-'.obs;

  var selectedKnitType = 'Warp'.obs;
  var selectedWeaveType = 'Plain'.obs;

  @override
  void onInit() {
    super.onInit();

    void updateStiffness() {
      stiffnessResult.value = FabricCalculations.calculateStiffness(
        stiffnessWeightCtrl.text,
        stiffnessBendingCtrl.text,
      );
    }

    void updateWarpCount() {
      warpCountResult.value = FabricCalculations.calculateSingleValue(warpCountCtrl.text);
    }

    void updateWeftCount() {
      weftCountResult.value = FabricCalculations.calculateSingleValue(weftCountCtrl.text);
    }

    void updateGsm() {
      gsmResult.value = FabricCalculations.calculateGsm(
        gsmWeightCtrl.text,
        gsmAreaCtrl.text,
      );
    }

    void updateTensileStrength() {
      tensileStrengthResult.value = FabricCalculations.calculateSingleValue(tensileForceCtrl.text);
    }

    void updateTearingStrength() {
      tearingStrengthResult.value = FabricCalculations.calculateSingleValue(tearingForceCtrl.text);
    }

    void updateBurstingStrength() {
      burstingStrengthResult.value = FabricCalculations.calculateSingleValue(burstingPressureCtrl.text);
    }

    void updateCreaseRecovery() {
      creaseRecoveryResult.value = FabricCalculations.calculateCreaseRecovery(
        creaseTheta1Ctrl.text,
        creaseTheta2Ctrl.text,
      );
    }

    stiffnessWeightCtrl.addListener(updateStiffness);
    stiffnessBendingCtrl.addListener(updateStiffness);

    warpCountCtrl.addListener(updateWarpCount);
    weftCountCtrl.addListener(updateWeftCount);

    gsmWeightCtrl.addListener(updateGsm);
    gsmAreaCtrl.addListener(updateGsm);

    tensileForceCtrl.addListener(updateTensileStrength);
    tearingForceCtrl.addListener(updateTearingStrength);
    burstingPressureCtrl.addListener(updateBurstingStrength);

    creaseTheta1Ctrl.addListener(updateCreaseRecovery);
    creaseTheta2Ctrl.addListener(updateCreaseRecovery);
  }

  @override
  void onClose() {
    stiffnessWeightCtrl.dispose();
    stiffnessBendingCtrl.dispose();
    warpCountCtrl.dispose();
    weftCountCtrl.dispose();
    gsmWeightCtrl.dispose();
    gsmAreaCtrl.dispose();
    tensileForceCtrl.dispose();
    tearingForceCtrl.dispose();
    burstingPressureCtrl.dispose();
    creaseTheta1Ctrl.dispose();
    creaseTheta2Ctrl.dispose();
    super.onClose();
  }
}