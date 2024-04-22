import 'package:flutter/material.dart';

class CustomerDetailsPage extends StatelessWidget {
  final String customerName;

  const CustomerDetailsPage({required this.customerName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Customer Details for $customerName'),
      ),
    );
  }
}
