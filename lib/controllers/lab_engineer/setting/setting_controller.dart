import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  var isPushEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkCurrentStatus();
  }

  Future<void> _checkCurrentStatus() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      var doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        String? token = doc.data()?['deviceToken'];
        isPushEnabled.value = (token != null && token.isNotEmpty);
      }
    }
  }

  Future<void> togglePushNotifications(bool value) async {
    isPushEnabled.value = value;

    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      if (value) {
        String? newToken = await FirebaseMessaging.instance.getToken();
        if (newToken != null) {
          await FirebaseFirestore.instance.collection('users').doc(uid).set(
              {'deviceToken': newToken},
              SetOptions(merge: true)
          );
        }
      } else {
        await FirebaseMessaging.instance.deleteToken();
        await FirebaseFirestore.instance.collection('users').doc(uid).update(
            {'deviceToken': FieldValue.delete()} // This completely removes the field
        );
      }
    } catch (e) {
      isPushEnabled.value = !value;
      Get.snackbar("Error", "Could not update notification settings.", backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }
}