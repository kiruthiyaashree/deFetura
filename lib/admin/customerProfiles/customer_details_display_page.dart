import 'package:flutter/material.dart';
import 'package:construction/models/customer_details_model.dart'; // Import CustomerDetailsModel
import 'package:construction/repositories/customer_details_repository.dart';

class CustomerDetailsDisplayPage extends StatelessWidget {
  final String customerName;

  const CustomerDetailsDisplayPage({required this.customerName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<CustomerDetailsModel?>(
          future: CustomerDetailsRepository.instance.getCustomerDetails(customerName), // Call method to retrieve customer details
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while retrieving details
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Show an error message if there's an error
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // If details are available, display them
              if (snapshot.data != null) {
                return _displayCustomerDetails(snapshot.data!);
              } else {
                return Center(child: Text('No customer details available.'));
              }
            }
          },
        ),
      ),
    );
  }

  Widget _displayCustomerDetails(CustomerDetailsModel customerDetails) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Customer Name:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            customerDetails.name,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Square Footage:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            '${customerDetails.sqrts} sqft',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Address:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            customerDetails.address,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'City:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            customerDetails.city,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          // Add more Text widgets to display additional information from CustomerDetailsModel
        ],
      ),
    );

  }
}
