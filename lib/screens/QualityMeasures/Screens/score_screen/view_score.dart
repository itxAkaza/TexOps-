import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/controllers/quality_testing/quality_testing_controller.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/quality_responsive_text.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/app_bar_with_back.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/primary_header_container.dart';
import 'scoring_models.dart';
export 'scoring_models.dart';
export 'scoring_rules.dart';
export 'widgets/fibreScore/fibre_score_calculator.dart';
export 'widgets/yarnScore/yarn_score_calculator.dart';
export 'widgets/fabricScore/fabric_score_calculator.dart';

class ViewScoreScreen extends StatelessWidget {
	const ViewScoreScreen({
		super.key,
		required this.baleRecordId,
		required this.baleId,
	});

	final String baleRecordId;
	final String baleId;

	@override
	Widget build(BuildContext context) {
		final QualityTestingController controller =
				Get.isRegistered<QualityTestingController>()
				? Get.find<QualityTestingController>()
				: Get.put(QualityTestingController());
		WidgetsBinding.instance.addPostFrameCallback((_) {
			FocusManager.instance.primaryFocus?.unfocus();
		});
		controller.loadBaleScores(baleRecordId, baleId);

		return Scaffold(
									
      
			backgroundColor: AppColors.cardWhite,
			body: SingleChildScrollView(
				child: Column(
					children: [
						EPrimaryHeaderContainer(
							child: Column(
								children: [
                  AppBarWithBack(title: 'Quality Scores'),

									const SizedBox(height: 40),
								],
							),
						),
						Padding(
							padding: const EdgeInsets.all(8.0),
							child: Column(
								children: [
									const SizedBox(height: 12),
									QualityResponsiveText(
										text: 'Review section scores and metric breakdowns.',
										style: GoogleFonts.poppins(
											fontSize: 15,
											color: Colors.grey,
										),
										textAlign: TextAlign.center,
										maxLines: 2,
									),
									const SizedBox(height: 24),
									Obx(() {
										if (controller.isLoading.value) {
											return _loadingState();
										}

										final List<SectionScore> sections = [
											if (controller.fibreScore.value != null)
												controller.fibreScore.value!,
											if (controller.yarnScore.value != null)
												controller.yarnScore.value!,
											if (controller.fabricScore.value != null)
												controller.fabricScore.value!,
										];

										if (sections.isEmpty) {
											return _emptyState();
										}

										final List<Widget> cards =
											sections.map(_buildSectionCard).toList();
										if (controller.overallBaleScore.value != null) {
											cards.add(
												_buildOverallScoreCard(
													controller.overallBaleScore.value!,
												),
											);
										}

										return Column(children: cards);
									}),
									const SizedBox(height: 24),
								],
							),
						),
					],
				),
			),
		);
	}

	Widget _loadingState() {
		return Container(
			width: double.infinity,
			padding: const EdgeInsets.all(20),
			decoration: BoxDecoration(
				color: AppColors.cardOffWhite,
				borderRadius: BorderRadius.circular(18),
			),
			child: const Center(
				child: CircularProgressIndicator(
					color: AppColors.primaryDarkTeal,
				),
			),
		);
	}

	Widget _emptyState() {
		return Container(
			width: double.infinity,
			padding: const EdgeInsets.all(20),
			decoration: BoxDecoration(
				color: AppColors.cardOffWhite,
				borderRadius: BorderRadius.circular(18),
			),
			child: QualityResponsiveText(
				text: 'No score data yet. Complete a test to view results.',
				style: GoogleFonts.poppins(
					fontSize: 14,
					color: AppColors.textGrey,
					fontWeight: FontWeight.w500,
				),
				textAlign: TextAlign.center,
				maxLines: 2,
			),
		);
	}

	Widget _buildSectionCard(SectionScore section) {
		return Container(
			width: double.infinity,
			margin: const EdgeInsets.only(bottom: 16),
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration(
				color: AppColors.cardOffWhite,
				borderRadius: BorderRadius.circular(18),
				boxShadow: [
					BoxShadow(
						color: Colors.black.withValues(alpha: 0.05),
						blurRadius: 12,
						offset: const Offset(0, 4),
					),
				],
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Row(
						children: [
							Expanded(
								child: QualityResponsiveText(
									text: '${section.section} Section',
									style: GoogleFonts.poppins(
										fontSize: 18,
										fontWeight: FontWeight.w700,
										color: AppColors.primaryDarkTeal,
									),
									maxLines: 1,
								),
							),
							_scorePill(section),
						],
					),
					const SizedBox(height: 12),
					const SizedBox(height: 16),
					...section.metrics.map(_buildMetricRow),
				],
			),
		);
	}

	Widget _buildOverallScoreCard(double score) {
		return Container(
			width: double.infinity,
			margin: const EdgeInsets.only(bottom: 16),
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration(
				color: Colors.white,
				borderRadius: BorderRadius.circular(18),
				border: Border.all(color: Colors.grey.shade200, width: 1.5),
				boxShadow: [
					BoxShadow(
						color: Colors.black.withValues(alpha: 0.04),
						blurRadius: 10,
						offset: const Offset(0, 4),
					),
				],
			),
			child: Row(
				children: [
					Expanded(
						child: QualityResponsiveText(
							text: 'Overall Bale Score',
							style: GoogleFonts.poppins(
								fontSize: 16,
								fontWeight: FontWeight.w700,
								color: AppColors.primaryDarkTeal,
							),
							maxLines: 1,
						),
					),
					Container(
						padding:
							const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
						decoration: BoxDecoration(
							color: AppColors.primaryDarkTeal,
							borderRadius: BorderRadius.circular(18),
						),
						child: Text(
							score.toStringAsFixed(1),
							style: const TextStyle(
								fontSize: 14,
								fontWeight: FontWeight.w700,
								color: Colors.white,
							),
						),
					),
				],
			),
		);
	}

	Widget _scorePill(SectionScore section) {
		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
			decoration: BoxDecoration(
				color: AppColors.primaryDarkTeal,
				borderRadius: BorderRadius.circular(20),
			),
			child: Row(
				mainAxisSize: MainAxisSize.min,
				children: [
					Text(
						section.finalScore.toStringAsFixed(1),
						style: const TextStyle(
							fontSize: 14,
							fontWeight: FontWeight.w700,
							color: Colors.white,
						),
					),
					const SizedBox(width: 6),
					Text(
						section.grade,
						style: const TextStyle(
							fontSize: 14,
							fontWeight: FontWeight.w700,
							color: Colors.white,
						),
					),
				],
			),
		);
	}

	Widget _statusBanner({
		required String text,
		required Color color,
		required Color textColor,
	}) {
		return Container(
			width: double.infinity,
			padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
			decoration: BoxDecoration(
				color: color,
				borderRadius: BorderRadius.circular(12),
			),
			child: Text(
				text,
				style: TextStyle(
					fontSize: 12,
					fontWeight: FontWeight.w600,
					color: textColor,
				),
			),
		);
	}

	Widget _buildMetricRow(MetricScore metric) {
		final Color chipColor = _criticalityColor(metric.criticality);

		return Container(
			width: double.infinity,
			margin: const EdgeInsets.only(bottom: 12),
			padding: const EdgeInsets.all(12),
			decoration: BoxDecoration(
				color: AppColors.cardWhite,
				borderRadius: BorderRadius.circular(14),
				border: Border.all(color: Colors.grey.shade200),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Row(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Expanded(
								child: QualityResponsiveText(
									text: metric.metric,
									style: GoogleFonts.poppins(
										fontSize: 14,
										fontWeight: FontWeight.w600,
										color: AppColors.primaryDarkTeal,
									),
									maxLines: 2,
								),
							),
							Container(
								padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
								decoration: BoxDecoration(
									color: chipColor.withValues(alpha: 0.15),
									borderRadius: BorderRadius.circular(10),
								),
								child: Text(
									_criticalityLabel(metric.criticality),
									style: TextStyle(
										fontSize: 11,
										fontWeight: FontWeight.w600,
										color: chipColor,
									),
								),
							),
						],
					),
					const SizedBox(height: 8),
					Row(
						children: [
							_metricBadge(
								label: 'Score',
								value: metric.score.toStringAsFixed(1),
							),
							const SizedBox(width: 8),
							_metricBadge(
								label: 'Value',
								value: metric.value?.toStringAsFixed(2) ?? '-',
							),
							const SizedBox(width: 8),
							_metricBadge(
								label: 'Weight',
								value: metric.weight.toString(),
							),
						],
					),
					if (metric.notes != null) ...[
						const SizedBox(height: 8),
						Text(
							metric.notes!,
							style: const TextStyle(
								fontSize: 12,
								color: Colors.grey,
								fontWeight: FontWeight.w500,
							),
						),
					],
				],
			),
		);
	}

	Widget _metricBadge({required String label, required String value}) {
		return Expanded(
			child: Container(
				padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
				decoration: BoxDecoration(
					color: AppColors.backgroundLightPeach,
					borderRadius: BorderRadius.circular(12),
				),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(
							label,
							style: const TextStyle(
								fontSize: 11,
								color: AppColors.textGrey,
								fontWeight: FontWeight.w600,
							),
						),
						const SizedBox(height: 4),
						Text(
							value,
							style: const TextStyle(
								fontSize: 13,
								color: AppColors.primaryDarkTeal,
								fontWeight: FontWeight.w700,
							),
							maxLines: 1,
							overflow: TextOverflow.ellipsis,
						),
					],
				),
			),
		);
	}

	Color _criticalityColor(Criticality criticality) {
		switch (criticality) {
			case Criticality.critical:
				return const Color(0xFFB42318);
			case Criticality.important:
				return const Color(0xFFB54708);
			case Criticality.standard:
				return const Color(0xFF175CD3);
		}
	}

	String _criticalityLabel(Criticality criticality) {
		switch (criticality) {
			case Criticality.critical:
				return 'Critical';
			case Criticality.important:
				return 'Important';
			case Criticality.standard:
				return 'Standard';
		}
	}
}
