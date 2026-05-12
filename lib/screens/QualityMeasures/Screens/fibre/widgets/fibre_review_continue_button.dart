import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/continue_button.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/quality_review_screen.dart';
import 'package:texops/screens/QualityMeasures/Screens/fibre/widgets/fabric_input_controller.dart';

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
          },
        );
      },
    );
  }
}
