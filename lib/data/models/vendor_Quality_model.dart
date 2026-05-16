import 'gate_pass_model.dart';

class VendorQualityModel {
  final String vendorName;
  final String materialType;
  final List<GatePassModel> bails;

  final bool hasData;
  final double totalScore;

  VendorQualityModel({
    required this.vendorName,
    required this.materialType,
    required this.bails,
  }) : hasData = bails.any((b) => b.qualitySummaries != null),
       totalScore = _calculateAverage(bails);

  static double _calculateAverage(List<GatePassModel> bails) {
    final tested = bails.where((b) => b.qualitySummaries != null).toList();
    if (tested.isEmpty) return 0.0;

    double sum = 0.0;
    for (var bail in tested) {
      final s = bail.qualitySummaries!;

      // Safe extraction from nested maps matching Abdullah's exact keys
      double f = _parse(s['qualitytests.fibre']?['calculatedScore']);
      double y = _parse(s['qualitytests.yarn']?['calculatedScore']);
      double b = _parse(s['qualitytests.fabric']?['calculatedScore']);

      sum += (f + y + b) / 3;
    }
    return sum / tested.length;
  }

  static double _parse(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
