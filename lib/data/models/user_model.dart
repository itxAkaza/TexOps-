class UserModel {
  final String uid;
  final String personalEmail; // given by admin — for sending creds & reset
  final String generatedEmail; // auto-generated — used to login
  final String name;
  final String? profilePic;
  final String role;
  final String employeeId;
  final DateTime dateJoined;

  UserModel({
    required this.uid,
    required this.personalEmail,
    required this.generatedEmail,
    required this.name,
    this.profilePic,
    required this.role,
    required this.employeeId,
    required this.dateJoined,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'personalEmail': personalEmail,
      'generatedEmail': generatedEmail,
      'name': name,
      'profilePic': profilePic,
      'role': role,
      'employeeId': employeeId,
      'dateJoined': dateJoined.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      personalEmail: map['personalEmail'] ?? '',
      generatedEmail: map['generatedEmail'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'],
      role: map['role'] ?? '',
      employeeId: map['employeeId'] ?? '',
      dateJoined: DateTime.parse(
        map['dateJoined'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
