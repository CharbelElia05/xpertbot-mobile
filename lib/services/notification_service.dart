import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final FirebaseMessaging _fm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _fln =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'default_channel', // id
    'General Notifications', // title
    description: 'App notifications',
    importance: Importance.high,
  );

  static Future<void> initialize() async {
    try {
      // Ask permission (Android 13+/iOS)
      final settings = await _fm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      print('Notification permission: ${settings.authorizationStatus}');

      // Local notifications init
      const initAndroid = AndroidInitializationSettings('ic_notification');
      const initSettings = InitializationSettings(android: initAndroid);
      await _fln.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (resp) {
          // Handle taps on foreground notifications if needed
          // print('Tapped payload: ${resp.payload}');
        },
      );

      // Create the Android channel (safe to call multiple times)
      await _fln
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);

      // Token (for console test)
      final token = await _fm.getToken();
      print('🔹 FCM Token: $token');

      // Background/terminated handler must be set at app start (you already do in main)
      // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Foreground messages -> show local notif
      FirebaseMessaging.onMessage.listen(_onForegroundMessage);

      // Opened from background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageNavigation);

      // Opened from terminated
      final initial = await _fm.getInitialMessage();
      if (initial != null) _handleMessageNavigation(initial);

      // Topics (optional)
      await subscribeToTopics();

      print('✅ NotificationService initialized');
    } catch (e) {
      print('❌ Notification init error: $e');
    }
  }

  static void _onForegroundMessage(RemoteMessage message) {
    final n = message.notification;
    final title = n?.title ?? 'XpertBot Academy';
    final body = n?.body ?? 'New notification';
    print('📱 Foreground message: ${message.data}');

    // Show a heads-up notification on Android
    if (Platform.isAndroid) {
      _fln.show(
        n.hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: 'ic_notification',
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  static void _handleMessageNavigation(RemoteMessage message) {
    final data = message.data;
    print('🔁 Opened from notification. Data: $data');
    // TODO: use a navigator/service to route based on `data`
    // e.g., if (data['type'] == 'new_course') { ... }
  }

  // ---- Topics API you already had ----
  static Future<void> subscribeToTopics() async {
    try {
      await _fm.subscribeToTopic('all_users');
      await _fm.subscribeToTopic('xpertbot_academy');
      await _fm.subscribeToTopic('web_development');
      await _fm.subscribeToTopic('mobile_development');
      print('✅ Subscribed to topics');
    } catch (e) {
      print('❌ Topic subscribe error: $e');
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _fm.unsubscribeFromTopic(topic);
      print('✅ Unsubscribed: $topic');
    } catch (e) {
      print('❌ Unsubscribe error: $e');
    }
  }

  static Future<String?> getCurrentToken() => _fm.getToken();
}
