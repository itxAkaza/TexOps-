import 'package:cloud_firestore/cloud_firestore.dart';

class EditBaleFirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> updateBaleData({
    required String userId,
    required String baleId,
    required Map<String, dynamic> updatedFields,
    required double priceDifference,
  }) async {
    try {
      WriteBatch batch = _firestore.batch();

      DocumentReference baleDocRef = _firestore
          .collection('BailRecord')
          .doc(userId)
          .collection('bail_data')
          .doc(baleId);

      batch.update(baleDocRef, updatedFields);


      if (priceDifference != 0.0) {
        DocumentReference userDocRef = _firestore.collection('users').doc(userId);
        batch.set(
          userDocRef,
          {
            'totalBalesAmount': FieldValue.increment(priceDifference)
          },
          SetOptions(merge: true),
        );
      }


      await batch.commit();

    } catch (e)
    {
      throw Exception('Failed to update bale data: $e');
    }
  }
}