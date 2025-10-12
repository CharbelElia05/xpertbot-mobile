import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/about_page.dart';
import 'services/notification_service.dart';
import 'services/offline_service.dart'; // ← ADD THIS IMPORT

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Initialize offline service ← ADD THIS
  await OfflineService.initialize();

  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Enable Firebase offline persistence
  await FirebaseFirestore.instance.enablePersistence();

  // Initialize notifications
  await NotificationService.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: const XpertBotApp(),
    ),
  );
}

class XpertBotApp extends StatelessWidget {
  const XpertBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/courses': (context) =>
            const CoursesScreen(trackId: 'web', trackTitle: 'Web Development'),
        '/about': (context) => const AboutPage(),
      },
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
