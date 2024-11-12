import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:safe_drive/Page/email_verification_page.dart';
import 'package:safe_drive/Page/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fungsi untuk login menggunakan email dan password
  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
      if (e.code == 'user-not-found') {
        throw Exception('User not found');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password');
      } else {
        throw Exception('Login failed: ${e.message}');
      }
    } catch (e) {
      print(
          'General error: $e'); // Menangani error selain FirebaseAuthException
      throw Exception('Login failed: $e');
    }
  }

  // Fungsi untuk registrasi pengguna baru
  Future<void> register(String email, String password, String name) async {
    try {
      // Mendaftar pengguna baru
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Kirim email verifikasi
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print("Navigasi menuju halaman verifikasi email dijalankan");
        // final emailpage = await _().emailpage();
      }

      // Hash password jika perlu (gunakan bcrypt atau algoritma lain)
      String passwordHash = password; // Gantilah dengan password hash

      // Menambahkan data pengguna baru ke Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference users = firestore.collection('users');
      await users.add({
        'name': name,
        'email': email,
        'password_hash': passwordHash,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
      print('berhasil');
    } on FirebaseAuthException catch (e) {
      print('Error during registration: ${e.message}');
      throw Exception('Registration failed: ${e.message}');
    }
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }

  // Fungsi untuk cek status login
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
