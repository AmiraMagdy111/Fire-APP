import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart'; // استيراد شاشة الـ Onboarding
import 'permission_request_screen.dart'; // استيراد شاشة طلب الصلاحيات
import '../core/firebase_messaging_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      _checkFirstSeen();
      FirebaseMessagingService.initialize();
      FirebaseMessagingService.checkInitialMessage();
    }
  }

  void _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? seen = prefs.getBool('seenOnboarding') ?? false;

    await Future.delayed(const Duration(seconds: 2)); // تأخير لمدة 2 ثانية

    // Ensure the widget is still mounted before navigating
    if (mounted) {
      if (!seen) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => OnboardingScreen()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const PermissionRequestScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // لون الخلفية
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/OIP.webp', // مسار اللوجو
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Fire Alert App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
