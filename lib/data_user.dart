import 'package:cloud_firestore/cloud_firestore.dart';

class DataUser {
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>?;
    } else {
      print("User data not found");
      return null;
    }
  } catch (e) {
    print("Error getting user profile: $e");
    return null;
  }
}

}