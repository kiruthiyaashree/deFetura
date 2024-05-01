import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerComplaintsPage extends StatelessWidget {
  final String customerName;

  const CustomerComplaintsPage({required this.customerName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildComplaintsList(context),
    );
  }

  Widget _buildComplaintsList(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Users')
          .doc(customerName)
          .collection('complaints')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final complaints = snapshot.data!.docs;
          if (complaints.isEmpty) {
            return Center(child: Text('No complaints available'));
          }
          return ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaintData = complaints[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(complaintData['complaint'] ?? ''),
              );
            },
          );
        }
      },
    );
  }
}
