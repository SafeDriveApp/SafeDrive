import 'package:flutter/material.dart';
import 'package:safe_drive/Page/change_password_page.dart';
import 'package:safe_drive/Page/signup_page.dart';
import 'package:safe_drive/Page/profile_page.dart';
import 'package:safe_drive/Page/update_profile_page.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Drive',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangePasswordPage(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 1), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
            'assets/img/logo.png'), // Gambar logo untuk splash screen
      ),
    );
  }
}
