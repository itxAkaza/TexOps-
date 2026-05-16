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
    final String? baleRecordId =
      Get.arguments is Map ? (Get.arguments as Map)['baleRecordId'] as String? : null;
    final String? baleId =
        Get.arguments is Map ? (Get.arguments as Map)['baleId'] as String? : null;
    const String fallbackBaleRecordId = '4U8fQ5BdPYhCorczhBwNWArzPHh1';
    const String fallbackBaleId = 'fjk7_260516-1200';

    final String resolvedBaleRecordId =
      (baleRecordId == null || baleRecordId.isEmpty)
        ? fallbackBaleRecordId
        : baleRecordId;
    final String resolvedBaleId = (baleId == null || baleId.isEmpty)
      ? fallbackBaleId
      : baleId;

    final QualityTestingRepository repository = QualityTestingRepository();
    final Future<Map<QualityTestCategory, QualityTestRecord>> recordsFuture =
        repository.fetchQualityTests(resolvedBaleRecordId, resolvedBaleId);

    return Scaffold(
      appBar: AppBarWithBack(title: 'Select a Testing Metric'),
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
              child: FutureBuilder<Map<QualityTestCategory, QualityTestRecord>>(
                future: recordsFuture,
                builder: (context, snapshot) {
                  final Map<QualityTestCategory, QualityTestRecord> records =
                      snapshot.data ?? {};
                  final bool hasFibre = records.containsKey(QualityTestCategory.fibre);
                  final bool hasYarn = records.containsKey(QualityTestCategory.yarn);
                  final bool hasFabric = records.containsKey(QualityTestCategory.fabric);

                  return Column(
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
                    showEditIcon: hasFibre,
                    onTap: hasFibre
                        ? () => Get.snackbar(
                              'Already recorded',
                              'Use the pencil icon to update Fibre Testing.',
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 14,
                              backgroundColor: AppColors.primaryDarkTeal,
                              colorText: AppColors.cardWhite,
                              icon: const Icon(Icons.edit, color: Colors.white),
                              duration: const Duration(seconds: 2),
                            )
                        : () => Get.toNamed(
                              RoutesNames.qualityFibreTesting,
                              arguments: {
                                'baleRecordId': resolvedBaleRecordId,
                                'baleId': resolvedBaleId,
                              },
                            ),
                    onEditTap: hasFibre
                        ? () => Get.toNamed(
                              RoutesNames.qualityFibreTesting,
                              arguments: {
                                'baleRecordId': resolvedBaleRecordId,
                                'baleId': resolvedBaleId,
                              },
                            )
                        : null,
                  ),

                  const SizedBox(height: 16),
                  CustomActionCard(
                    title: 'Yarn Testing',
                    subtitle: 'Record Specifications for Yarn Samples',
                    leadingIcon: Icon(
                      Iconsax.component,
                      color: AppColors.accentOrange,
                    ),
                    showEditIcon: hasYarn,
                    onTap: hasYarn
                        ? () => Get.snackbar(
                              'Already recorded',
                              'Use the pencil icon to update Yarn Testing.',
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 14,
                              backgroundColor: AppColors.primaryDarkTeal,
                              colorText: AppColors.cardWhite,
                              icon: const Icon(Icons.edit, color: Colors.white),
                              duration: const Duration(seconds: 2),
                            )
                        : () => Get.toNamed(
                              RoutesNames.qualityYarnTesting,
                              arguments: {
                                'baleRecordId': resolvedBaleRecordId,
                                'baleId': resolvedBaleId,
                              },
                            ),
                    onEditTap: hasYarn
                        ? () => Get.toNamed(
                              RoutesNames.qualityYarnTesting,
                              arguments: {
                                'baleRecordId': resolvedBaleRecordId,
                                'baleId': resolvedBaleId,
                              },
                            )
                        : null,
                  ),

                  const SizedBox(height: 16),

                  CustomActionCard(
                    title: 'Fabric Testing',
                    subtitle: 'Document Finished Products Quality Standards',
                    leadingIcon: Icon(
                      Iconsax.component,
                      color: AppColors.accentOrange,
                    ),
                    showEditIcon: hasFabric,
                    onTap: hasFabric
                        ? () => Get.snackbar(
                              'Already recorded',
                              'Use the pencil icon to update Fabric Testing.',
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 14,
                              backgroundColor: AppColors.primaryDarkTeal,
                              colorText: AppColors.cardWhite,
                              icon: const Icon(Icons.edit, color: Colors.white),
                              duration: const Duration(seconds: 2),
                            )
                        : () => Get.toNamed(
                              RoutesNames.qualityFabricTesting,
                              arguments: {
                                'baleRecordId': resolvedBaleRecordId,
                                'baleId': resolvedBaleId,
                              },
                            ),
                    onEditTap: hasFabric
                        ? () => Get.toNamed(
                              RoutesNames.qualityFabricTesting,
                              arguments: {
                                'baleRecordId': resolvedBaleRecordId,
                                'baleId': resolvedBaleId,
                              },
                            )
                        : null,
                  ),

                  ContinueButton(
                    onPressed: () {
                      Get.to(
                        () => ViewScoreScreen(
                          baleRecordId: resolvedBaleRecordId,
                          baleId: resolvedBaleId,
                        ),
                      );
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
