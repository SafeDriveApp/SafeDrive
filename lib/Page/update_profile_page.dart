import 'package:flutter/material.dart';
import 'package:safe_drive/Page/email_verification_page.dart';
import 'package:safe_drive/Page/profile_page.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  String? _selectedItem; // Variabel untuk item yang dipilih
  final List<String> _dropdownItems = ['Male', 'Female'];

  DateTime? _selectedDate; // Variabel untuk menyimpan tanggal yang dipilih
  final TextEditingController _dateController =
      TextEditingController(); // Controller untuk menampilkan tanggal di TextField

  // Fungsi untuk menampilkan date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Tanggal awal (default)
      firstDate: DateTime(1900), // Batas tanggal terendah
      lastDate: DateTime(2100), // Batas tanggal tertinggi
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text =
            "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 10 / 100),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()),
                        ); // Navigate back to the previous page
                      },
                    ),
                  ),
                  Center(
                    child: Text(
                      'Update Profil',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Color(0xFF272343),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, screenWidth * 10 / 100, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 50),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 5 / 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'What is your name',
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'And your last name?',
                              ),
                            ),
                            SizedBox(height: 20),
                            // Dropdown untuk memilih gender
                            DropdownButtonFormField<String>(
                              value: _selectedItem,
                              decoration: InputDecoration(
                                border:
                                    OutlineInputBorder(), // Memberikan border seperti TextField lainnya
                                hintText: 'Select your gender',
                              ),
                              items: _dropdownItems.map((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedItem = newValue;
                                });
                              },
                            ),
                            SizedBox(height: 20),

                            // TextField untuk memilih tanggal lahir dengan DatePicker
                            Text("Date Of Birth"),
                            TextField(
                              controller: _dateController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Select your date of birth',
                              ),
                              readOnly: true, // Agar tidak bisa diketik manual
                              onTap: () {
                                _selectDate(context); // Menampilkan date picker
                              },
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: SizedBox(
                                width: 200, // Match the width of the input form
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color(0xFFFFD803), // Button color
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    textStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600, // Semi-bold
                                      fontSize: 16,
                                      color: Colors.black, // Text color
                                    ),
                                  ),
                                  child: Text('Update Profile'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
