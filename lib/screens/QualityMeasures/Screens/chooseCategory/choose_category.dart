import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/continue_button.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/quality_responsive_text.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/app_bar_with_back.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/custom_action_card.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/primary_header_container.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/step_Indicator_text/step_indicator_label_text_widget.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/step_progress_indicator.dart';
import 'package:texops/screens/QualityMeasures/Screens/score_screen/view_score.dart';

class ChooseCategoryScreen extends StatelessWidget {
  const ChooseCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
                 
      appBar:  AppBarWithBack(title: 'Select a Testing Metric'),
      backgroundColor: AppColors.cardWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header fpr clipPath
            EPrimaryHeaderContainer(
              child: Column(
                children: [

                  /// Circular Containers indicator
                  StepProgressIndicator(currentStep: 1),

                  /// Circular Containers indicator Label Text ( The text Below them )
                  StepIndicatorLabelTextWidget(currentStep: 1),
                  const SizedBox(height: 40),
                ],
              ),

              // Body
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  QualityResponsiveText(
                    text:
                        'Choose a product category to begin recording\nquality parameters',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 30),
                  CustomActionCard(
                    title: 'Fibre Testing',
                    subtitle: 'Analyse Raw Material Quality Parameters',
                    leadingIcon: Icon(
                      Iconsax.component,
                      color: AppColors.accentOrange,
                    ),
                    onTap: () => Get.toNamed(RoutesNames.qualityFibreTesting),
                  ),

                  const SizedBox(height: 16),
                  CustomActionCard(
                    title: 'Yarn Testing',
                    subtitle: 'Record Specifications for Yarn Samples',
                    leadingIcon: Icon(
                      Iconsax.component,
                      color: AppColors.accentOrange,
                    ),
                    onTap: () => Get.toNamed(RoutesNames.qualityYarnTesting),
                  ),

                  const SizedBox(height: 16),

                  CustomActionCard(
                    title: 'Fabric Testing',
                    subtitle: 'Document Finished Products Quality Standards',
                    leadingIcon: Icon(
                      Iconsax.component,
                      color: AppColors.accentOrange,
                    ),
                    onTap: () => Get.toNamed(RoutesNames.qualityFabricTesting),
                  ),

                  ContinueButton(onPressed: () => Get.to(()=> ViewScoreScreen()), text: 'View Scores')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
