import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_drive/Page/profile_page.dart';
import 'package:safe_drive/Page/camera_page.dart';
import 'package:camera/camera.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Future<List<CameraDescription>> _initializeCameraFuture;
  Map<String, dynamic>? userProfile;
  Map<String, dynamic>? DrivingStatistics;
  bool isLoadingProfile = true;
  bool isLoadingStatistics = true;

  @override
  void initState() {
    super.initState();
    _initializeCameraFuture = _initializeCamera();
    _fetchUserProfile(); // Memuat profil pengguna
    _fetchDrivingStatistics(); // Memuat statistik berkendara terakhir
  }

  Future<List<CameraDescription>> _initializeCamera() async {
    try {
      return await availableCameras();
    } catch (e) {
      print("Error initializing cameras: $e");
      return [];
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      String email = FirebaseAuth.instance.currentUser!.email!;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          userProfile = snapshot.docs.first.data() as Map<String, dynamic>;
          isLoadingProfile = false;
        });
      } else {
        setState(() {
          isLoadingProfile = false;
        });
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      setState(() {
        isLoadingProfile = false;
      });
    }
  }

  Future<void> _fetchDrivingStatistics() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('driving_statistics')
          .doc('last_driving')
          .get();

      if (snapshot.exists) {
        setState(() {
          DrivingStatistics = snapshot.data() as Map<String, dynamic>;
          isLoadingStatistics = false;
        });
      } else {
        setState(() {
          isLoadingStatistics = false;
        });
      }
    } catch (e) {
      print("Error fetching last driving statistics: $e");
      setState(() {
        isLoadingStatistics = false;
      });
    }
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
              return isLoadingProfile || isLoadingStatistics
                  ? Center(child: CircularProgressIndicator())
                  : _widgetOptions(cameras).elementAt(_selectedIndex);
            } else {
              print("Failed to load cameras");
              return Center(child: Text('Failed to load cameras'));
            }
          } else {
            print("Loading cameras...");
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
        HomeContent(
            userProfile: userProfile, DrivingStatistics: DrivingStatistics),
        CameraPage(cameras: cameras),
        ProfilePage(), // Placeholder for ProfilePage
      ];
}

class HomeContent extends StatefulWidget {
  final Map<String, dynamic>? userProfile;
  final Map<String, dynamic>? DrivingStatistics;

  const HomeContent({Key? key, this.userProfile, this.DrivingStatistics})
      : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  GoogleMapController? _mapController;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });

    // Move the map camera to the current location
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Text(
            'Welcome, ${widget.userProfile?['name'] ?? 'Guest'}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Driving Statistics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Driving Time: ${widget.DrivingStatistics?['totalDrivingTime'] ?? 'N/A'} minutes',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Drowsiness Warnings: ${widget.DrivingStatistics?['drowsinessWarnings'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Current Location',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: 200,
            color: Colors.grey[200],
            child: _currentPosition == null
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: (controller) {
                      _mapController = controller;
                      if (_currentPosition != null) {
                        _mapController!.animateCamera(
                          CameraUpdate.newLatLng(
                            LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            ),
                          ),
                        );
                      }
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      zoom: 14.0,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
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
