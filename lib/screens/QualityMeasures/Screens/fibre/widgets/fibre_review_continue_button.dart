import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/continue_button.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/quality_review_screen.dart';
import 'package:texops/screens/QualityMeasures/Screens/fibre/widgets/fabric_input_controller.dart';
import 'package:texops/data/models/quality_testing/quality_test_models.dart';

class FibreReviewContinueButton extends StatelessWidget {
  const FibreReviewContinueButton({super.key, required this.controller});

  final FibreTestingController controller;

  bool _hasValue(TextEditingController controller) {
    return controller.text.trim().isNotEmpty;
  }

  bool _isValid() {
    return _hasValue(controller.fibreLengthCtrl) &&
        _hasValue(controller.weightCtrl) &&
        _hasValue(controller.lengthCtrl);
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

        final double? fibreLength = _parseDouble(controller.fibreLengthCtrl.text);
        final double? fibreDenier =
            _parseDouble(controller.calculatedDenierResult.value);
        if (fibreLength == null || fibreDenier == null) {
          _showMissingFields();
          return;
        }

        final Map<String, dynamic> metrics = FibreMetrics(
          fibreLengthMm: fibreLength,
          fibreDenier: fibreDenier,
        ).toMap();
        metrics['inputWeight'] = controller.weightCtrl.text.trim();
        metrics['inputLength'] = controller.lengthCtrl.text.trim();

        final QualityTestPayload savePayload = QualityTestPayload(
          baleRecordId: baleRecordId,
          baleId: baleId,
          category: QualityTestCategory.fibre,
          metrics: metrics,
        );

        Get.toNamed(
          RoutesNames.qualityReview,
          arguments: {
            'testType': 'Fibre Testing',
            'cards': [
              QualityReviewCardData(
                title: 'Fibre Length',
                value: '${controller.fibreLengthCtrl.text} mm',
              ),
              QualityReviewCardData(
                title: 'Fibre Denier',
                details:
                    'Weight: ${controller.weightCtrl.text} g | Length: ${controller.lengthCtrl.text} m',
                footerLabel: 'Final Denier:',
                footerValue: controller.calculatedDenierResult.value,
                footerSuffix: ' D',
              ),
            ],
            'savePayload': savePayload,
          },
        );
      },
    );
  }
}
