import 'package:flutter/material.dart';

import 'package:construction/admin/customerProfiles/customerdetails.dart';
import 'package:construction/admin/customerProfiles/customerphotos.dart';
import 'package:construction/admin/customerProfiles/customerExpenses.dart';
import 'package:construction/admin/customerProfiles/customerTracking.dart';

class CustomerProfilePage extends StatefulWidget {
  final String customerName;

  const CustomerProfilePage({required this.customerName, Key? key}) : super(key: key);

  @override
  _CustomerProfilePageState createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  int _selectedIndex = 0;

  List<String> _appBarTitles = ['Details', 'Photos', 'Expenses', 'Tracking'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]), // Dynamically set the title
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: _getBody(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Photos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Tracking',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return CustomerDetailsPage(customerName: widget.customerName);
      case 1:
        return CustomerPhotosPage();
      case 2:
        return CustomerExpensesPage();
      case 3:
        return CustomerTracking();
      default:
        return Container();
    }
  }
}
