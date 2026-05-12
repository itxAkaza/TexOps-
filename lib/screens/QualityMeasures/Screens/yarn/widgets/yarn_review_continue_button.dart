import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/continue_button.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/quality_review_screen.dart';
import 'package:texops/screens/QualityMeasures/Screens/yarn/widgets/yarn_controller.dart';

class YarnReviewContinueButton extends StatelessWidget {
  const YarnReviewContinueButton({super.key, required this.controller});

  final YarnTestingController controller;

  bool _hasValue(TextEditingController controller) {
    return controller.text.trim().isNotEmpty;
  }

  bool _isValid() {
    return _hasValue(controller.lengthCtrl) &&
        _hasValue(controller.weightCtrl) &&
        _hasValue(controller.forceCtrl) &&
        _hasValue(controller.texCtrl) &&
        _hasValue(controller.finalLengthCtrl) &&
        _hasValue(controller.originalLengthCtrl) &&
        _hasValue(controller.clspCountCtrl) &&
        _hasValue(controller.strengthCtrl) &&
        _hasValue(controller.twistsCtrl) &&
        _hasValue(controller.tpmLengthCtrl);
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
            'testType': 'Yarn Testing',
            'cards': [
              QualityReviewCardData(
                title: 'Actual Count',
                value: controller.actualCountResult.value,
                details:
                    'Length: ${controller.lengthCtrl.text} yards | Weight: ${controller.weightCtrl.text} lbs',
              ),
              QualityReviewCardData(
                title: 'Tenacity',
                value: controller.tenacityResult.value,
                details:
                    'Breaking Force: ${controller.forceCtrl.text} cN | Tex: ${controller.texCtrl.text}',
              ),
              QualityReviewCardData(
                title: 'Elongation (%)',
                value: controller.elongationResult.value,
                details:
                    'Final Length: ${controller.finalLengthCtrl.text} m | Original Length: ${controller.originalLengthCtrl.text} m',
              ),
              QualityReviewCardData(
                title: 'CLSP (CSP)',
                value: controller.clspResult.value,
                details:
                    'Count: ${controller.clspCountCtrl.text} | Strength: ${controller.strengthCtrl.text}',
              ),
              QualityReviewCardData(
                title: 'Actual TPM',
                value: controller.tpmResult.value,
                details:
                    'Twists: ${controller.twistsCtrl.text} | Length: ${controller.tpmLengthCtrl.text} m',
              ),
            ],
          },
        );
      },
    );
  }
}
