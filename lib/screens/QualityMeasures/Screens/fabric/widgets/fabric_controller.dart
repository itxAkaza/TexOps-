import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'fabric_calculations.dart';

class FabricTestingController extends GetxController {
  bool didAutoExpand = false;
  bool didPrefill = false;
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

  void toggleStiffness() =>
      isStiffnessExpanded.value = !isStiffnessExpanded.value;
  void toggleWarpCount() =>
      isWarpCountExpanded.value = !isWarpCountExpanded.value;
  void toggleWeftCount() =>
      isWeftCountExpanded.value = !isWeftCountExpanded.value;
  void toggleGsm() => isGsmExpanded.value = !isGsmExpanded.value;
  void toggleTensileStrength() =>
      isTensileStrengthExpanded.value = !isTensileStrengthExpanded.value;
  void toggleTearingStrength() =>
      isTearingStrengthExpanded.value = !isTearingStrengthExpanded.value;
  void toggleBurstingStrength() =>
      isBurstingStrengthExpanded.value = !isBurstingStrengthExpanded.value;
  void toggleCreaseRecovery() =>
      isCreaseRecoveryExpanded.value = !isCreaseRecoveryExpanded.value;
  void toggleKnitType() => isKnitTypeExpanded.value = !isKnitTypeExpanded.value;
  void toggleWeaveType() =>
      isWeaveTypeExpanded.value = !isWeaveTypeExpanded.value;

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

  final FocusNode stiffnessWeightFocus = FocusNode();
  final FocusNode stiffnessBendingFocus = FocusNode();
  final FocusNode warpCountFocus = FocusNode();
  final FocusNode weftCountFocus = FocusNode();
  final FocusNode gsmWeightFocus = FocusNode();
  final FocusNode gsmAreaFocus = FocusNode();
  final FocusNode tensileForceFocus = FocusNode();
  final FocusNode tearingForceFocus = FocusNode();
  final FocusNode burstingPressureFocus = FocusNode();
  final FocusNode creaseTheta1Focus = FocusNode();
  final FocusNode creaseTheta2Focus = FocusNode();

  var stiffnessResult = '-'.obs;
  var warpCountResult = '-'.obs;
  var weftCountResult = '-'.obs;
  var gsmResult = '-'.obs;
  var tensileStrengthResult = '-'.obs;
  var tearingStrengthResult = '-'.obs;
  var burstingStrengthResult = '-'.obs;
  var creaseRecoveryResult = '-'.obs;

  bool _keepStoredResult(
    RxString result,
    List<TextEditingController> inputs,
  ) {
    if (!didPrefill) return false;
    if (result.value == '-') return false;
    return inputs.every((controller) => controller.text.trim().isEmpty);
  }

  var selectedKnitType = 'Warp'.obs;
  var selectedWeaveType = 'Plain'.obs;

  void applyStoredMetrics(Map<String, dynamic> metrics) {
    final Map<String, TextEditingController> inputMap = {
      'inputStiffnessWeight': stiffnessWeightCtrl,
      'inputStiffnessBending': stiffnessBendingCtrl,
      'warpCount': warpCountCtrl,
      'weftCount': weftCountCtrl,
      'inputGsmWeight': gsmWeightCtrl,
      'inputGsmArea': gsmAreaCtrl,
      'tensileStrength': tensileForceCtrl,
      'tearingStrength': tearingForceCtrl,
      'burstingStrength': burstingPressureCtrl,
      'inputCreaseTheta1': creaseTheta1Ctrl,
      'inputCreaseTheta2': creaseTheta2Ctrl,
    };

    inputMap.forEach((key, controller) {
      final dynamic value = metrics[key];
      if (value != null) {
        controller.text = value.toString();
      }
    });

    final dynamic stiffness = metrics['stiffness'];
    final dynamic warpCount = metrics['warpCount'];
    final dynamic weftCount = metrics['weftCount'];
    final dynamic gsm = metrics['gsm'];
    final dynamic tensile = metrics['tensileStrength'];
    final dynamic tearing = metrics['tearingStrength'];
    final dynamic bursting = metrics['burstingStrength'];
    final dynamic crease = metrics['creaseRecovery'];
    final dynamic knitType = metrics['knitType'];
    final dynamic weaveType = metrics['weaveType'];

    if (stiffness != null) {
      stiffnessResult.value = stiffness.toString();
    }
    if (warpCount != null) {
      warpCountResult.value = warpCount.toString();
    }
    if (weftCount != null) {
      weftCountResult.value = weftCount.toString();
    }
    if (gsm != null) {
      gsmResult.value = gsm.toString();
    }
    if (tensile != null) {
      tensileStrengthResult.value = tensile.toString();
    }
    if (tearing != null) {
      tearingStrengthResult.value = tearing.toString();
    }
    if (bursting != null) {
      burstingStrengthResult.value = bursting.toString();
    }
    if (crease != null) {
      creaseRecoveryResult.value = crease.toString();
    }
    if (knitType != null) {
      selectedKnitType.value = knitType.toString();
    }
    if (weaveType != null) {
      selectedWeaveType.value = weaveType.toString();
    }
  }

  @override
  void onInit() {
    super.onInit();

    void updateStiffness() {
      if (_keepStoredResult(
        stiffnessResult,
        [stiffnessWeightCtrl, stiffnessBendingCtrl],
      )) {
        return;
      }
      stiffnessResult.value = FabricCalculations.calculateStiffness(
        stiffnessWeightCtrl.text,
        stiffnessBendingCtrl.text,
      );
    }

    void updateWarpCount() {
      if (_keepStoredResult(warpCountResult, [warpCountCtrl])) {
        return;
      }
      warpCountResult.value = FabricCalculations.calculateSingleValue(
        warpCountCtrl.text,
      );
    }

    void updateWeftCount() {
      if (_keepStoredResult(weftCountResult, [weftCountCtrl])) {
        return;
      }
      weftCountResult.value = FabricCalculations.calculateSingleValue(
        weftCountCtrl.text,
      );
    }

    void updateGsm() {
      if (_keepStoredResult(gsmResult, [gsmWeightCtrl, gsmAreaCtrl])) {
        return;
      }
      gsmResult.value = FabricCalculations.calculateGsm(
        gsmWeightCtrl.text,
        gsmAreaCtrl.text,
      );
    }

    void updateTensileStrength() {
      if (_keepStoredResult(tensileStrengthResult, [tensileForceCtrl])) {
        return;
      }
      tensileStrengthResult.value = FabricCalculations.calculateSingleValue(
        tensileForceCtrl.text,
      );
    }

    void updateTearingStrength() {
      if (_keepStoredResult(tearingStrengthResult, [tearingForceCtrl])) {
        return;
      }
      tearingStrengthResult.value = FabricCalculations.calculateSingleValue(
        tearingForceCtrl.text,
      );
    }

    void updateBurstingStrength() {
      if (_keepStoredResult(burstingStrengthResult, [burstingPressureCtrl])) {
        return;
      }
      burstingStrengthResult.value = FabricCalculations.calculateSingleValue(
        burstingPressureCtrl.text,
      );
    }

    void updateCreaseRecovery() {
      if (_keepStoredResult(creaseRecoveryResult, [creaseTheta1Ctrl, creaseTheta2Ctrl])) {
        return;
      }
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
    stiffnessWeightFocus.dispose();
    stiffnessBendingFocus.dispose();
    warpCountFocus.dispose();
    weftCountFocus.dispose();
    gsmWeightFocus.dispose();
    gsmAreaFocus.dispose();
    tensileForceFocus.dispose();
    tearingForceFocus.dispose();
    burstingPressureFocus.dispose();
    creaseTheta1Focus.dispose();
    creaseTheta2Focus.dispose();
    super.onClose();
  }
}
