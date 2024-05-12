import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  String _adminName = '';
  String _adminEmail = '';
  String _adminPhone = '';
  String _adminOfficeLocation = '';
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  // Method to update admin profile data
  Future<void> _updateAdminProfile() async {
    await FirebaseFirestore.instance.collection('adminProfile').doc('admin').update({
      'name': _nameController.text,
      'email': _emailController.text,
      'phoneNumber': _phoneController.text,
      'location': _locationController.text,
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing values or empty strings
    _nameController = TextEditingController(text: _adminName);
    _emailController = TextEditingController(text: _adminEmail);
    _phoneController = TextEditingController(text: _adminPhone);
    _locationController = TextEditingController(text: _adminOfficeLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Profile'),
      ),
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('adminProfile').doc('admin').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            var data = snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Name: ${data['name']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Email: ${data['email']}'),
                  SizedBox(height: 8),
                  Text('Phone Number: ${data['phoneNumber']}'),
                  SizedBox(height: 8),
                  Text('Office Location: ${data['location']}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showUpdateDialog(data),
                    child: Text('Change Details'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }


  // Method to show dialog for updating admin details
  void _showUpdateDialog(Map<String, dynamic> data) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Admin Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await _updateAdminProfile();
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

}

void main() {
  runApp(MaterialApp(
    home: AdminProfile(),
  ));
}

