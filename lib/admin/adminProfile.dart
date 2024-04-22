import 'package:flutter/material.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  // Dummy admin details
  String _adminName = 'John Doe';
  String _adminEmail = 'john.doe@example.com';
  String _adminPhone = '+1234567890';
  String _adminOfficeLocation = 'Office XYZ';

  // Controllers for text fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _officeLocationController = TextEditingController();

  // Method to show dialog for updating admin details
  void _showUpdateDialog() {
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
                  controller: _officeLocationController,
                  decoration: InputDecoration(labelText: 'Office Location'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  // Update admin details with new values
                  _adminName = _nameController.text;
                  _adminEmail = _emailController.text;
                  _adminPhone = _phoneController.text;
                  _adminOfficeLocation = _officeLocationController.text;
                });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Name: $_adminName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Email: $_adminEmail'),
            SizedBox(height: 8),
            Text('Phone Number: $_adminPhone'),
            SizedBox(height: 8),
            Text('Office Location: $_adminOfficeLocation'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showUpdateDialog,
              child: Text('Change Details'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AdminProfile(),
  ));
}
