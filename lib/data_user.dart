import 'package:cloud_firestore/cloud_firestore.dart';

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
