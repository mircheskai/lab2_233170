import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class FirebaseService {
  FirebaseService._privateConstructor();

  static final FirebaseService instance = FirebaseService._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  User? get user => _auth.currentUser;

  Future<void> init() async {
    if (_auth.currentUser == null) {
      try {
        await _auth.signInAnonymously();
      } catch (e) {}
    }

    try {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
    } catch (e) {}

    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _saveFcmToken(token);
      }
    } catch (e) {}

    _messaging.onTokenRefresh.listen((t) async => await _saveFcmToken(t));

    FirebaseMessaging.onMessage.listen((message) async {
      final notification = message.notification;
      if (notification != null && notification.title != null) {
        final android = message.notification!.android;
        final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        const androidDetails = AndroidNotificationDetails(
          'default_channel',
          'Default',
          channelDescription: 'Default channel',
          importance: Importance.max,
          priority: Priority.high,
        );
        const platformDetails = NotificationDetails(android: androidDetails);
        await flutterLocalNotificationsPlugin.show(
          DateTime.now().millisecondsSinceEpoch ~/ 1000,
          notification.title,
          notification.body,
          platformDetails,
        );
      }
    });
  }

  Future<void> _saveFcmToken(String token) async {
    if (user == null) return;
    final doc = _firestore.collection('fcm_tokens').doc(user!.uid);
    await doc.set({'token': token, 'updatedAt': FieldValue.serverTimestamp()});
  }

  FirebaseFirestore get firestore => _firestore;
}