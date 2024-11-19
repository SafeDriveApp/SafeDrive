import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_drive/Page/change_password_page.dart';
import 'package:safe_drive/Page/email_verification_page.dart';
import 'package:safe_drive/Page/home_page.dart';
import 'package:safe_drive/Page/update_profile_page.dart';
import 'package:safe_drive/Page/login_page.dart';
import 'package:safe_drive/data_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    userProfile = await DataUser().getUserProfile(uid);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: SingleChildScrollView(
        // Added SingleChildScrollView
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
                              builder: (context) => const HomePage()),
                        ); // Navigate back to the previous page
                      },
                    ),
                  ),
                  Center(
                    child: Text(
                      'Profil',
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
                  padding: EdgeInsets.fromLTRB(0, screenWidth * 10 / 100, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 50),
                      SizedBox(
                        width: 200, // Increased width
                        height: 110, // Increased height
                        child: const Image(
                          image: AssetImage("assets/img/logo.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(height: 10), // Space between image and text
                      Text(
                        userProfile?['name'] ?? 'Loading...',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18, // Adjust font size as needed
                          color: Color.fromARGB(255, 0, 0, 0), // Color in hex
                        ),
                      ),
                      Text(
                        userProfile?['email'] ?? 'Loading...',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 10, // Adjust font size as needed
                          color:
                              Color.fromARGB(255, 50, 50, 54), // Color in hex
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth *
                                5 /
                                100), // Added padding to left and right
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nama"),
                            SizedBox(height: 2),
                            TextField(
                              controller: TextEditingController(
                                  text: userProfile?['name']),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("Email Address"),
                            TextField(
                              controller: TextEditingController(
                                  text: userProfile?['email']),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("Gender"),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'L',
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("Date Of Birth"),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '12-12-1999',
                              ),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    width:
                                        200, // Match the width of the input form
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateProfilePage()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color(0xFFFFD803), // Button color
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 20),
                                        textStyle: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight:
                                              FontWeight.w600, // Semi-bold
                                          fontSize: 16,
                                          color: Colors.black, // Text color
                                        ),
                                      ),
                                      child: Text('Update Profile'),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  SizedBox(
                                    width:
                                        200, // Match the width of the input form
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangePasswordPage()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color(0xFFFFD803), // Button color
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 20),
                                        textStyle: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight:
                                              FontWeight.w600, // Semi-bold
                                          fontSize: 16,
                                          color: Colors.black, // Text color
                                        ),
                                      ),
                                      child: Text('Change Password'),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  SizedBox(
                                    width:
                                        200, // Match the width of the input form
                                    child: ElevatedButton(
                                      onPressed: _signOut,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color(0xFFFFD803), // Button color
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 20),
                                        textStyle: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight:
                                              FontWeight.w600, // Semi-bold
                                          fontSize: 16,
                                          color: Colors.black, // Text color
                                        ),
                                      ),
                                      child: Text('Log Out'),
                                    ),
                                  ),
                                ],
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
