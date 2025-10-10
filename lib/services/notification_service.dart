import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  // Initialize notifications completely
  static Future<void> initialize() async {
    try {
      // Request permission (iOS)
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(alert: true, badge: true, sound: true);

      print('Notification permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted notification permission');

        // Get FCM token
        String? token = await _getFCMToken();

        // Setup message handlers
        _setupMessageHandlers();

        // Subscribe to topics
        await _subscribeToTopics();

        print('Notification service initialized successfully');
      } else {
        print('User declined or has provisional notification permission');
      }
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  static Future<String?> _getFCMToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

      // Save token to Firestore (for sending targeted notifications)
      _saveTokenToFirestore(token);

      return token;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  static void _saveTokenToFirestore(String? token) {
    if (token != null) {
      // TODO: Save token to Firestore user document
      // Example: FirebaseFirestore.instance.collection('users').doc(userId).update({'fcmToken': token});
      print('Save this token to user document: $token');
    }
  }

  static void _setupMessageHandlers() {
    // Handle when app is in FOREGROUND
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📱 Foreground message received!');
      print('Message ID: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification}');

      // Show local notification
      _showLocalNotification(message);
    });

    // Handle when app is in BACKGROUND but opened
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📱 Background message opened!');
      print('Message data: ${message.data}');

      // Navigate to specific screen based on message data
      _handleMessageNavigation(message);
    });

    // Handle initial message when app is launched from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        print('📱 App launched from notification!');
        print('Message data: ${message.data}');
        _handleMessageNavigation(message);
      }
    });
  }

  static void _showLocalNotification(RemoteMessage message) {
    // For now, we'll just print since we don't have flutter_local_notifications
    // In production, you'd show a proper local notification

    final title = message.notification?.title ?? 'XpertBot Academy';
    final body = message.notification?.body ?? 'New notification';

    print('🔔 Show notification: $title - $body');

    // You can add flutter_local_notifications later for better UX
    // _localNotifications.show(...);
  }

  static void _handleMessageNavigation(RemoteMessage message) {
    // Navigate based on message data
    final data = message.data;

    if (data['type'] == 'new_course') {
      print('🎯 Navigate to new course: ${data['course_id']}');
      // Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailScreen()));
    } else if (data['type'] == 'reminder') {
      print('🎯 Navigate to home for reminder');
      // Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else if (data['type'] == 'achievement') {
      print('🎯 Navigate to profile for achievement');
      // Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
    } else {
      print('🎯 Navigate to home (default)');
      // Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  }

  // Subscribe to topics - MAKE THIS PUBLIC
  static Future<void> subscribeToTopics() async {
    try {
      await _firebaseMessaging.subscribeToTopic('all_users');
      await _firebaseMessaging.subscribeToTopic('xpertbot_academy');
      await _firebaseMessaging.subscribeToTopic('web_development');
      await _firebaseMessaging.subscribeToTopic('mobile_development');
      print('✅ Subscribed to notification topics');
    } catch (e) {
      print('❌ Error subscribing to topics: $e');
    }
  }

  // Private method for automatic subscription during initialization
  static Future<void> _subscribeToTopics() async {
    await subscribeToTopics(); // Call the public method
  }

  // Unsubscribe from topics (optional)
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      print('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      print('❌ Error unsubscribing from topic: $e');
    }
  }

  // Get current FCM token
  static Future<String?> getCurrentToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      print('❌ Error getting current token: $e');
      return null;
    }
  }
}
