import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/quality_responsive_text.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/app_bar_with_back.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/primary_header_container.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/step_Indicator_text/step_indicator_label_text_widget.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/step_progress_indicator.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/expandable_input_card.dart';
import 'package:texops/screens/QualityMeasures/Screens/fibre/widgets/calculated_denier_widget.dart';
import 'package:texops/screens/QualityMeasures/Screens/fibre/widgets/fabric_input_controller.dart';
import 'package:texops/screens/QualityMeasures/Screens/fibre/widgets/fibre_review_continue_button.dart';

class FibreTestingScreen extends StatelessWidget {
  const FibreTestingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get existing controller or create if doesn't exist
    final FibreTestingController controller =
        Get.isRegistered<FibreTestingController>()
        ? Get.find<FibreTestingController>()
        : Get.put(FibreTestingController());

    return Scaffold(
      appBar: AppBarWithBack(title: 'Fibre Testing'),
      backgroundColor: AppColors.cardWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header fpr clipPath
            EPrimaryHeaderContainer(
              child: Column(
                children: [
                  

                  /// Circular Containers indicator
                  StepProgressIndicator(currentStep: 2),

                  /// Circular Containers indicator Label Text ( The text Below them )
                  StepIndicatorLabelTextWidget(currentStep: 2),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            // --Body
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

                  //The Expandable Cards
                  Column(
                    children: [
                      // --- FIBRE LENGTH CARD (Single Input) ---
                      Obx(
                        () => StatelessExpandableInputCard(
                          title: 'Fibre Length',
                          // Read state from controller
                          isExpanded: controller.isFibreLengthExpanded.value,
                          // Tell controller to toggle state when clicked
                          onToggle: () => controller.toggleFibreLength(),

                          hasMultipleInputs: false,
                          inputLabels: const ['Length (mm)'],
                          inputHints: const ['e.g., 32.5'],
                          inputControllers: [controller.fibreLengthCtrl],
                          inputFocusNodes: [controller.fibreLengthFocus],
                        ),
                      ),

                      // --- FIBRE DENIER CARD (Multiple Inputs + Formula) ---
                      Obx(
                        () => StatelessExpandableInputCard(
                          title: 'Fibre Denier',
                          // Read state from controller
                          isExpanded: controller.isFibreDenierExpanded.value,
                          onToggle: () => controller.toggleFibreDenier(),

                          hasMultipleInputs: true,
                          inputLabels: const ['Weight', 'Length'],
                          inputHints: const ['e.g., 0.5 g', 'e.g., 4500 m'],
                          inputControllers: [
                            controller.weightCtrl,
                            controller.lengthCtrl,
                          ],
                          inputFocusNodes: [
                            controller.weightFocus,
                            controller.lengthFocus,
                          ],

                          // Inject the Formula UI dynamically!
                          bottomWidget: Obx(
                            () => CalculatedDenierWidget(
                              // Pass the live calculated result down to the widget
                              calculatedValue:
                                  controller.calculatedDenierResult.value,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  FibreReviewContinueButton(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
