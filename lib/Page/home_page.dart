import 'package:flutter/material.dart';
import 'package:safe_drive/Page/profile_page.dart';
import 'package:safe_drive/Page/camera_page.dart';
import 'package:camera/camera.dart'; // Add this import statement

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Future<List<CameraDescription>> _initializeCameraFuture;

  @override
  void initState() {
    super.initState();
    _initializeCameraFuture = _initializeCamera();
  }

  Future<List<CameraDescription>> _initializeCamera() async {
    return await availableCameras();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: FutureBuilder<List<CameraDescription>>(
        future: _initializeCameraFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final cameras = snapshot.data!;
              return _widgetOptions(cameras).elementAt(_selectedIndex);
            } else {
              return Center(child: Text('Failed to load cameras'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  List<Widget> _widgetOptions(List<CameraDescription> cameras) => <Widget>[
        Text('Home Page',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
        CameraPage(cameras: cameras), // Provide the required cameras parameter
        ProfilePage(), // Placeholder for ProfilePage
      ];
}
