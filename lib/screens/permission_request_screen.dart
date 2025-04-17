import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'auth_screen.dart'; // استيراد شاشة طلب الصلاحيات

class PermissionRequestScreen extends StatefulWidget {
  const PermissionRequestScreen({super.key});

  @override
  PermissionRequestScreenState createState() => PermissionRequestScreenState();
}

class PermissionRequestScreenState extends State<PermissionRequestScreen> {
  final List<Permission> permissions = [
    Permission.location,
    Permission.contacts,
    Permission.phone,
  ];

  int currentIndex = 0;

  void requestNextPermission() async {
    if (currentIndex < permissions.length) {
      final permission = permissions[currentIndex];
      await permission.request();
      setState(() {
        currentIndex++;
      });
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => AuthScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), requestNextPermission);
  }

  @override
  Widget build(BuildContext context) {
    String getPermissionName(int index) {
      switch (permissions[index]) {
        case Permission.location:
          return "الوصول للموقع";
        case Permission.contacts:
          return "الوصول لجهات الاتصال";
        case Permission.phone:
          return "إجراء مكالمات";
        default:
          return "صلاحية";
      }
    }

    return Scaffold(
      body: Center(
        child: currentIndex < permissions.length
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_open, size: 60, color: Colors.orange),
                  SizedBox(height: 20),
                  Text("طلب ${getPermissionName(currentIndex)}",
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: requestNextPermission,
                    child: Text("السماح"),
                  )
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
