//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/permission_request_screen.dart';
import 'screens/auth_screen.dart';
//import 'screens/register_screen.dart';
import 'screens/home_page.dart';
//import 'screens/owner_dashboard_screen.dart';
import 'screens/alert_fire_screen.dart';
import 'core/firebase_messaging_service.dart';
import 'utils/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessagingService.initialize(); // تهيئة Firebase Messaging
  FirebaseMessagingService.checkInitialMessage(); // التحقق من الرسالة الأولية

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // تمرير `key` إلى الكلاس الأب باستخدام `super.key`

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();

    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    final permissionsGranted = prefs.getBool('permissions_granted') ?? false;
    final isLoggedIn = prefs.getBool('logged_in') ?? false;
    MaterialApp(home: SplashScreen(),); // نقطة البداية

    if (!onboardingCompleted) {
      return OnboardingScreen();
    } else if (!permissionsGranted) {
      return PermissionRequestScreen();
    } else if (!isLoggedIn) {
      return AuthScreen();
    } else {
      return HomePage(); // أو Owner Dashboard إذا كان مالكًا
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire Alert App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      navigatorKey: NavigationService
          .navigatorKey, // ربط navigator key بـ NavigationService
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen(); // شاشة التحميل أثناء انتظار البيانات
          } else {
            return snapshot.data!; // الانتقال إلى الشاشة الأولى
          }
        },
      ),
      routes: {
        '/alert_fire': (context) =>
            FireAlertScreen(), // شاشة التنبيه عند تلقي إشعار
        '/home': (context) => HomePage(),
        '/auth': (context) => AuthScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/permissions': (context) => PermissionRequestScreen(),
      },
    );
  }
}
