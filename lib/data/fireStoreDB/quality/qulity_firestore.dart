import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QualityFirebaseService {
  // Get the logged-in Quality Engineer's profile
  static Future<Map<String, dynamic>?> getUserProfile() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    var doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data();
  }

  // Stream bales from the SPECIFIC Lab Engineer's subcollection
  static Stream<QuerySnapshot> getBalesStream() {
    return FirebaseFirestore.instance
        .collection('BailRecord')
        .doc('4U8fQ5BdPYhCorczhBwNWArzPHh1') // The hardcoded Lab Engineer ID
        .collection('bail_data')
        .snapshots();
  }
}