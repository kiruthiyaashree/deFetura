// customer_details_display_page.dart
import 'package:flutter/material.dart';
import 'package:construction/models/customer_details_model.dart';
import 'package:construction/repositories/customer_details_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDetailsDisplayPage extends StatelessWidget {
  final String customerName;

  const CustomerDetailsDisplayPage({required this.customerName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<CustomerDetailsModel?>(
          future: CustomerDetailsRepository.instance.getCustomerDetails(customerName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final customerDetails = snapshot.data;
              if (customerDetails != null) {
                return _displayCustomerDetails(customerDetails);
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
            customerDetails.name ?? 'N/A',
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
            '${customerDetails.sqrts ?? 'N/A'} sqft',
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
            customerDetails.address ?? 'N/A',
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
            customerDetails.city ?? 'N/A',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Phone Number:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.phone),
                onPressed: () {
                  // Implement calling functionality here
                  print(customerDetails.phonenumber);
                  launch('tel:${customerDetails.phonenumber.toString()}');
                },
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            customerDetails.phonenumber ?? 'N/A', // Null check for phone number
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          // Add more Text widgets to display additional information from CustomerDetailsModel
        ],
      ),
    );
  }

}
