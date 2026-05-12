import '../../scoring_models.dart';
import '../../scoring_rules.dart';

class FabricScoreInput {
  FabricScoreInput({
    required this.stiffnessMgCm,
    required this.warpCountEpi,
    required this.weftCountPpi,
    required this.gsm,
    required this.tensileWarpN,
    required this.tensileWeftN,
    required this.tearingStrengthN,
    required this.burstingStrengthKpa,
    required this.creaseRecoveryDeg,
  });

  final double stiffnessMgCm;
  final double warpCountEpi;
  final double weftCountPpi;
  final double gsm;
  final double tensileWarpN;
  final double tensileWeftN;
  final double tearingStrengthN;
  final double burstingStrengthKpa;
  final double creaseRecoveryDeg;
}

class FabricScoreCalculator {
  SectionScore calculate(FabricScoreInput input) {
    final List<MetricScore> metrics = [];

    metrics.add(
      _scoreRangeMetric(
        metric: 'Stiffness (mg*cm)',
        value: input.stiffnessMgCm,
        idealMin: 2,
        idealMax: 120,
        targetMin: 10,
        targetMax: 30,
        criticality: Criticality.important,
      ),
    );

    metrics.add(
      _scoreRangeMetric(
        metric: 'Warp Count (EPI)',
        value: input.warpCountEpi,
        idealMin: 30,
        idealMax: 200,
        targetMin: 80,
        targetMax: 140,
        criticality: Criticality.critical,
      ),
    );

    metrics.add(
      _scoreRangeMetric(
        metric: 'Weft Count (PPI)',
        value: input.weftCountPpi,
        idealMin: 20,
        idealMax: 160,
        targetMin: 60,
        targetMax: 90,
        criticality: Criticality.critical,
      ),
    );

    metrics.add(
      _scoreRangeMetric(
        metric: 'GSM (g/m2)',
        value: input.gsm,
        idealMin: 80,
        idealMax: 600,
        targetMin: 120,
        targetMax: 220,
        criticality: Criticality.critical,
      ),
    );

    final MetricScore tensileMetric = _scoreTensileStrength(
      warpN: input.tensileWarpN,
      weftN: input.tensileWeftN,
    );
    metrics.add(tensileMetric);

    metrics.add(
      _scoreRangeMetric(
        metric: 'Tearing Strength (N)',
        value: input.tearingStrengthN,
        idealMin: 10,
        idealMax: 50,
        targetMin: 15,
        targetMax: 25,
        criticality: Criticality.important,
      ),
    );

    metrics.add(
      _scoreRangeMetric(
        metric: 'Bursting Strength (kPa)',
        value: input.burstingStrengthKpa,
        idealMin: 150,
        idealMax: 600,
        targetMin: 200,
        targetMax: 350,
        criticality: Criticality.important,
      ),
    );

    metrics.add(
      _scoreLowerBoundMetric(
        metric: 'Crease Recovery (deg)',
        value: input.creaseRecoveryDeg,
        idealMin: 120,
        targetMin: 240,
        criticality: Criticality.important,
      ),
    );

    final double finalScore = ScoringRules.weightedAverage(metrics);
    final bool failedCritical = ScoringRules.hasCriticalFailure(metrics);
    final String grade = failedCritical
        ? 'F'
        : ScoringRules.gradeFromScore(finalScore);

    return SectionScore(
      section: 'Fabric',
      finalScore: finalScore,
      grade: grade,
      failedCritical: failedCritical,
      metrics: metrics,
    );
  }

  MetricScore _scoreTensileStrength({
    required double warpN,
    required double weftN,
  }) {
    final double warpScore = ScoringRules.scoreLowerBound(
      value: warpN,
      idealMin: 200,
      targetMin: 300,
    );

    final double weftScore = ScoringRules.scoreLowerBound(
      value: weftN,
      idealMin: 150,
      targetMin: 200,
    );

    final double score = (warpScore + weftScore) / 2;
    final bool passed = warpN >= 200 && weftN >= 150;

    return MetricScore(
      metric: 'Tensile Strength (Warp/Weft avg)',
      value: null,
      score: score,
      weight: ScoringRules.weightFromCriticality(Criticality.critical),
      criticality: Criticality.critical,
      passed: passed,
      notes: 'Warp: ${warpN.toStringAsFixed(1)} N, Weft: ${weftN.toStringAsFixed(1)} N',
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
