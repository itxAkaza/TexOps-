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
      readyForYarn: map['readyForYarn'] ?? map['qualityStatus'] ?? false,
      // Convert Firebase Timestamp to Dart DateTime
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
