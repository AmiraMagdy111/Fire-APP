import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login / Sign Up"),
          bottom: TabBar(tabs: [
            Tab(text: "Login"),
            Tab(text: "Sign Up"),
          ]),
        ),
        body: TabBarView(children: [
          LoginTab(),
          SignUpTab(),
        ]),
      ),
    );
  }
}

class LoginTab extends StatefulWidget {
  const LoginTab({super.key});

  @override
  LoginTabState createState() => LoginTabState();
}

class LoginTabState extends State<LoginTab> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool rememberMe = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadCredentials();
  }

  void loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email') ?? '';
    final savedPassword = prefs.getString('password') ?? '';
    final remember = prefs.getBool('remember_me') ?? false;

    if (remember) {
      setState(() {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
        rememberMe = true;
      });
    }
  }

  void saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('email', emailController.text);
      await prefs.setString('password', passwordController.text);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.setBool('remember_me', false);
    }
  }

  void login() async {
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      saveCredentials();
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed.")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                  ),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (val) => setState(() => rememberMe = val!),
                  ),
                  Text("Remember Me"),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: login,
                child: Text("Login"),
              ),
            ],
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black45,
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class SignUpTab extends StatefulWidget {
  const SignUpTab({super.key});

  @override
  SignUpTabState createState() => SignUpTabState();
}

class SignUpTabState extends State<SignUpTab> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;

  void signUp() async {
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign up failed.")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: signUp, child: Text("Sign Up")),
            ],
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black45,
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
