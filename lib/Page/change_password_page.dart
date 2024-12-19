import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_drive/Page/profile_page.dart';
import 'package:safe_drive/Page/update_profile_page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _changePassword() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is signed in')),
        );
        return;
      }

      // Reauthenticate user with old password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _oldPasswordController.text.trim(),
      );
      await user.reauthenticateWithCredential(credential);

      // Check if new password and confirm password match
      if (_newPasswordController.text.trim() != _confirmPasswordController.text.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('New password and confirm password do not match')),
        );
        return;
      }

      // Update password
      await user.updatePassword(_newPasswordController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password changed successfully')),
      );

      // Navigate to profile page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change password: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
                              builder: (context) => const ProfilePage()),
                        ); // Navigate back to the previous page
                      },
                    ),
                  ),
                  Center(
                    child: Text(
                      'Change Password',
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
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, screenWidth * 20 / 100, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 5 / 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 2),
                            Text("Old Password"),
                            TextField(
                              controller: _oldPasswordController,
                              obscureText: !_isOldPasswordVisible,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '**********',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isOldPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isOldPasswordVisible =
                                          !_isOldPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("New Password"),
                            TextField(
                              controller: _newPasswordController,
                              obscureText: !_isNewPasswordVisible,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '**********',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isNewPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isNewPasswordVisible =
                                          !_isNewPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("Confirm New Password"),
                            TextField(
                              controller: _confirmPasswordController,
                              obscureText: !_isConfirmPasswordVisible,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '**********',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: _changePassword,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFFFD803),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    textStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Text('Submit'),
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
            ],
          ),
        ),
      ),
    );
  }
}