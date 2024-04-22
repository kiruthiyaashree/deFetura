import 'package:flutter/material.dart';
import 'package:construction/admin/customerProfiles/customerProfile.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<String> customerNames = ['saravanan', 'keerthana', 'keerthiya'];

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
            icon: Icon(Icons.person), // Profile changing icon button
            onPressed: () {
              // Implement profile changing functionality
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCustomerDialog(context); // Call function to show dialog
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[200], // Customize the color if needed
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSi449HnWhEynirgfotum0Ic1J7eNhtIVWIQ&usqp=CAU', // Placeholder image path
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height *
                    0.3, // 30% of screen height
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
                        color: Colors.black, // Text color
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
              itemCount: customerNames.length,
              itemBuilder: (BuildContext context, int index) {
                String customerName = customerNames[index];
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

  // Function to show dialog for adding customer
  void _showAddCustomerDialog(BuildContext context) {
    String newCustomerName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Customer'),
          content: TextField(
            onChanged: (value) {
              newCustomerName = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter customer name',
            ),
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
              onPressed: () {
                setState(() {
                  customerNames.add(newCustomerName); // Add new customer to the list
                });
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
        backgroundColor: Colors.white, // Set the common app bar background color
      ),
    ),
  ));
}
