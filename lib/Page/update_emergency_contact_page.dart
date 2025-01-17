import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateEmergencyContactPage extends StatefulWidget {
  @override
  _UpdateEmergencyContactPageState createState() =>
      _UpdateEmergencyContactPageState();
}

class _UpdateEmergencyContactPageState
    extends State<UpdateEmergencyContactPage> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEmergencyContacts();
  }

  Future<void> _fetchEmergencyContacts() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        List<dynamic> contacts = data?['emergencyContacts'] ?? [];
        setState(() {
          _contacts = contacts.map((contact) {
            return {
              'name': contact['name'] ?? '',
              'number': contact['number'] ?? '',
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        // Inisialisasi field emergencyContacts jika belum ada
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .set({'emergencyContacts': []}, SetOptions(merge: true));
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching emergency contacts: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateEmergencyContacts() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'emergencyContacts': _contacts,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Emergency contacts updated successfully')),
        );
        Navigator.pop(context, true); // Pass true to indicate success
      } catch (e) {
        print("Error updating emergency contacts: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update emergency contacts')),
        );
      }
    }
  }

  void _addContact() {
    setState(() {
      _contacts.add({'name': '', 'number': ''});
    });
  }

  void _removeContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Emergency Contacts'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _contacts.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: TextFormField(
                                initialValue: _contacts[index]['name'],
                                decoration:
                                    InputDecoration(labelText: 'Contact Name'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a contact name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _contacts[index]['name'] = value!;
                                },
                              ),
                              subtitle: TextFormField(
                                initialValue: _contacts[index]['number'],
                                decoration: InputDecoration(
                                    labelText: 'Contact Number'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a contact number';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _contacts[index]['number'] = value!;
                                },
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _removeContact(index),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addContact,
                      child: Text('Add Contact'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateEmergencyContacts,
                      child: Text('Update Contacts'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
