import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/quality_responsive_text.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/app_bar_with_back.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/primary_header_container.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/step_Indicator_text/step_indicator_label_text_widget.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/step_progress_indicator.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/expandable_input_card.dart';
import 'package:texops/screens/QualityMeasures/Screens/yarn/widgets/yarn_calculated_result.dart';
import 'package:texops/screens/QualityMeasures/Screens/yarn/widgets/yarn_controller.dart';
import 'package:texops/screens/QualityMeasures/Screens/yarn/widgets/yarn_review_continue_button.dart';
// Import the new widget
// import 'package:texops/screens/QualityMeasures/Screens/yarn/widgets/calculated_result_widget.dart';

class YarnTestingScreen extends StatelessWidget {
  const YarnTestingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get existing controller or create if doesn't exist
    final YarnTestingController controller =
        Get.isRegistered<YarnTestingController>()
        ? Get.find<YarnTestingController>()
        : Get.put(YarnTestingController());

    return Scaffold(
                  
      appBar: AppBarWithBack(title: 'Yarn Testing'),
      backgroundColor: AppColors.cardWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            EPrimaryHeaderContainer(
              child: Column(
                children: [

                  /// Circular Containers indicator
                  StepProgressIndicator(currentStep: 2),

                  /// Circular Containers indicator Label Text
                  StepIndicatorLabelTextWidget(currentStep: 2),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            //--Body
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  QualityResponsiveText(
                    text: 'Expand attributes to input lab test values',
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 30),

                  Column(
                    children: [
                      // --- ACTUAL COUNT CARD ---
                      // ... inside your Column in YarnTestingScreen

                      // --- ACTUAL COUNT CARD ---
                      Obx(() {
                        // 1. Read ONLY the expansion state here in the outer Obx
                        final bool isExpanded =
                            controller.isActualCountExpanded.value;

                        return StatelessExpandableInputCard(
                          title: 'Actual Count',
                          isExpanded: isExpanded,
                          onToggle: () => controller.toggleActualCount(),
                          hasMultipleInputs: true,
                          inputLabels: const ['Length (yards)', 'Weight (lbs)'],
                          inputHints: const ['e.g., 120', '0.005'],
                          inputControllers: [
                            controller.lengthCtrl,
                            controller.weightCtrl,
                          ],
                          inputFocusNodes: [
                            controller.lengthFocus,
                            controller.weightFocus,
                          ],

                          // 2. Wrap ONLY the bottom widget in its own Obx!
                          bottomWidget: Obx(
                            () => CalculatedResultWidget(
                              formulaText:
                                  'Formula: Count = Length / (840 * Weight)',
                              resultTitle: 'Calculated Count:',

                              // Because this .value is inside the inner Obx,
                              // ONLY the yellow box will rebuild when you type!
                              calculatedValue:
                                  controller.actualCountResult.value,
                            ),
                          ),
                        );
                      }),

                      // --- Tenacity CARD ---
                      Obx(() {
                        // 1. Read ONLY the expansion state here in the outer Obx
                        final bool isExpanded =
                            controller.isTenacityExpanded.value;

                        return StatelessExpandableInputCard(
                          title: 'Tenacity',
                          isExpanded: isExpanded,
                          onToggle: () => controller.toggleTenacity(),
                          hasMultipleInputs: true,
                          inputLabels: const ['Breaking Force (cN)', 'Tex'],
                          inputHints: const ['e.g., 120', '20'],
                          inputControllers: [
                            controller.forceCtrl,
                            controller.texCtrl,
                          ],
                          inputFocusNodes: [
                            controller.forceFocus,
                            controller.texFocus,
                          ],

                          // 2. Wrap ONLY the bottom widget in its own Obx!
                          bottomWidget: Obx(
                            () => CalculatedResultWidget(
                              formulaText:
                                  'Formula: Tenacity = Breaking Force (cN) / Tex',
                              resultTitle: 'Calculated Tenacity:',

                              // Because this .value is inside the inner Obx,
                              // ONLY the yellow box will rebuild when you type!
                              calculatedValue: controller.tenacityResult.value,
                            ),
                          ),
                        );
                      }),

                      // --- Elongation CARD ---
                      Obx(() {
                        // 1. Read ONLY the expansion state here in the outer Obx
                        final bool isExpanded =
                            controller.isElongationExpanded.value;

                        return StatelessExpandableInputCard(
                          title: 'Elogation (%)',
                          isExpanded: isExpanded,
                          onToggle: () => controller.toggleElongation(),
                          hasMultipleInputs: true,
                          inputLabels: const [
                            'Final Length (m)',
                            'Original Length(m)',
                          ],
                          inputHints: const ['e.g., 20', '120'],
                          inputControllers: [
                            controller.finalLengthCtrl,
                            controller.originalLengthCtrl,
                          ],
                          inputFocusNodes: [
                            controller.finalLengthFocus,
                            controller.originalLengthFocus,
                          ],

                          // 2. Wrap ONLY the bottom widget in its own Obx!
                          bottomWidget: Obx(
                            () => CalculatedResultWidget(
                              formulaText:
                                  'Formula: Elongation (%) = ((FinalLength - OriginalLength) / OriginalLenth) x 100',
                              resultTitle: 'Calculated Elongation (%):',

                              // Because this .value is inside the inner Obx,
                              // ONLY the yellow box will rebuild when you type!
                              calculatedValue:
                                  controller.elongationResult.value,
                            ),
                          ),
                        );
                      }),

                      // --- CLSP CARD ---
                      Obx(() {
                        // 1. Read ONLY the expansion state here in the outer Obx
                        final bool isExpanded = controller.isCLSPExpanded.value;

                        return StatelessExpandableInputCard(
                          title: 'CLSP (CSP)',
                          isExpanded: isExpanded,
                          onToggle: () => controller.toggleCLSP(),
                          hasMultipleInputs: true,
                          inputLabels: const ['Count', 'Strength'],
                          inputHints: const ['e.g., 30', '2000'],
                          inputControllers: [
                            controller.clspCountCtrl,
                            controller.strengthCtrl,
                          ],
                          inputFocusNodes: [
                            controller.clspCountFocus,
                            controller.strengthFocus,
                          ],

                          // 2. Wrap ONLY the bottom widget in its own Obx!
                          bottomWidget: Obx(
                            () => CalculatedResultWidget(
                              formulaText:
                                  'Formula: CLSP (CSP) = Count x Strength',
                              resultTitle: 'Calculated CLSP (CSP):',

                              // Because this .value is inside the inner Obx,
                              // ONLY the yellow box will rebuild when you type!
                              calculatedValue: controller.clspResult.value,
                            ),
                          ),
                        );
                      }),

                      // --- Actual TPM CARD ---
                      Obx(() {
                        // 1. Read ONLY the expansion state here in the outer Obx
                        final bool isExpanded = controller.isTPMExpanded.value;

                        return StatelessExpandableInputCard(
                          title: 'Actual TPM',
                          isExpanded: isExpanded,
                          onToggle: () => controller.toggleTPM(),
                          hasMultipleInputs: true,
                          inputLabels: const ['Twists', 'Length (m)'],
                          inputHints: const ['e.g., 800', '1'],
                          inputControllers: [
                            controller.twistsCtrl,
                            controller.tpmLengthCtrl,
                          ],
                          inputFocusNodes: [
                            controller.twistsFocus,
                            controller.tpmLengthFocus,
                          ],

                          // 2. Wrap ONLY the bottom widget in its own Obx!
                          bottomWidget: Obx(
                            () => CalculatedResultWidget(
                              formulaText:
                                  'Formula: Actual TPM = Twists / Length (m)',
                              resultTitle: 'Calculated Actual TPM:',

                              // Because this .value is inside the inner Obx,
                              // ONLY the yellow box will rebuild when you type!
                              calculatedValue: controller.tpmResult.value,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),

                  YarnReviewContinueButton(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
