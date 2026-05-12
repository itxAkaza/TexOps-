import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/app_bar_with_back.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/primary_header_container.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/step_Indicator_text/step_indicator_label_text_widget.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/step_progress_indicator.dart';
import 'package:texops/screens/QualityMeasures/Screens/fibre/expandable_input_card.dart';
import 'package:texops/screens/QualityMeasures/Screens/fibre/widgets/calculated_denier_widget.dart';
import 'package:texops/screens/QualityMeasures/Screens/fibre/widgets/fabric_input_controller.dart';

class FibreTestingScreen extends StatelessWidget {
  FibreTestingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get existing controller or create if doesn't exist
    final FibreTestingController controller = Get.isRegistered<FibreTestingController>() 
        ? Get.find<FibreTestingController>() 
        : Get.put(FibreTestingController());

    return Scaffold(
      backgroundColor: AppColors.cardWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header fpr clipPath
            EPrimaryHeaderContainer(
              child: Column(
                children: [
                  AppBarWithBack(title: 'Fibre Testing'),

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
                  Text(
                    'Expand attributes to input lab test values',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
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

                          // Inject the Formula UI dynamically!
                          bottomWidget: CalculatedDenierWidget(
                            // Pass the live calculated result down to the widget
                            calculatedValue:
                                controller.calculatedDenierResult.value,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 4. The Bottom Button
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  AppColors.primaryDarkTeal, // Dark Teal
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Navigate to Screen 3 (Review & Save)
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue to Review',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontSize: 15 , fontWeight: .bold , color: AppColors.cardWhite )
                            )
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 20 , color: AppColors.cardWhite,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
