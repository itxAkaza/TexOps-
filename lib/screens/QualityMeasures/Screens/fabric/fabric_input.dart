import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/continue_button.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/quality_responsive_text.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/quality_review_screen.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/app_bar_with_back.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/primary_header_container.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/step_Indicator_text/step_indicator_label_text_widget.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/step_progress_indicator.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/expandable_input_card.dart';

import 'widgets/fabric_controller.dart';
import 'widgets/fabric_result_widget.dart';
import 'widgets/knit_type_widget.dart';
import 'widgets/weave_type_widget.dart';

class FabricTestingScreen extends StatelessWidget {
	const FabricTestingScreen({super.key});

	@override
	Widget build(BuildContext context) {
		final FabricTestingController controller = Get.isRegistered<FabricTestingController>()
				? Get.find<FabricTestingController>()
				: Get.put(FabricTestingController());

		return Scaffold(
			backgroundColor: AppColors.cardWhite,
			body: SingleChildScrollView(
				child: Column(
					children: [
						EPrimaryHeaderContainer(
							child: Column(
								children: [
									AppBarWithBack(title: 'Fabric Testing'),
									StepProgressIndicator(currentStep: 2),
									StepIndicatorLabelTextWidget(currentStep: 2),
									const SizedBox(height: 40),
								],
							),
						),
						Padding(
							padding: const EdgeInsets.all(8.0),
							child: Column(
								children: [
									QualityResponsiveText(
										text: 'Scroll and expand attributes to input fabric data.',
										style: const TextStyle(fontSize: 15, color: Colors.grey),
										textAlign: TextAlign.center,
										maxLines: 2,
									),
									const SizedBox(height: 30),
									Column(
										children: [
											Obx(() {
												final bool isExpanded = controller.isStiffnessExpanded.value;

												return StatelessExpandableInputCard(
													title: 'Stiffness',
													isExpanded: isExpanded,
													onToggle: () => controller.toggleStiffness(),
													hasMultipleInputs: true,
													inputLabels: const ['Weight/Area (W)', 'Bending Length (C)'],
													inputHints: const ['e.g. 150', 'e.g. 2.5'],
													inputControllers: [
														controller.stiffnessWeightCtrl,
														controller.stiffnessBendingCtrl,
													],
													bottomWidget: Obx(
														() => FabricCalculatedResultWidget(
															formulaText: 'Formula: W x (C)',
															resultTitle: 'Calculated Stiffness:',
															calculatedValue: controller.stiffnessResult.value,
														),
													),
												);
											}),
											Obx(() {
												final bool isExpanded = controller.isWarpCountExpanded.value;

												return StatelessExpandableInputCard(
													title: 'Warp Count',
													isExpanded: isExpanded,
													onToggle: () => controller.toggleWarpCount(),
													hasMultipleInputs: false,
													inputLabels: const ['Warp Count'],
													inputHints: const ['e.g. 60'],
													inputControllers: [controller.warpCountCtrl],
													bottomWidget: Obx(
														() => FabricCalculatedResultWidget(
															formulaText: 'Formula: Entered value',
															resultTitle: 'Calculated Warp Count:',
															calculatedValue: controller.warpCountResult.value,
														),
													),
												);
											}),
											Obx(() {
												final bool isExpanded = controller.isWeftCountExpanded.value;

												return StatelessExpandableInputCard(
													title: 'Weft Count',
													isExpanded: isExpanded,
													onToggle: () => controller.toggleWeftCount(),
													hasMultipleInputs: false,
													inputLabels: const ['Weft Count'],
													inputHints: const ['e.g. 40'],
													inputControllers: [controller.weftCountCtrl],
													bottomWidget: Obx(
														() => FabricCalculatedResultWidget(
															formulaText: 'Formula: Entered value',
															resultTitle: 'Calculated Weft Count:',
															calculatedValue: controller.weftCountResult.value,
														),
													),
												);
											}),
											Obx(() {
												final bool isExpanded = controller.isGsmExpanded.value;

												return StatelessExpandableInputCard(
													title: 'GSM',
													isExpanded: isExpanded,
													onToggle: () => controller.toggleGsm(),
													hasMultipleInputs: true,
													inputLabels: const ['Weight (g)', 'Area (m²)'],
													inputHints: const ['e.g. 200', 'e.g. 1'],
													inputControllers: [
														controller.gsmWeightCtrl,
														controller.gsmAreaCtrl,
													],
													bottomWidget: Obx(
														() => FabricCalculatedResultWidget(
															formulaText: 'Formula: Weight / Area',
															resultTitle: 'Calculated GSM:',
															calculatedValue: controller.gsmResult.value,
														),
													),
												);
											}),
											Obx(() {
												final bool isExpanded = controller.isTensileStrengthExpanded.value;

												return StatelessExpandableInputCard(
													title: 'Tensile Strength',
													isExpanded: isExpanded,
													onToggle: () => controller.toggleTensileStrength(),
													hasMultipleInputs: false,
													inputLabels: const ['Force (N)'],
													inputHints: const ['e.g. 450'],
													inputControllers: [controller.tensileForceCtrl],
													bottomWidget: Obx(
														() => FabricCalculatedResultWidget(
															formulaText: 'Formula: Entered value',
															resultTitle: 'Calculated Tensile Strength:',
															calculatedValue: controller.tensileStrengthResult.value,
															units: 'N',
														),
													),
												);
											}),
											Obx(() {
												final bool isExpanded = controller.isTearingStrengthExpanded.value;

												return StatelessExpandableInputCard(
													title: 'Tearing Strength',
													isExpanded: isExpanded,
													onToggle: () => controller.toggleTearingStrength(),
													hasMultipleInputs: false,
													inputLabels: const ['Force (N)'],
													inputHints: const ['e.g. 35'],
													inputControllers: [controller.tearingForceCtrl],
													bottomWidget: Obx(
														() => FabricCalculatedResultWidget(
															formulaText: 'Formula: Entered value',
															resultTitle: 'Calculated Tearing Strength:',
															calculatedValue: controller.tearingStrengthResult.value,
															units: 'N',
														),
													),
												);
											}),
											Obx(() {
												final bool isExpanded = controller.isBurstingStrengthExpanded.value;

												return StatelessExpandableInputCard(
													title: 'Bursting Strength',
													isExpanded: isExpanded,
													onToggle: () => controller.toggleBurstingStrength(),
													hasMultipleInputs: false,
													inputLabels: const ['Pressure (kPa)'],
													inputHints: const ['e.g. 550'],
													inputControllers: [controller.burstingPressureCtrl],
													bottomWidget: Obx(
														() => FabricCalculatedResultWidget(
															formulaText: 'Formula: Entered value',
															resultTitle: 'Calculated Bursting Strength:',
															calculatedValue: controller.burstingStrengthResult.value,
															units: 'kPa',
														),
													),
												);
											}),
											Obx(() {
												final bool isExpanded = controller.isCreaseRecoveryExpanded.value;

												return StatelessExpandableInputCard(
													title: 'Crease Recovery',
													isExpanded: isExpanded,
													onToggle: () => controller.toggleCreaseRecovery(),
													hasMultipleInputs: true,
													inputLabels: const ['Theta1 (°)', 'Theta2 (°)'],
													inputHints: const ['e.g. 120', 'e.g. 115'],
													inputControllers: [
														controller.creaseTheta1Ctrl,
														controller.creaseTheta2Ctrl,
													],
													bottomWidget: Obx(
														() => FabricCalculatedResultWidget(
															formulaText: 'Formula: Theta1 + Theta2',
															resultTitle: 'Calculated Recovery:',
															calculatedValue: controller.creaseRecoveryResult.value,
															units: '°',
														),
													),
												);
											}),
											Obx(() {
												final bool isExpanded = controller.isKnitTypeExpanded.value;

												return StatelessExpandableInputCard(
													title: 'Knit Type',
													isExpanded: isExpanded,
													onToggle: () => controller.toggleKnitType(),
													hasMultipleInputs: true,
													inputLabels: const [],
													inputHints: const [],
													bottomWidget: Obx(
														() => KnitTypeWidget(
															selectedValue: controller.selectedKnitType.value,
															onChanged: (value) => controller.selectedKnitType.value = value,
														),
													),
												);
											}),
											Obx(() {
												final bool isExpanded = controller.isWeaveTypeExpanded.value;

												return StatelessExpandableInputCard(
													title: 'Weave Type',
													isExpanded: isExpanded,
													onToggle: () => controller.toggleWeaveType(),
													hasMultipleInputs: true,
													inputLabels: const [],
													inputHints: const [],
													bottomWidget: Obx(
														() => WeaveTypeWidget(
															selectedValue: controller.selectedWeaveType.value,
															onChanged: (value) => controller.selectedWeaveType.value = value,
														),
													),
												);
											}),
										],
									),
									ContinueButton(
										onPressed: () => Get.toNamed(
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
														details: 'Weight: ${controller.gsmWeightCtrl.text} g | Area: ${controller.gsmAreaCtrl.text} m²',
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
											},
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
