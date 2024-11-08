import 'package:flutter/material.dart';
import 'package:safe_drive/Page/profile_page.dart';
import 'package:safe_drive/Page/camera_page.dart';
import 'package:camera/camera.dart';

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
        HomeContent(),
        CameraPage(cameras: cameras), // Provide the required cameras parameter
        ProfilePage(), // Placeholder for ProfilePage
      ];
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Text(
            'Welcome, [User Name]',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Driving Statistics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          // Placeholder for statistics
          Container(
            height: 200,
            color: Colors.grey[200],
            child: Center(child: Text('Statistics Graph')),
          ),
          SizedBox(height: 20),
          Text(
            'Current Location',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          // Placeholder for map
          Container(
            height: 200,
            color: Colors.grey[200],
            child: Center(child: Text('Map Placeholder')),
          ),
          SizedBox(height: 20),
          Text(
            'Safety Tips',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: Icon(Icons.lightbulb),
              title: Text('Tip 1: Take regular breaks'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.lightbulb),
              title: Text('Tip 2: Stay hydrated'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.lightbulb),
              title: Text('Tip 3: Avoid heavy meals before driving'),
            ),
          ),
        ],
      ),
    );
  }
}
