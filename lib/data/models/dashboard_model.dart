import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardStatsModel {
  final int totalGatePasses;
  final int totalBalesCount;
  final double overallQualityRate;
  final int totalUsers;

  DashboardStatsModel({
    required this.totalGatePasses,
    required this.totalBalesCount,
    required this.overallQualityRate,
    required this.totalUsers,
  });

  factory DashboardStatsModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    // Helper to safely parse Firestore Strings into Numbers
    int pInt(dynamic val) => int.tryParse(val?.toString() ?? '0') ?? 0;
    double pDouble(dynamic val) =>
        double.tryParse(val?.toString() ?? '0.0') ?? 0.0;

    int totalTested = pInt(data['total_bales_tested']);
    double totalScore = pDouble(data['total_quality_score']);

    return DashboardStatsModel(
      totalGatePasses: pInt(data['total_gate_passes']),
      totalBalesCount: pInt(data['total_bales_count']),
      overallQualityRate: totalTested > 0 ? (totalScore / totalTested) : 0.0,
      totalUsers: pInt(data['total_users_count']),
    );
  }
}
