import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../screens/drawerScreens/notification_screen.dart';



class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  static bool _isSetup = false;



  Future<void> initializeAll() async
  {
    if (_isSetup) return;

    await initNotification();
    requestNotificationPermissions();
    getAndSaveDeviceToken();
    isTokenRefresh();
    setupForegroundListener();
    await setupInteractMessage();

    _isSetup = true;
  }

  // =================================================================
  // 1. INIT LOCAL NOTIFICATIONS (Foreground Popups)
  // =================================================================
  Future<void> initNotification() async
  {


    const initSettingAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    const initSettingIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestSoundPermission: true,
        requestBadgePermission: true
    );

    const initSetting = InitializationSettings(
        android: initSettingAndroid,
        iOS: initSettingIOS
    );

    await notificationPlugin.initialize(
      settings: initSetting,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          Map<String, dynamic> data = jsonDecode(response.payload!);
          handleMessage(data); // Route via GetX
        }
      },
    );

  }


  NotificationDetails notificationDetails()
  {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
        "high_importance_channel",
        "TexOps Alerts",
        importance: Importance.max
    );

    return NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id.toString(),
          channel.name.toString(),
          channelDescription: "TexOps Notification Channel",
          importance: Importance.high,
          priority: Priority.max,
          playSound: true,
        ),

        iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true
        )

    );

  }

  // =================================================================
  // 2. REQUEST PERMISSIONS
  // =================================================================
  void requestNotificationPermissions() async
  {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized)
    {
      debugPrint("Notification Permission Granted");
    }
    else
    {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
      debugPrint("Notification Permission Denied");
    }

  }

  // =================================================================
  // 3. FIRESTORE TOKEN MANAGEMENT
  // =================================================================
  Future<void> saveTokenToDatabase(String token) async
  {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null)
    {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'deviceToken': token}, SetOptions(merge: true));
      debugPrint("FCM Token securely saved to Firestore for UID: $uid");

    }

  }

  Future<void> getAndSaveDeviceToken() async
  {
    String? token = await messaging.getToken();
    if (token != null)
    {
      await saveTokenToDatabase(token);
    }

  }

  void isTokenRefresh()
  {
    messaging.onTokenRefresh.listen((newToken) {
      saveTokenToDatabase(newToken);
    });

  }

  // =================================================================
  // 4. FOREGROUND LISTENER
  // =================================================================
  void setupForegroundListener()
  {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isAndroid || Platform.isIOS)
      {
        if (message.notification != null) {
          notificationPlugin.show(
             id:  DateTime.now().millisecond, // Unique ID
             title:  message.notification!.title,
             body:  message.notification!.body,
              notificationDetails:   notificationDetails(),
              payload: jsonEncode(message.data)
          );
        }

      }

    });
  }

  // =================================================================
  // 5. BACKGROUND / TERMINATED ROUTING (PURE GETX)
  // =================================================================
  Future<void> setupInteractMessage() async
  {
    // When app is completely terminated and opened via tap
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null)
    {
      handleMessage(initialMessage.data);
    }

    // When app is in background and opened via tap
    FirebaseMessaging.onMessageOpenedApp.listen((onData)
    {
      handleMessage(onData.data);
    });

  }

  // The GetX Steering Wheel
  void handleMessage(Map<String, dynamic> data)
  {
    Get.to(() => const NotificationsScreen());
  }


}