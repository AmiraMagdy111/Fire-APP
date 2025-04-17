import 'package:flutter/material.dart';
import 'permission_request_screen.dart'; // استيراد شاشة طلب الصلاحيات

class OnboardingScreen extends StatelessWidget {
  final PageController _controller = PageController();
  final List<String> titles = [
    "مراقبة المصنع بسهولة",
    "تحكم في الأجهزة عن بُعد",
    "نظام إنذار ذكي"
  ];
  final List<String> descriptions = [
    "تابع حالة المصنع في الوقت الحقيقي.",
    "شغّل وأوقف الأجهزة من موبايلك.",
    "نتعامل مع الطوارئ تلقائيًا."
  ];

  OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: titles.length,
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.factory, size: 100, color: Colors.orange),
                  SizedBox(height: 30),
                  Text(titles[index], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text(descriptions[index], style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 40,
            right: 40,
            child: ElevatedButton(
              child: Text("ابدأ الاستخدام"),
              onPressed: () {                 
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PermissionRequestScreen()));
              },
            ),
          )
        ],
      ),
    );
  }
}
