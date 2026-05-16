class UserModel {
  final String uid;
  final String generatedEmail;
  final String? profilePic;
  final String name;
  final String role;
  final String employeeId;
  final DateTime dateJoined;
  final double? totalBalesAmount;

  UserModel({
    required this.uid,
    required this.generatedEmail,
    this.profilePic,
    required this.name,
    required this.role,
    required this.employeeId,
    required this.dateJoined,
    this.totalBalesAmount,
  });

  /// Converts the UserModel instance into a clean Map for writing to Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'generatedEmail': generatedEmail,
      'profilePic': profilePic,
      'name': name,
      'role': role,
      'employeeId': employeeId,
      'dateJoined': dateJoined.toIso8601String(),
      'totalBalesAmount': totalBalesAmount ?? 0.0,
    };
  }

  /// Factory constructor to map your incoming Firestore document snapshots safely
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      generatedEmail: map['generatedEmail'] ?? map['personalEmail'] ?? map['email'] ?? '',
      profilePic: map['profilePic'],
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      employeeId: map['employeeId'] ?? '',
      dateJoined: map['dateJoined'] != null
          ? DateTime.parse(map['dateJoined'])
          : DateTime.now(),
      totalBalesAmount: map['totalBalesAmount'] != null
          ? (map['totalBalesAmount'] as num).toDouble()
          : 0.0,
    );
  }
}
