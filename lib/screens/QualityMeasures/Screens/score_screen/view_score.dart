import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/quality_responsive_text.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/app_bar_with_back.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/primary_header_container.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/step_Indicator_text/step_indicator_label_text_widget.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/step_progress_indicator.dart';
import 'scoring_models.dart';
export 'scoring_models.dart';
export 'scoring_rules.dart';
export 'widgets/fibreScore/fibre_score_calculator.dart';
export 'widgets/yarnScore/yarn_score_calculator.dart';
export 'widgets/fabricScore/fabric_score_calculator.dart';

class ViewScoreScreen extends StatelessWidget {
	const ViewScoreScreen({
		super.key,
		this.fibreScore,
		this.yarnScore,
		this.fabricScore,
	});

	final SectionScore? fibreScore;
	final SectionScore? yarnScore;
	final SectionScore? fabricScore;

	List<SectionScore> get _sections => [
				if (fibreScore != null) fibreScore!,
				if (yarnScore != null) yarnScore!,
				if (fabricScore != null) fabricScore!,
			];

	@override
	Widget build(BuildContext context) {
		final List<SectionScore> sections = _sections;

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
									if (sections.isEmpty)
										_emptyState()
									else
										...sections.map(_buildSectionCard),
									const SizedBox(height: 24),
								],
							),
						),
					],
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
					if (section.failedCritical)
						_statusBanner(
							text: 'Critical metric out of range',
							color: Colors.red.shade200,
							textColor: Colors.red.shade900,
						)
					else
						_statusBanner(
							text: 'All critical metrics passed',
							color: Colors.green.shade200,
							textColor: Colors.green.shade900,
						),
					const SizedBox(height: 16),
					...section.metrics.map(_buildMetricRow),
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
