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
    );
  }
}
