import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:construction/admin/customerProfiles/customer_details_display_page.dart';
import 'package:construction/admin/customerProfiles/customerdetails.dart';
import 'package:construction/admin/customerProfiles/customerphotos.dart';
import 'package:construction/admin/customerProfiles/customerExpenses.dart';
import 'package:construction/admin/customerProfiles/customerTracking.dart';
import '../../repositories/customer_details_repository.dart';
import 'package:construction/admin/customerProfiles/customer_complaints_page.dart';
import 'package:construction/admin/customerProfiles/customer_feedback_page.dart';
class CustomerProfilePage extends StatefulWidget {
  final String customerName;

  const CustomerProfilePage({required this.customerName, Key? key}) : super(key: key);

  @override
  _CustomerProfilePageState createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  int _selectedIndex = 0;

  List<String> _appBarTitles = ['Details', 'Photos', 'Expenses', 'Tracking', 'Complaints', 'Feedbacks'];
  final detailsRepo = Get.put(CustomerDetailsRepository());

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
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Complaints', // Add a complaints icon and label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedbacks', // Add a feedbacks icon and label
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
        return FutureBuilder<bool>(
          future: detailsRepo.checkCustomerDetailsExist(widget.customerName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while checking for existence
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Show an error message if there's an error
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // Check if the details exist and navigate accordingly
              if (snapshot.data!) {
                return CustomerDetailsDisplayPage(
                    customerName: widget.customerName,);
              } else {
                return CustomerDetailsPage(customerName: widget.customerName);
              }
            }
          },
        );
      case 1:
        return CustomerPhotosPage(customerName: widget.customerName,);
      case 2:
        return CustomerExpensesPage(customerName: widget.customerName,);
      case 3:
        return CustomerTracking(customerName : widget.customerName);
      case 4:
        return CustomerComplaintsPage(customerName : widget.customerName); // Add the complaints page
      case 5:
        return CustomerFeedbacksPage(customerName : widget.customerName); // Add the feedbacks page
      default:
        return Container();
    }
  }
}
