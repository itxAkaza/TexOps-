import 'package:cloud_firestore/cloud_firestore.dart';

class TransferFirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> transferOutboundBale({
    required String userId,
    required String baleId,
    required double amountToSubtract,
    required int baleCountToSubtract,
  }) async {
    try {
      WriteBatch batch = _firestore.batch();


      DocumentReference baleDocRef = _firestore
          .collection('BailRecord')
          .doc(userId)
          .collection('bail_data')
          .doc(baleId);

      batch.delete(baleDocRef);

      DocumentReference userDocRef = _firestore.collection('users').doc(userId);
      batch.set(
        userDocRef,
        {
          'totalBalesAmount': FieldValue.increment(-amountToSubtract)
        },
        SetOptions(merge: true),
      );

      DocumentReference statsDocRef = _firestore.collection('records').doc('dashboard_stats');
      batch.set(
        statsDocRef,
        {
          'total_bales_count': FieldValue.increment(-baleCountToSubtract),
        },
        SetOptions(merge: true),
      );

      await batch.commit();

    } catch (e) {
      throw Exception('Failed to transfer bale: $e');
    }
  }
}