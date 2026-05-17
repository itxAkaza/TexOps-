import 'package:cloud_firestore/cloud_firestore.dart';

class GatePassModel {
  final String id;
  final String gatePassRef;
  final String baleID;
  final String vehicleNumber;
  final String supplier;
  final String arrivalTime;
  final String price;
  final bool qualityStatus;
  final String baleType;
  final String baleCount;
  final bool readyForYarn;
  final DateTime createdAt;
  final Map<String, dynamic>? qualitySummaries;
  final double? overAllBaleScore;

  GatePassModel({
    required this.id,
    required this.gatePassRef,
    required this.vehicleNumber,
    required this.supplier,
    required this.arrivalTime,
    required this.price,
    required this.qualityStatus,
    required this.baleType,
    required this.baleID,
    required this.baleCount,
    required this.readyForYarn,
    required this.createdAt,
    this.qualitySummaries,
    this.overAllBaleScore,
  });

  factory GatePassModel.fromMap(Map<String, dynamic> map, String documentId) {
    return GatePassModel(
      id: documentId,
      baleID: map['baleId'] ?? "",
      gatePassRef: map['gatePassRef'] ?? '',
      vehicleNumber: map['vehicleNumber'] ?? '',
      supplier: map['supplier'] ?? '',
      arrivalTime: map['arrivalTime'] ?? '',
      price: map['price']?.toString() ?? '0',
      qualityStatus: map['qualityStatus'] ?? false,
      baleType: map['baleType'] ?? 'Cotton',
      baleCount: map['baleCount'] ?? '0',
      readyForYarn: map['readyForYarn'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      qualitySummaries: map['qualitySummaries'] is Map
          ? Map<String, dynamic>.from(map['qualitySummaries'] as Map)
          : null,
      overAllBaleScore: map['overAllBaleScore'] is num
          ? (map['overAllBaleScore'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'baleId': baleID,
      'vehicleNumber': vehicleNumber,
      'arrivalTime': arrivalTime,
      'gatePassRef': gatePassRef,
      'supplier': supplier,
      'baleType': baleType,
      'baleCount': baleCount,
      'price': price,
      'qualityStatus': qualityStatus,
      'readyForYarn': readyForYarn,
      'createdAt': Timestamp.fromDate(createdAt),
      'qualitySummaries': qualitySummaries,
      'overAllBaleScore': overAllBaleScore,
    };
  }
}
