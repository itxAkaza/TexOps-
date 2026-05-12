class VendorModel {
  final String uid;
  final String name;
  final String email;
  final String? profilePic;

  /// ✅ single supply type (IMPORTANT CHANGE)
  final String supplyType;

  final DateTime dateAdded;

  VendorModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePic,
    required this.supplyType,
    required this.dateAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'supplyType': supplyType,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  factory VendorModel.fromMap(Map<String, dynamic> map) {
    return VendorModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profilePic: map['profilePic'],
      supplyType: map['supplyType'] ?? '',
      dateAdded: map['dateAdded'] is String
          ? DateTime.parse(map['dateAdded'])
          : (map['dateAdded'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  VendorModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profilePic,
    String? supplyType,
    DateTime? dateAdded,
  }) {
    return VendorModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      supplyType: supplyType ?? this.supplyType,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}
