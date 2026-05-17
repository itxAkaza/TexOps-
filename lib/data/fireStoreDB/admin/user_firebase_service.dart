import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:texops/data/models/user_model.dart';
import 'package:texops/data/models/vendor_model.dart';

class UserFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Saves a complete employee profile into Firestore mapping records
  Future<void> saveUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
    await incrementTotalUsers();
  }

  /// Saves a complete vendor profile into Firestore mapping records
  Future<void> saveVendor(VendorModel vendor) async {
    await _firestore.collection("vendors").doc(vendor.uid).set(vendor.toMap());
    await incrementTotalUsers();
  }

  /// Emits real-time lists of users mapped from collection data snapshots
  Stream<List<UserModel>> getUsers() {
    return _firestore.collection('users').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data());
      }).toList();
    });
  }

  /// Emits real-time lists of vendors mapped from collection data snapshots
  Stream<List<VendorModel>> getVendors() {
    return _firestore.collection('vendors').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return VendorModel.fromMap(doc.data());
      }).toList();
    });
  }

  /// Finds the highest existing employee number for the given role numerically.
  /// Uses numeric comparison instead of string sort — works correctly beyond Lab-099.
  Future<String?> getLastEmployeeId({required String role}) async {
    final query = await _firestore
        .collection('users')
        .where('role', isEqualTo: role)
        .get();

    if (query.docs.isEmpty) return null;

    int maxNumber = 0;
    for (final doc in query.docs) {
      final id = (doc.data()['employeeId'] as String?) ?? '';
      if (id.contains('-')) {
        final parsed = int.tryParse(id.split('-').last);
        if (parsed != null && parsed > maxNumber) {
          maxNumber = parsed;
        }
      }
    }

    if (maxNumber == 0) return null;

    // Return in the same format the controller already knows how to parse
    final prefix = role.toLowerCase().contains('lab') ? 'Lab' : 'Qual';
    return '$prefix-${maxNumber.toString().padLeft(3, '0')}';
  }

  /// Validates system record duplicates before building new vendor nodes
  Future<bool> isVendorNameExists(String name) async {
    final query = await _firestore
        .collection('vendors')
        .where('name', isEqualTo: name.trim())
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }

  /// Automatically increments the analytical counter tracker metrics variable
  Future<void> incrementTotalUsers() async {
    await _firestore.collection('records').doc('dashboard_stats').set({
      'total_users': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  /// Security utility validation method to check if an email instance is already deployed
  Future<bool> isUserEmailExists(String email) async {
    final query = await _firestore
        .collection('users')
        .where('generatedEmail', isEqualTo: email.trim().toLowerCase())
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }

  /// Security utility validation method to check if a vendor email instance is already deployed
  Future<bool> isVendorEmailExists(String email) async {
    final query = await _firestore
        .collection('vendors')
        .where('email', isEqualTo: email.trim().toLowerCase())
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }

  /// Wraps employee registration safety query assertions
  Future<String?> checkUserDuplicates({required String email}) async {
    if (await isUserEmailExists(email)) {
      return 'This email is already registered as a user.';
    }
    return null;
  }

  /// Wraps vendor registration safety query assertions
  Future<String?> checkVendorDuplicates({
    required String email,
    required String name,
  }) async {
    if (await isVendorEmailExists(email)) {
      return 'This email is already registered as a vendor.';
    }
    if (await isVendorNameExists(name)) {
      return 'A vendor with this name already exists.';
    }
    return null;
  }
}
