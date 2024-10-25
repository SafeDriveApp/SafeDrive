import 'package:flutter/material.dart';
import 'package:safe_drive/Page/change_password_page.dart';
import 'package:safe_drive/Page/email_verification_page.dart';
import 'package:safe_drive/Page/update_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
                              builder: (context) => const ProfilePage()),
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
                        'Odin Allfather',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18, // Adjust font size as needed
                          color: Color.fromARGB(255, 0, 0, 0), // Color in hex
                        ),
                      ),
                      Text(
                        'email@gmail.com',
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
                            SizedBox(
                              height: 2,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'odin',
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Email Address"),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Odin@gmail.com',
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Gender"),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'L',
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Date Of Birth"),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '12-12-1999',
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
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
