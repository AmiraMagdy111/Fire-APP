import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/navigation_service.dart'; // تأكد من استيراد NavigationService

class FirebaseMessagingService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // تهيئة الإشعارات
  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    // تهيئة الإشعارات
    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // التعامل مع الإشعار عندما يضغط المستخدم عليه
        if (response.payload != null) {
          // الانتقال إلى الشاشة المناسبة بناءً على الـ payload
          NavigationService.navigateTo('/alert_fire');
        }
      },
    );

    // الاستماع للإشعارات عندما يكون التطبيق في الواجهة
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotification(
          message.notification!.title ?? 'ALERT', // إصلاح الخطأ هنا
          message.notification!.body ?? 'Fire!!!',
        );
      }
    });

    // التعامل مع الإشعار عندما يفتح المستخدم التطبيق من إشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        // الانتقال إلى الشاشة المطلوبة بعد فتح التطبيق من إشعار
        NavigationService.navigateTo('/alert_fire');
      }
    });
  }

  // عرض الإشعار المحلي
  static Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'fire_alerts_channel', // ID القناة
      'Fire Alerts', // اسم القناة
      channelDescription: 'تنبيهات الطوارئ والحرائق',
      importance: Importance.max,
      priority: Priority.high,
      color: Colors.red,
      playSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      0, // ID الإشعار
      title,
      body,
      notificationDetails,
    );
  }

  // التحقق إذا كان التطبيق قد فتح من إشعار
  static Future<void> checkInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null && initialMessage.notification != null) {
      // الانتقال إلى الشاشة عند فتح التطبيق من إشعار
      NavigationService.navigateTo('/alert_fire');
    }
  }
}
