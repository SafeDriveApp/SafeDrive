import 'package:flutter/material.dart';
import 'package:safe_drive/Page/signup_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Drive',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Set halaman splash screen sebagai halaman awal
    );
  }
}

class SplashScreen extends StatefulWidget {
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
        child:
            Image.asset('assets/logo.png'), // Gambar logo untuk splash screen
      ),
    );
  }
}
