import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

// --- ADD THIS METHOD ---
Future<void> saveTokenToDatabase(String token) async {
  String? uid = FirebaseAuth.instance.currentUser?.uid;


  if (uid != null) {
    // We use merge: true so we don't accidentally overwrite their name or role!
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'deviceToken': token}, SetOptions(merge: true));
    print("FCM Token securely saved to Firestore for UID: $uid");
  }
}

// --- UPDATE YOUR EXISTING getDeviceToken METHOD ---
Future<String> getDeviceToken() async {
  String? token = await messaging.getToken();
  if (token != null) {
    await saveTokenToDatabase(token); // Save it as soon as we get it!
  }
  return token!;
}

// --- UPDATE YOUR EXISTING isTokenRefresh METHOD ---
void isTokenRefresh() async {
  messaging.onTokenRefresh.listen((newToken) {
    saveTokenToDatabase(newToken); // Update the DB if the token ever changes
  });
}