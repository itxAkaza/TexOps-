class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role;
  final String employeeId; // e.g., ENG-1022
  final DateTime dateJoined;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.employeeId,
    required this.dateJoined,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'name': name,
    'role': role,
    'employeeId': employeeId,
    'dateJoined': dateJoined.toIso8601String(),
  };
}
