import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display Picture')),
      body: Center(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Image.file(File(imagePath)),
        ),
      ),
    );
  }
}
