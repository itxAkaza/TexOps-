import 'package:cloud_firestore/cloud_firestore.dart';

class BailRecordService {

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  static Future<void> saveBaleData({
    required String userId,
    required String baleId,
    required Map<String, dynamic> baleData,
  }) async {
    try {

      baleData['createdAt'] = FieldValue.serverTimestamp();

      // Path: BailRecord / {userId} / bail_data / {baleId}
      await _firestore.collection('BailRecord').doc(userId).collection('bail_data').doc(baleId).set(baleData);

    } catch (e) {
      throw Exception('Failed to save to Firebase: $e');
    }
  }
}