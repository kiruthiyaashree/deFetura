import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerFeedbacksPage extends StatelessWidget {
  final String customerName;

  const CustomerFeedbacksPage({required this.customerName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildFeedbacksList(context),
    );
  }

  Widget _buildFeedbacksList(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Users')
          .doc(customerName)
          .collection('feedback')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final feedbacks = snapshot.data!.docs;
          if (feedbacks.isEmpty) {
            return Center(child: Text('No feedbacks available'));
          }
          return ListView.builder(
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final feedbackData = feedbacks[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${feedbackData['name'] ?? ''}'),
                    Text('Quality of work: ${feedbackData['quality'] ?? ''} out of 10'),
                    Text('Work completed on time: ${feedbackData['onTime'] ?? ''} out of 10'),
                    Text('Within budget: ${feedbackData['budget'] ?? ''} out of 10'),
                    Text('Star Rating: ${feedbackData['starRating'] ?? ''} out of 5'),
                    SizedBox(height: 8),
                    Text('Comment: ${feedbackData['comment'] ?? ''}'),
                  ],
                ),
              );
            },
          );

        }
      },
    );
  }
}
