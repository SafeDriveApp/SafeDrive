import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_drive/Page/change_password_page.dart';
import 'package:safe_drive/Page/home_page.dart';
import 'package:safe_drive/Page/update_profile_page.dart';
import 'package:safe_drive/Page/login_page.dart';
import 'package:safe_drive/Page/update_emergency_contact_page.dart'; // Import halaman baru
import 'package:safe_drive/auth_service.dart';

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
    try {
      String email = FirebaseAuth.instance.currentUser!.email!;
      Map<String, dynamic>? fetchedUserProfile =
          await AuthService().getUserProfile(email);

      setState(() {
        userProfile = fetchedUserProfile;
        isLoading = false;
      });

      // Cetak isi userProfile ke console untuk debugging
      print("Isi userProfile: $userProfile");
      print('Current User UID: ${FirebaseAuth.instance.currentUser?.uid}');
    } catch (e) {
      print("Error fetching user profile: $e");
      setState(() {
        isLoading = false;
      });
    }
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
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(), // Indikator loading
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: SingleChildScrollView(
        // Added SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      ); // Navigate back to the previous page
                    },
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xFF272343),
                    ),
                  ),
                  SizedBox(width: 48), // Placeholder to balance the row
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Tambahkan Gambar Profil
                      CircleAvatar(
                        radius: 60,
                        child: Image.asset(
                          'assets/img/Profil.jpg',
                          height: 200,
                        ),
                      ),
                      SizedBox(height: 10), // Space between image and text

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth *
                                5 /
                                100), // Added padding to left and right
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name"),
                            SizedBox(
                              height: 2,
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                userProfile?['name'] ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              tileColor: Colors.grey.shade200,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Email Address"),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                userProfile?['email'] ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              tileColor: Colors.grey.shade200,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                                child: Column(
                              children: [
                                SizedBox(
                                  width:
                                      250, // Match the width of the input form
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
                                      250, // Match the width of the input form
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
                                      250, // Match the width of the input form
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateEmergencyContactPage()), // Navigate to the new page
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
                                    child: Text('Update Emergency Contact'),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(5)),
                                SizedBox(
                                  width:
                                      250, // Match the width of the input form
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
                            )),
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
