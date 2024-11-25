import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  bool _isLoading = false;

  Future<void> _uploadPicture(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is signed in')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Verify that the file exists
      final file = File(widget.imagePath);
      if (!file.existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File does not exist')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Create a unique file name using timestamp
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Create a reference to the Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(user.uid)
          .child(fileName);

      // Upload the file to Firebase Storage
      await storageRef.putFile(file);

      // Get the download URL
      final downloadURL = await storageRef.getDownloadURL();

      // Save the download URL to Firestore
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userDocRef.update({
        'profile_pictures': FieldValue.arrayUnion([downloadURL])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Picture uploaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload picture: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display Picture')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Image.file(File(widget.imagePath)),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _uploadPicture(context),
                    child: Text('Upload Picture'),
                  ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
