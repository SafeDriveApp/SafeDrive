import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_drive/Page/email_verification_page.dart';
import 'package:safe_drive/Page/profile_page.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  String? _selectedItem; // Variabel untuk item yang dipilih
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false; // Untuk menampilkan indikator loading
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Memuat data pengguna saat halaman dibuka
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Mendapatkan email pengguna saat ini
      final email = _auth.currentUser?.email;

      if (email != null) {
        // Ambil data pengguna dari Firestore
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final data = snapshot.docs.first.data();

          // Mengisi field dengan data pengguna
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
        }
      }
    } catch (e) {
      print("Error loading user profile: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUserProfile(String email, String newName) async {
    try {
      // Cari dokumen berdasarkan email
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      // Periksa apakah dokumen ditemukan
      if (snapshot.docs.isNotEmpty) {
        // Ambil ID dokumen
        final docId = snapshot.docs.first.id;

        // Update nama di dokumen yang sesuai
        await FirebaseFirestore.instance
            .collection('users')
            .doc(docId)
            .update({'name': newName, 'email': email});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nama berhasil diperbarui')),
        );
        // Kembali ke halaman profil
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => ProfilePage()),
        // );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email tidak ditemukan')),
        );
      }
      // Kembali ke halaman profil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
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
                      'Update Profil',
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 5 / 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Name',
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                              ),
                              readOnly: true, // Email tidak bisa diubah
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: SizedBox(
                                width: 200, // Match the width of the input form
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // Validasi: pastikan kolom tidak kosong
                                    if (_emailController.text
                                            .trim()
                                            .isNotEmpty &&
                                        _nameController.text
                                            .trim()
                                            .isNotEmpty) {
                                      // Panggil fungsi updateNameByEmail
                                      await _updateUserProfile(
                                        _emailController.text.trim(),
                                        _nameController.text.trim(),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Email dan Nama tidak boleh kosong')),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color(0xFFFFD803), // Button color
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    textStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600, // Semi-bold
                                      fontSize: 16,
                                      color: Colors.black, // Text color
                                    ),
                                  ),
                                  child: Text('Update Profile'),
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
