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
    final validBails = bails.where((b) => b.overAllBaleScore != null).toList();
    if (validBails.isEmpty) return 0.0;

    double sum = 0.0;
    for (var bail in validBails) {
      sum += bail.overAllBaleScore!;
    }
    return sum / validBails.length;
  }
}
