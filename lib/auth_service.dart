import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fungsi untuk login menggunakan email dan password
  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ambil UID pengguna setelah login
      String userId = userCredential.user!.uid;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      // Menyimpan ID User
      await prefs.setString('userID', userId);

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
      }

      // Hash password menggunakan SHA-256
      var bytes = utf8.encode(password); // data being hashed
      var digest = sha256.convert(bytes);

      // Menambahkan data pengguna baru ke Firestore dengan UID sebagai document ID
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference users = firestore.collection('users');
      await users.doc(user!.uid).set({
        'name': name,
        'email': email,
        'password_hash': digest.toString(),
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
        'emergencyContacts': [], // Inisialisasi field emergencyContacts
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

  Future<Map<String, dynamic>?> getUserProfile(String email) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Cari dokumen pengguna berdasarkan email
      QuerySnapshot snapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Mengambil data pengguna dari dokumen pertama
        return snapshot.docs[0].data() as Map<String, dynamic>;
      }
      return null; // Jika tidak ada data ditemukan
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required String email,
    required String password,
  }) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // Perbarui nama di Firebase Authentication
        if (name.isNotEmpty) {
          await user.updateDisplayName(name);
        }

        // Perbarui email di Firebase Authentication
        if (email.isNotEmpty && email != user.email) {
          await user.updateEmail(email);
        }

        // Perbarui password di Firebase Authentication
        if (password.isNotEmpty) {
          await user.updatePassword(password);
        }

        // Hash password menggunakan SHA-256
        var bytes = utf8.encode(password); // data being hashed
        var digest = sha256.convert(bytes);

        // Perbarui data di Firestore
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        QuerySnapshot snapshot = await firestore
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          await snapshot.docs[0].reference.update({
            'name': name,
            'email': email,
            'password_hash': digest.toString(),
            'updated_at': FieldValue.serverTimestamp(),
          });
        }

        print("User profile updated successfully!");
      } on FirebaseAuthException catch (e) {
        print('Error updating profile: ${e.message}');
        throw Exception(e.message);
      }
    } else {
      throw Exception("User is not logged in.");
    }
  }
}
