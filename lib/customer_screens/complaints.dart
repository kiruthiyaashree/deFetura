import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ComplaintPage extends StatefulWidget {
  final String customerName;

  const ComplaintPage({required this.customerName, Key? key}) : super(key: key);

  @override
  _ComplaintPageState createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  TextEditingController _complaintController = TextEditingController();

  Future<void> _submitComplaint() async {
    try {
      // Reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the document in the "complaints" collection
      DocumentReference complaintRef = firestore
          .collection('Users')
          .doc(widget.customerName)
          .collection('complaints')
          .doc(); // Generate a unique document ID

      // Create a map with the complaint data
      Map<String, dynamic> data = {
        'comment': _complaintController.text,
        'timestamp': FieldValue.serverTimestamp(), // Use server timestamp for accurate time
      };

      // Add the complaint data to Firestore
      await complaintRef.set(data);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complaint submitted successfully')),
      );

      // Clear the text field after successful submission
      _complaintController.clear();
    } catch (error) {
      // Show an error message if submission fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit complaint: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _complaintController,
              maxLines: null, // Allow multiple lines for comments
              decoration: InputDecoration(
                hintText: 'Enter your complaint here...',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitComplaint,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
