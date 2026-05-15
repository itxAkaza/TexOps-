import 'gate_pass_model.dart';

class VendorQualityModel {
  final String vendorName, materialType;
  final List<GatePassModel> bails;

  VendorQualityModel({
    required this.vendorName,
    required this.materialType,
    required this.bails,
  });

  double get averageScore {
    if (bails.isEmpty) return 0.0;
    double total = bails.fold(0.0, (sum, item) {
      final s = item.qualitySummaries ?? {};
      double f = double.tryParse(s['fibreScore']?.toString() ?? '0') ?? 0.0;
      double y = double.tryParse(s['yarnScore']?.toString() ?? '0') ?? 0.0;
      double b = double.tryParse(s['fabricScore']?.toString() ?? '0') ?? 0.0;
      return sum + ((f + y + b) / 3);
    });
    return total / bails.length;
  }
}
