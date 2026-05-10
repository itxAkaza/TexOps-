class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? profilePic;
  final String role;
  final String employeeId;
  final DateTime dateJoined;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.profilePic,
    required this.role,
    required this.employeeId,
    required this.dateJoined,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
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
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'],
      role: map['role'] ?? '',
      employeeId: map['employeeId'] ?? '',
      dateJoined: DateTime.parse(map['dateJoined']),
    );
  }
}
