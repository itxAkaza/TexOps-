enum Criticality { critical, important, standard }

class MetricScore {
  MetricScore({
    required this.metric,
    required this.value,
    required this.score,
    required this.weight,
    required this.criticality,
    required this.passed,
    this.notes,
  });

  final String metric;
  final double? value;
  final double score;
  final int weight;
  final Criticality criticality;
  final bool passed;
  final String? notes;
}

class SectionScore {
  SectionScore({
    required this.section,
    required this.finalScore,
    required this.grade,
    required this.failedCritical,
    required this.metrics,
  });

  final String section;
  final double finalScore;
  final String grade;
  final bool failedCritical;
  final List<MetricScore> metrics;
}
