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
import 'package:texops/data/fireStoreDB/quality/quality_testing_repository.dart';
import 'package:texops/data/models/quality_testing/quality_test_models.dart';

class ChooseCategoryScreen extends StatelessWidget {
  const ChooseCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });

    // ---> THIS IS THE MAGIC HOOKUP <---
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String resolvedBaleRecordId = args['baleRecordId'] ?? '';
    final String resolvedBaleId = args['baleId'] ?? '';

    // Safety check so it doesn't crash if it loads empty
    if (resolvedBaleRecordId.isEmpty || resolvedBaleId.isEmpty) {
      return const Scaffold(body: Center(child: Text("Error: No Bale Data Found")));
    }

    final QualityTestingRepository repository = QualityTestingRepository();
    final Future<Map<QualityTestCategory, QualityTestRecord>> recordsFuture =
    repository.fetchQualityTests(resolvedBaleRecordId, resolvedBaleId);

    return Scaffold(
      appBar: AppBarWithBack(title: 'Select a Testing Metric'),
      backgroundColor: AppColors.cardWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            EPrimaryHeaderContainer(
              child: Column(
                children: [
                  StepProgressIndicator(currentStep: 1),
                  StepIndicatorLabelTextWidget(currentStep: 1),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<Map<QualityTestCategory, QualityTestRecord>>(
                future: recordsFuture,
                builder: (context, snapshot) {
                  final Map<QualityTestCategory, QualityTestRecord> records = snapshot.data ?? {};
                  final bool hasFibre = records.containsKey(QualityTestCategory.fibre);
                  final bool hasYarn = records.containsKey(QualityTestCategory.yarn);
                  final bool hasFabric = records.containsKey(QualityTestCategory.fabric);

                  return Column(
                    children: [
                      QualityResponsiveText(
                        text: 'Choose a product category to begin recording\nquality parameters',
                        style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 30),

                      CustomActionCard(
                        title: 'Fibre Testing',
                        subtitle: 'Analyse Raw Material Quality Parameters',
                        leadingIcon: const Icon(Iconsax.component, color: AppColors.accentOrange),
                        showEditIcon: hasFibre,
                        onTap: hasFibre
                            ? () => Get.snackbar(
                          'Already recorded', 'Use the pencil icon to update.',
                          snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(16),
                          backgroundColor: AppColors.primaryDarkTeal, colorText: AppColors.cardWhite,
                        )
                            : () => Get.toNamed(RoutesNames.qualityFibreTesting, arguments: {
                          'baleRecordId': resolvedBaleRecordId, 'baleId': resolvedBaleId,
                        }),
                        onEditTap: hasFibre ? () => Get.toNamed(RoutesNames.qualityFibreTesting, arguments: {
                          'baleRecordId': resolvedBaleRecordId, 'baleId': resolvedBaleId,
                        }) : null,
                      ),
                      const SizedBox(height: 16),

                      CustomActionCard(
                        title: 'Yarn Testing',
                        subtitle: 'Record Specifications for Yarn Samples',
                        leadingIcon: const Icon(Iconsax.component, color: AppColors.accentOrange),
                        showEditIcon: hasYarn,
                        onTap: hasYarn
                            ? () => Get.snackbar('Already recorded', 'Use the pencil icon to update.',
                            snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(16),
                            backgroundColor: AppColors.primaryDarkTeal, colorText: AppColors.cardWhite)
                            : () => Get.toNamed(RoutesNames.qualityYarnTesting, arguments: {
                          'baleRecordId': resolvedBaleRecordId, 'baleId': resolvedBaleId,
                        }),
                        onEditTap: hasYarn ? () => Get.toNamed(RoutesNames.qualityYarnTesting, arguments: {
                          'baleRecordId': resolvedBaleRecordId, 'baleId': resolvedBaleId,
                        }) : null,
                      ),
                      const SizedBox(height: 16),

                      CustomActionCard(
                        title: 'Fabric Testing',
                        subtitle: 'Document Finished Products Quality Standards',
                        leadingIcon: const Icon(Iconsax.component, color: AppColors.accentOrange),
                        showEditIcon: hasFabric,
                        onTap: hasFabric
                            ? () => Get.snackbar('Already recorded', 'Use the pencil icon to update.',
                            snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(16),
                            backgroundColor: AppColors.primaryDarkTeal, colorText: AppColors.cardWhite)
                            : () => Get.toNamed(RoutesNames.qualityFabricTesting, arguments: {
                          'baleRecordId': resolvedBaleRecordId, 'baleId': resolvedBaleId,
                        }),
                        onEditTap: hasFabric ? () => Get.toNamed(RoutesNames.qualityFabricTesting, arguments: {
                          'baleRecordId': resolvedBaleRecordId, 'baleId': resolvedBaleId,
                        }) : null,
                      ),

                      const SizedBox(height: 20),
                      ContinueButton(
                        onPressed: () {
                          Get.to(() => ViewScoreScreen(
                            baleRecordId: resolvedBaleRecordId,
                            baleId: resolvedBaleId,
                          ));
                        },
                        text: 'View Scores',
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}