import 'scoring_models.dart';

class ScoringRules {
  static int weightFromCriticality(Criticality criticality) {
    switch (criticality) {
      case Criticality.critical:
        return 3;
      case Criticality.important:
        return 2;
      case Criticality.standard:
        return 1;
    }
  }

  static double scoreRangeTarget({
    required double value,
    required double idealMin,
    required double idealMax,
    required double targetMin,
    required double targetMax,
  }) {
    if (value < idealMin || value > idealMax) return 0;
    if (value >= targetMin && value <= targetMax) return 100;

    if (value < targetMin) {
      return 60 + 40 * ((value - idealMin) / (targetMin - idealMin));
    }

    return 60 + 40 * ((idealMax - value) / (idealMax - targetMax));
  }

  static double scoreLowerBound({
    required double value,
    required double idealMin,
    required double targetMin,
  }) {
    if (value < idealMin) return 0;
    if (value >= targetMin) return 100;

    return 60 + 40 * ((value - idealMin) / (targetMin - idealMin));
  }

  static double weightedAverage(List<MetricScore> metrics) {
    final int totalWeight = metrics.fold(0, (sum, m) => sum + m.weight);
    if (totalWeight == 0) return 0;

    final double total = metrics.fold(
      0,
      (sum, m) => sum + (m.score * m.weight),
    );

    return total / totalWeight;
  }

  static String gradeFromScore(double score) {
    if (score >= 90) return 'A';
    if (score >= 80) return 'B';
    if (score >= 70) return 'C';
    if (score >= 60) return 'D';
    return 'F';
  }

  static bool hasCriticalFailure(List<MetricScore> metrics) {
    return metrics.any(
      (m) => m.criticality == Criticality.critical && !m.passed,
    );
  }
}
