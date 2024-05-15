// customer_details_page.dart
import 'package:flutter/material.dart';
import 'package:construction/models/customer_details_model.dart';
import 'package:get/get.dart';
import 'package:construction/repositories/customer_details_repository.dart';
import 'customer_details_display_page.dart';

class CustomerDetailsPage extends StatefulWidget {
  final String customerName;

  const CustomerDetailsPage({required this.customerName, Key? key}) : super(key: key);

  @override
  _CustomerDetailsPageState createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  late TextEditingController customerNameController;
  late TextEditingController squareFootageController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController phoneNumberController;

  @override
  void initState() {
    super.initState();
    customerNameController = TextEditingController();
    squareFootageController = TextEditingController();
    addressController = TextEditingController();
    cityController = TextEditingController();
    phoneNumberController = TextEditingController();

  }

  @override
  void dispose() {
    customerNameController.dispose();
    squareFootageController.dispose();
    addressController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              Text(
                'Customer Name: ${widget.customerName}',
              ),
              TextFormField(
                controller: customerNameController,
                decoration: InputDecoration(labelText: 'Customer Name'),
              ),
              TextFormField(
                controller: squareFootageController,
                decoration: InputDecoration(labelText: 'Square Footage'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              ElevatedButton(
                child: Text('Submit'),
                onPressed: () async {
                  final detailsRepo = Get.put(CustomerDetailsRepository());
                  final customerName = customerNameController.text;
                  final squareFootage =squareFootageController.text;
                  final address = addressController.text;
                  final city = cityController.text;
                  final phonenumber = phoneNumberController.text;


                  final customerDetail = CustomerDetailsModel(
                    name: customerName,
                    sqrts: squareFootage,
                    address: address,
                    city: city,
                    phonenumber: phonenumber,
                  );

                  try {
                    await detailsRepo.addCustomerDetails(customerDetail);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Customer details added successfully.'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to add customer details.'),
                        backgroundColor: Colors.red.withOpacity(0.1),
                      ),
                    );
                  }

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CustomerDetailsDisplayPage( customerName: customerName,),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
