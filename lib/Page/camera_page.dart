import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:math' as math;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraPage({super.key, required this.cameras});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isRecording = false;
  Timer? _timer;
  DateTime? _startTime;
  Timer? _reminderTimer;

  // Variabel untuk menyimpan data berkendara
  Duration _totalDrivingTime = Duration.zero;
  int _drowsinessWarnings = 0;

  @override
  void initState() {
    super.initState();
    final frontCamera = widget.cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    _controller = CameraController(
      frontCamera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _reminderTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _uploadFrame(XFile frameFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.18:5000/upload'),
    );
    request.files.add(await http.MultipartFile.fromPath(
      'frame',
      frameFile.path,
    ));

    final response = await request.send();

    if (response.statusCode == 200) {
      // Membaca respons JSON yang berisi hasil prediksi
      final responseData = await response.stream.bytesToString();
      final Map<String, dynamic> result =
          jsonDecode(responseData); // Decode JSON

      String prediction = result['prediction']; // Mendapatkan hasil prediksi

      // Jika terdeteksi mengantuk, putar suara alarm
      if (prediction == '0') {
        final player = AudioPlayer();
        await player.play(AssetSource('alarm.mp3')); // Use AssetSource
        await Future.delayed(
            Duration(seconds: 2, milliseconds: 500)); // Delay 2.5 detik

        // Perbarui jumlah peringatan mengantuk
        setState(() {
          _drowsinessWarnings++;
        });
      }
    } else {
      print('Upload failed with status: ${response.statusCode}');
    }
  }

  void _startRecording() async {
    setState(() {
      _isRecording = true;
      _startTime = DateTime.now();
    });

    _reminderTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      final elapsed = DateTime.now().difference(_startTime!);
      final elapsedHours = elapsed.inHours;

      // Tampilkan reminder pada 2 jam pertama, lalu 3 jam, 4 jam, 5 jam, dst.
      if (elapsedHours >= 2 && (elapsedHours == 2 || elapsedHours % 1 == 0)) {
        _showReminderDialog(elapsedHours);
      }
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_isRecording) {
        // Perbarui total waktu berkendara
        setState(() {
          _totalDrivingTime = DateTime.now().difference(_startTime!);
        });
      }
    });

    while (_isRecording) {
      try {
        final XFile frameFile = await _controller.takePicture();
        await _uploadFrame(frameFile);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
  
  // Debugging
  // void _startRecording() async {
  //   setState(() {
  //     _isRecording = true;
  //     _startTime = DateTime.now();
  //   });

  //   _reminderTimer = Timer.periodic(Duration(seconds: 5), (timer) {
  //     final elapsed = DateTime.now().difference(_startTime!);
  //     if (elapsed.inSeconds >= 10 && (elapsed.inSeconds - 10) % 5 == 0) {
  //       _showReminderDialog(elapsed.inSeconds ~/ 5);
  //     }
  //   });

  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
  //     if (_isRecording) {
  //       // Perbarui total waktu berkendara
  //       setState(() {
  //         _totalDrivingTime = DateTime.now().difference(_startTime!);
  //       });
  //     }
  //   });

  //   while (_isRecording) {
  //     try {
  //       final XFile frameFile = await _controller.takePicture();
  //       await _uploadFrame(frameFile);
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: $e')),
  //       );
  //     }
  //   }
  // }

  Future<void> _saveDrivingStatistics() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    print('Total Driving Time: ${_totalDrivingTime.inMinutes} minutes');
    print('Drowsiness Warnings: $_drowsinessWarnings');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('driving_statistics')
        .add({
      'totalDrivingTime': _totalDrivingTime.inMinutes,
      'drowsinessWarnings': _drowsinessWarnings,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    _reminderTimer?.cancel();
    _timer?.cancel();

    // Simpan data berkendara terakhir
    _saveDrivingStatistics();
  }

  void _showReminderDialog(int hours) async {
    final player = AudioPlayer();
    await player.play(AssetSource('notification.wav'));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Text('Reminder'),
          content: Text(
              'You have been driving for $hours hours. Please take a break.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: CameraPreview(_controller),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isRecording) {
                          _stopRecording();
                        } else {
                          _startRecording();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFD803), // Button color
                        padding: EdgeInsets.symmetric(vertical: 15),
                        minimumSize: Size(double.infinity, 50),
                        textStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600, // Semi-bold
                          fontSize: 16,
                          color: Colors.black, // Text color
                        ),
                      ),
                      child:
                          Text(_isRecording ? 'Stop Driving' : 'Start Driving'),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
