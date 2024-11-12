import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  Future<void> _uploadPicture(BuildContext context) async {
    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is signed in')),
        );
        return;
      }

      // Verify that the file exists
      final file = File(imagePath);
      if (!file.existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File does not exist')),
        );
        return;
      }

      // Create a reference to the Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${user.uid}.jpg');

      // Upload the file to Firebase Storage
      await storageRef.putFile(file);

      // Get the download URL
      final downloadURL = await storageRef.getDownloadURL();

      // Check if the document exists
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userDoc = await userDocRef.get();

      if (userDoc.exists) {
        // Update the document if it exists
        await userDocRef.update({'profile_picture': downloadURL});
      } else {
        // Create the document if it does not exist
        await userDocRef.set({'profile_picture': downloadURL});
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Picture uploaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload picture: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display Picture')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Image.file(File(imagePath)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _uploadPicture(context),
              child: Text('Upload Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
