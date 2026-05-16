import 'package:cloud_firestore/cloud_firestore.dart';

class BaleDetailFirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  static Future<void> updateYarnStatus(String userId, String baleId, bool status) async
  {
    try
    {
      await _firestore
          .collection('BailRecord')
          .doc(userId)
          .collection('bail_data')
          .doc(baleId)
          .update({'readyForYarn': status});
    } catch (e)
    {
      throw Exception('Failed to update yarn status: $e');
    }

  }


  static Future<void> deleteBale(
      {
    required String userId,
    required String baleId,
    required double amountToSubtract,
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


      await batch.commit();

    } catch (e)
    {
      throw Exception('Failed to delete bale and update user: $e');
    }

  }


}