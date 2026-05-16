import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardStatsModel {
  final int totalBalesCount;
  final double
  totalBalesTested; // Changed to double to match your database exactly
  final int totalGatePasses;
  final double totalQualityScore;
  final int totalUsers;

  DashboardStatsModel({
    required this.totalBalesCount,
    required this.totalBalesTested,
    required this.totalGatePasses,
    required this.totalQualityScore,
    required this.totalUsers,
  });

  /// Factory constructor to parse fields completely crash-free
  factory DashboardStatsModel.fromSnapshot(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};

    return DashboardStatsModel(
      // (data['field'] as num).toInt() or .toDouble() protects against mixed types
      totalBalesCount: data['total_bales_count'] != null
          ? (data['total_bales_count'] as num).toInt()
          : 0,
      totalBalesTested: data['total_bales_tested'] != null
          ? (data['total_bales_tested'] as num).toDouble()
          : 0.0,
      totalGatePasses: data['total_gate_passes'] != null
          ? (data['total_gate_passes'] as num).toInt()
          : 0,
      totalQualityScore: data['total_quality_score'] != null
          ? (data['total_quality_score'] as num).toDouble()
          : 0.0,
      totalUsers: data['total_users'] != null
          ? (data['total_users'] as num).toInt()
          : 0,
    );
  }
}
