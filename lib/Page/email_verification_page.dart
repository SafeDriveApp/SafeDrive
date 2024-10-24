import 'package:flutter/material.dart';
import 'package:safe_drive/Page/signup_page.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 5 / 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 10 / 100),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupPage()),
                        ); // Navigate back to the previous page
                      },
                    ),
                  ),
                  Center(
                    child: Text(
                      'Email Verification',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Color(0xFF272343),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 5 / 100),
              Text(
                'Enter the OTP sent to your email:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Color(0xFF272343),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter OTP',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle OTP verification
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFD803), // Button color
                      padding: EdgeInsets.symmetric(vertical: 15),
                      textStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600, // Semi-bold
                        fontSize: 16,
                        color: Colors.black, // Text color
                      ),
                    ),
                    child: Text('VERIFY'),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Didn\'t receive the OTP? Resend',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xFF272343),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
