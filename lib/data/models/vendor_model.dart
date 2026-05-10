class VendorModel {
  final String uid;
  final String id;
  final String name;
  final List<String> suppliedItems;
  final DateTime dateAdded;

  VendorModel({
    required this.uid,
    required this.id,
    required this.name,
    required this.suppliedItems,
    required this.dateAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'id': id,
      'name': name,
      'items': suppliedItems,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  factory VendorModel.fromMap(Map<String, dynamic> map) {
    return VendorModel(
      uid: map['uid'] ?? '',
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      suppliedItems: List<String>.from(map['items'] ?? []),
      dateAdded: DateTime.parse(
        map['dateAdded'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
