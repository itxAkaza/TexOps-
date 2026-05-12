import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BailRecordService {

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Returns the current Auth UID
  static String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }


  static Future<void> saveBaleData({
    required String userId,
    required String baleId,
    required Map<String, dynamic> baleData,
  }) async {
    try {

      baleData['createdAt'] = FieldValue.serverTimestamp();

      // Path: BailRecord / {userId} / bail_data / {baleId}
      await _firestore.collection('BailRecord').doc(userId).collection('bail_data').doc(baleId).set(baleData);

    }
    on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          throw Exception(
              'Permission denied. You do not have access to save this record.');
        case 'unavailable':
          throw Exception(
              'Network error. Please check your internet connection.');
        default:
          throw Exception('Database error: ${e.message}');
      }
    }
    catch (e) {
      throw Exception('Failed to save to Firebase: $e');
    }
  }
}