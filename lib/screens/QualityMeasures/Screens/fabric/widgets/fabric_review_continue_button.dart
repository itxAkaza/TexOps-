import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/continue_button.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/quality_review_screen.dart';
import 'package:texops/screens/QualityMeasures/Screens/fabric/widgets/fabric_controller.dart';
import 'package:texops/data/models/quality_testing/quality_test_models.dart';

class FabricReviewContinueButton extends StatelessWidget {
  const FabricReviewContinueButton({super.key, required this.controller});

  final FabricTestingController controller;

  bool _hasValue(TextEditingController controller) {
    return controller.text.trim().isNotEmpty;
  }

  bool _isValid() {
    return _hasValue(controller.stiffnessWeightCtrl) &&
        _hasValue(controller.stiffnessBendingCtrl) &&
        _hasValue(controller.warpCountCtrl) &&
        _hasValue(controller.weftCountCtrl) &&
        _hasValue(controller.gsmWeightCtrl) &&
        _hasValue(controller.gsmAreaCtrl) &&
        _hasValue(controller.tensileForceCtrl) &&
        _hasValue(controller.tearingForceCtrl) &&
        _hasValue(controller.burstingPressureCtrl) &&
        _hasValue(controller.creaseTheta1Ctrl) &&
        _hasValue(controller.creaseTheta2Ctrl) &&
        controller.selectedKnitType.value.trim().isNotEmpty &&
        controller.selectedWeaveType.value.trim().isNotEmpty;
  }

  double? _parseDouble(String value) {
    return double.tryParse(value.trim());
  }

  void _showMissingFields() {
    Get.snackbar(
      'Missing Fields',
      'Please fill all fields before continuing.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
      backgroundColor: AppColors.primaryDarkTeal,
      colorText: AppColors.cardWhite,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContinueButton(
      text: 'Continue to Review',
      onPressed: () {
        if (!_isValid()) {
          _showMissingFields();
          return;
        }

        final String? baleRecordId =
          Get.arguments is Map ? (Get.arguments as Map)['baleRecordId'] as String? : null;
        final String? baleId =
          Get.arguments is Map ? (Get.arguments as Map)['baleId'] as String? : null;
        if (baleRecordId == null ||
          baleRecordId.isEmpty ||
          baleId == null ||
          baleId.isEmpty) {
          Get.snackbar(
            'Missing Bale',
            'Please open this test from a bale record.',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            borderRadius: 14,
            backgroundColor: AppColors.primaryDarkTeal,
            colorText: AppColors.cardWhite,
            icon: const Icon(Icons.error_outline, color: Colors.white),
            duration: const Duration(seconds: 2),
          );
          return;
        }

        final double? stiffness = _parseDouble(controller.stiffnessResult.value);
        final double? warpCount = _parseDouble(controller.warpCountResult.value);
        final double? weftCount = _parseDouble(controller.weftCountResult.value);
        final double? gsm = _parseDouble(controller.gsmResult.value);
        final double? tensile = _parseDouble(controller.tensileStrengthResult.value);
        final double? tearing = _parseDouble(controller.tearingStrengthResult.value);
        final double? bursting = _parseDouble(controller.burstingStrengthResult.value);
        final double? crease = _parseDouble(controller.creaseRecoveryResult.value);
        if (stiffness == null ||
            warpCount == null ||
            weftCount == null ||
            gsm == null ||
            tensile == null ||
            tearing == null ||
            bursting == null ||
            crease == null) {
          _showMissingFields();
          return;
        }

        final QualityTestPayload savePayload = QualityTestPayload(
          baleRecordId: baleRecordId,
          baleId: baleId,
          category: QualityTestCategory.fabric,
          metrics: FabricMetrics(
            stiffness: stiffness,
            warpCount: warpCount,
            weftCount: weftCount,
            gsm: gsm,
            tensileStrength: tensile,
            tearingStrength: tearing,
            burstingStrength: bursting,
            creaseRecovery: crease,
            knitType: controller.selectedKnitType.value,
            weaveType: controller.selectedWeaveType.value,
          ).toMap(),
        );

        Get.toNamed(
          RoutesNames.qualityReview,
          arguments: {
            'testType': 'Fabric Testing',
            'cards': [
              QualityReviewCardData(
                title: 'Stiffness',
                value: controller.stiffnessResult.value,
                details:
                    'Weight/Area: ${controller.stiffnessWeightCtrl.text} | Bending Length: ${controller.stiffnessBendingCtrl.text}',
              ),
              QualityReviewCardData(
                title: 'Warp Count',
                value: controller.warpCountResult.value,
                details: 'Warp Count: ${controller.warpCountCtrl.text}',
              ),
              QualityReviewCardData(
                title: 'Weft Count',
                value: controller.weftCountResult.value,
                details: 'Weft Count: ${controller.weftCountCtrl.text}',
              ),
              QualityReviewCardData(
                title: 'GSM',
                value: controller.gsmResult.value,
                details:
                    'Weight: ${controller.gsmWeightCtrl.text} g | Area: ${controller.gsmAreaCtrl.text} m²',
              ),
              QualityReviewCardData(
                title: 'Tensile Strength',
                value: controller.tensileStrengthResult.value,
                footerLabel: 'Force:',
                footerValue: controller.tensileForceCtrl.text,
                footerSuffix: ' N',
              ),
              QualityReviewCardData(
                title: 'Tearing Strength',
                value: controller.tearingStrengthResult.value,
                footerLabel: 'Force:',
                footerValue: controller.tearingForceCtrl.text,
                footerSuffix: ' N',
              ),
              QualityReviewCardData(
                title: 'Bursting Strength',
                value: controller.burstingStrengthResult.value,
                footerLabel: 'Pressure:',
                footerValue: controller.burstingPressureCtrl.text,
                footerSuffix: ' kPa',
              ),
              QualityReviewCardData(
                title: 'Crease Recovery',
                value: controller.creaseRecoveryResult.value,
                details:
                    'Theta1: ${controller.creaseTheta1Ctrl.text}° | Theta2: ${controller.creaseTheta2Ctrl.text}°',
              ),
              QualityReviewCardData(
                title: 'Knit Type',
                value: controller.selectedKnitType.value,
              ),
              QualityReviewCardData(
                title: 'Weave Type',
                value: controller.selectedWeaveType.value,
              ),
            ],
            'savePayload': savePayload,
          },
        );
      },
    );
  }
}
