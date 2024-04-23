import 'package:flutter/material.dart';
import 'package:construction/admin/customerProfiles/customerProfile.dart';
import 'package:get/get.dart';
import 'package:construction/repositories/user_repository.dart';

import '../models/user_models.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<String> customers = [];
  bool _isPasswordVisible = false;
  final userRepo = Get.put(UserRepository());
  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    try {
      // Retrieve user documents from the repository
      final users = await userRepo.getUsers();

      setState(() {
        // Extract names from user documents and add them to the customers list
        customers = users.map((user) => user.name).toList();
      });
    } catch (error) {
      print('Failed to load customers: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Implement notification handling
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Implement settings page navigation
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Implement profile changing functionality
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCustomerDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[200],
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSi449HnWhEynirgfotum0Ic1J7eNhtIVWIQ&usqp=CAU',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              Positioned(
                child: Container(
                  margin: EdgeInsets.all(50),
                  child: Center(
                    child: Text(
                      'Welcome, Admin!',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (BuildContext context, int index) {
                String customerName = customers[index]!;
                return ListTile(
                  title: Text(customerName),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerProfilePage(
                            customerName: customerName,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCustomerDialog(BuildContext context) {
    String newCustomerName = '';
    String newCustomerEmail = '';
    String newCustomerPassword = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Customer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newCustomerName = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter customer name',
                ),
              ),
              TextField(
                onChanged: (value) {
                  newCustomerEmail = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter customer email',
                ),
              ),
              TextField(
                onChanged: (value) {
                  newCustomerPassword = value;
                },
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Enter customer password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                // Create a new user model
                final user = UserModel(
                  name: newCustomerName,
                  email: newCustomerEmail,
                  password: newCustomerPassword,
                );

                try {
                  // Call the repository method to create the user
                  await userRepo.createUser(user);
                  // Add the new customer name to the list
                  setState(() {
                    customers.add(newCustomerName);
                  });
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Account created successfully.'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } catch (error) {
                  // Show error message if account creation fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to create account'),
                      backgroundColor: Colors.red.withOpacity(0.1),
                    ),
                  );
                }

                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}

void main() {
  runApp(MaterialApp(
    home: AdminHome(),
    theme: ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
      ),
    ),
  ));
}
