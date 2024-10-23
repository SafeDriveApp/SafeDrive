import 'package:flutter/material.dart';
import 'package:safe_drive/Page/forgot_password_page.dart'; // Pastikan sudah import halaman ForgotPasswordPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Padding(
          padding: EdgeInsets.fromLTRB(screenWidth * 2 / 100, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, screenWidth * 20 / 100, 0, 0),
                  child: const SizedBox(
                    width: 100,
                    height: 100,
                    child: Image(
                      image: AssetImage("lib/source/image/Logo.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 20 / 100,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, screenWidth * 2 / 100, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Name"),
                    const SizedBox(height: 2),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'odin',
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Email Address"),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Odin@gmail.com',
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Password"),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Password',
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Tambahkan tombol Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Navigasi ke halaman Forgot Password
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
