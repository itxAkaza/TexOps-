import '../../scoring_models.dart';
import '../../scoring_rules.dart';

class FibreScoreInput {
  FibreScoreInput({
    required this.fibreLengthMm,
    required this.fibreDenier,
  });

  final double fibreLengthMm;
  final double fibreDenier;
}

class FibreScoreCalculator {
  SectionScore calculate(FibreScoreInput input) {
    final List<MetricScore> metrics = [];

    metrics.add(
      _scoreRangeMetric(
        metric: 'Fibre Length (mm)',
        value: input.fibreLengthMm,
        idealMin: 22,
        idealMax: 38,
        targetMin: 28,
        targetMax: 32,
        criticality: Criticality.critical,
      ),
    );

    metrics.add(
      _scoreRangeMetric(
        metric: 'Fibre Denier (D)',
        value: input.fibreDenier,
        idealMin: 1.0,
        idealMax: 2.5,
        targetMin: 1.2,
        targetMax: 1.5,
        criticality: Criticality.critical,
      ),
    );

    final double finalScore = ScoringRules.weightedAverage(metrics);
    const bool failedCritical = false;
    final String grade = ScoringRules.gradeFromScore(finalScore);

    return SectionScore(
      section: 'Fibre',
      finalScore: finalScore,
      grade: grade,
      failedCritical: failedCritical,
      metrics: metrics,
    );
  }

  MetricScore _scoreRangeMetric({
    required String metric,
    required double value,
    required double idealMin,
    required double idealMax,
    required double targetMin,
    required double targetMax,
    required Criticality criticality,
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
    );
  }
}
