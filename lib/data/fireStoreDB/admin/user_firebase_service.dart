import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:texops/data/models/user_model.dart';
import 'package:texops/data/models/vendor_model.dart';

class UserFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
    await incrementTotalUsers();
  }

  Future<void> saveVendor(VendorModel vendor) async {
    await _firestore.collection("vendors").doc(vendor.uid).set(vendor.toMap());
    await incrementTotalUsers();
  }

  Stream<List<UserModel>> getUsers() {
    return _firestore.collection('users').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data());
      }).toList();
    });
  }

  Stream<List<VendorModel>> getVendors() {
    return _firestore.collection('vendors').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return VendorModel.fromMap(doc.data());
      }).toList();
    });
  }

  Future<String?> getLastEmployeeId({required String role}) async {
    final query = await _firestore
        .collection('users')
        .where('role', isEqualTo: role)
        .orderBy('employeeId', descending: true)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    }

    return query.docs.first.get('employeeId');
  }

  Future<bool> isVendorNameExists(String name) async {
    final query = await FirebaseFirestore.instance
        .collection('vendors')
        .where('name', isEqualTo: name.trim())
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }

  Future<void> incrementTotalUsers() async {
    await _firestore.collection('records').doc('dashboard_stats').update({
      'total_users': FieldValue.increment(1),
    });
  }
}
