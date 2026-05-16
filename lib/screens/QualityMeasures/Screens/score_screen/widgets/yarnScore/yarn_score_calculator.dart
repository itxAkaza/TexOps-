import 'dart:math';

import '../../scoring_models.dart';
import '../../scoring_rules.dart';

class YarnScoreInput {
  YarnScoreInput({
    required this.actualCountNe,
    required this.tenacityCnTex,
    required this.elongationPct,
    required this.clsp,
    required this.tpm,
  });

  final double actualCountNe;
  final double tenacityCnTex;
  final double elongationPct;
  final double clsp;
  final double tpm;
}

class YarnScoreCalculator {
  SectionScore calculate(YarnScoreInput input) {
    final List<MetricScore> metrics = [];

    metrics.add(
      _scoreRangeMetric(
        metric: 'Actual Count (Ne)',
        value: input.actualCountNe,
        idealMin: 6,
        idealMax: 120,
        targetMin: 20,
        targetMax: 40,
        criticality: Criticality.critical,
      ),
    );

    metrics.add(
      _scoreLowerBoundMetric(
        metric: 'Tenacity (cN/tex)',
        value: input.tenacityCnTex,
        idealMin: 12,
        targetMin: 15,
        criticality: Criticality.critical,
      ),
    );

    metrics.add(
      _scoreRangeMetric(
        metric: 'Elongation (%)',
        value: input.elongationPct,
        idealMin: 4,
        idealMax: 10,
        targetMin: 5,
        targetMax: 7,
        criticality: Criticality.important,
      ),
    );

    metrics.add(
      _scoreLowerBoundMetric(
        metric: 'CLSP (CSP)',
        value: input.clsp,
        idealMin: 2000,
        targetMin: 2700,
        criticality: Criticality.critical,
      ),
    );

    final double tm = _calculateTm(input.tpm, input.actualCountNe);
    metrics.add(
      _scoreRangeMetric(
        metric: 'Twist Multiplier (TM)',
        value: tm,
        idealMin: 400,
        idealMax: 2000,
        targetMin: 650,
        targetMax: 1050,
        criticality: Criticality.important,
        notes: 'TPM = Twists / Length',
      ),
    );

    final double finalScore = ScoringRules.weightedAverage(metrics);
    const bool failedCritical = false;
    final String grade = ScoringRules.gradeFromScore(finalScore);

    return SectionScore(
      section: 'Yarn',
      finalScore: finalScore,
      grade: grade,
      failedCritical: failedCritical,
      metrics: metrics,
    );
  }

  double _calculateTm(double tpm, double countNe) {
    if (countNe <= 0) return 0;
    return tpm / sqrt(countNe);
  }

  MetricScore _scoreRangeMetric({
    required String metric,
    required double value,
    required double idealMin,
    required double idealMax,
    required double targetMin,
    required double targetMax,
    required Criticality criticality,
    String? notes,
  }) {
    final double score = ScoringRules.scoreRangeTarget(
      value: value,
      idealMin: idealMin,
      idealMax: idealMax,
      targetMin: targetMin,
      targetMax: targetMax,
    );

    return MetricScore(
      metric: metric,
      value: value,
      score: score,
      weight: ScoringRules.weightFromCriticality(criticality),
      criticality: criticality,
      passed: value >= idealMin && value <= idealMax,
      notes: notes,
    );
  }

  MetricScore _scoreLowerBoundMetric({
    required String metric,
    required double value,
    required double idealMin,
    required double targetMin,
    required Criticality criticality,
  }) {
    final double score = ScoringRules.scoreLowerBound(
      value: value,
      idealMin: idealMin,
      targetMin: targetMin,
    );

    return MetricScore(
      metric: metric,
      value: value,
      score: score,
      weight: ScoringRules.weightFromCriticality(criticality),
      criticality: criticality,
      passed: value >= idealMin,
    );
  }
}
