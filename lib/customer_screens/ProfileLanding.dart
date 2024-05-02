import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:construction/customer_screens/feeback.dart'; // Assuming FeedbackForm is defined in this file
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

import '../models/customer_details_model.dart';
import 'package:construction/repositories/customer_details_repository.dart';

import 'Full_screen_photo.dart';
class Profile extends StatefulWidget {
  String customerName;
  Profile({required this.customerName,Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  double completionPercentage = 0.0;
  // List to store tracking stages
  List<TrackingStage> trackingStages = [];
  // TextEditingController _nameController = TextEditingController();
  TextEditingController _complaintController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize tracking stages
    _initializeTrackingStages();
    // Load tracking steps
    _loadTrackingSteps();
  }
  void _loadTrackingSteps() {
    // Reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the document in Firestore
    DocumentReference customerDocRef = firestore
        .collection('customerDetails')
        .doc(widget.customerName) // Assuming customer name is the document ID
        .collection('tracking')
        .doc('trackingData');

    // Fetch data from Firestore and update tracking stages accordingly
    customerDocRef.get().then((snapshot) {
      if (snapshot.exists) {
        // Extract data from snapshot and update tracking stages list
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          for (int i = 0; i < trackingStages.length; i++) {
            String stageName = trackingStages[i].stageName;
            trackingStages[i] = TrackingStage(
              stageName: stageName,
              completed: data.containsKey(stageName) ? data[stageName] : false,
            );
          }
        });
      }
    }).catchError((error) {
      print("Error loading tracking data: $error");
    });
  }


  List<String> customStageNames = [
    'started',
    'marking',
    'foundation of earth work excavation',
    'random rubble masonry',
    'CR (course rubble) masonry',
    'earth filling / consolidation',
    'PCC (plain cement concrete)',
    'sill level brickwork',
    'sill concrete',
    'lintel level brickwork',
    'lintel inside loft concrete',
    'roof level brickwork',
    'roof slab RCC steel',
    'Fixing door and window frames',
    'electrical pipe gaddi work',
    'plastering work',
    'flooring /tiles work',
    'white wash/painting work',
    'electrification',
    'shutter fixing and painting finish',
    'bath fittings',
  ];

  void _initializeTrackingStages() {
    for (int i = 0; i < customStageNames.length; i++) {
      String stageName = customStageNames[i];
      trackingStages.add(TrackingStage(stageName: stageName, completed: false));
    }
  }


  Widget _buildTrackingContent() {
    int completedStagesCount = trackingStages.where((stage) => stage.completed).length;
    completionPercentage = (completedStagesCount / trackingStages.length) * 100;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: trackingStages.map((stage) {
              return Column(
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  _buildTrackingStep(stage.stageName, stage.completed),
                  _buildDivider(),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }


  Widget _buildTrackingStep(String title, bool completed) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black),
            color: completed ? Colors.black : Colors.transparent,
          ),
          child: Icon(
            Icons.check,
            color: completed ? Colors.white : Colors.transparent,
            size: 16,
          ),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        color: Colors.black,
        thickness: 1,
        height: 1,
      ),
    );
  }

  Widget _buildDetailsContent() {
    return FutureBuilder<CustomerDetailsModel?>(
      future: CustomerDetailsRepository.instance.getCustomerDetails(widget.customerName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final customerDetails = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'name: ${customerDetails.name}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  'Square Footage: ${customerDetails.sqrts}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  style: TextStyle(fontSize: 20),
                  'address: ${customerDetails.address}',

                ),
                SizedBox(height: 10),
                Text(
                  'City: ${customerDetails.city}',
                  style: TextStyle(fontSize: 20),
                ),

                SizedBox(height: 10),
              ],
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }

  String addedAmount = ''; // Variable to store the added amount, initialized with an empty string

  Widget _buildExpensesContent(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('customerDetails')
            .doc(widget.customerName)
            .collection('expenses')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return _buildExpensesColumn(documents, context);
          } else {
            return Center(child: Text('No expenses available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEnterAmountDialog(context).then((value) {
            setState(() {
              addedAmount = value ?? '';
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildExpensesColumn(List<DocumentSnapshot> documents, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExpensesList(documents),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            addedAmount,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }


  Widget _buildExpensesList(List<DocumentSnapshot> documents) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: documents.map((document) {
            final expenseData = document.data() as Map<String, dynamic>;
            final itemName = expenseData['itemName'];
            final expense = expenseData['expense'];
            final hasItemName = itemName != null && itemName.isNotEmpty;

            return ListTile(
              title: Text(
                hasItemName ? itemName : 'Credited amount',
                style: TextStyle(
                  color: hasItemName ? Colors.black : Colors.red,
                ),
              ),
              subtitle: Text('Expense: $expense'),
            );
          }).toList(),
        ),
      ),
    );
  }


  Future<String?> _showEnterAmountDialog(BuildContext context) async {
    TextEditingController _amountController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Expense Amount'),
          content: TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
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
              child: Text('Save'),
              onPressed: () {
                // Handle saving the entered amount
                String amount = _amountController.text.trim();
                if (amount.isNotEmpty) {
                  _saveExpenseToFirestore(amount);
                  // Close the dialog and pass the entered amount back to the caller
                  Navigator.of(context).pop(amount);
                } else {
                  // Show an error message if the amount is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter an amount')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _saveExpenseToFirestore(String amount) {
    // Reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the document in the "customerDetails/customerName/expenses" collection
    CollectionReference expensesRef = firestore.collection('customerDetails').doc(widget.customerName).collection('expenses');

    // Create a map with the expense data
    Map<String, dynamic> data = {
      'expense': amount,
      'timestamp': DateTime.now(), // Optional: Add a timestamp for sorting or reference
    };

    // Add the expense data to Firestore
    expensesRef.add(data)
        .then((_) {
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Expense added successfully')),
      );
    })
        .catchError((error) {
      // Show an error message if submission fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add expense: $error')),
      );
    });
  }

  Future<List<String>> _getPhotos() async {
    List<String> photoURLs = [];

    try {
      // Reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query the photos sub-collection
      QuerySnapshot querySnapshot = await firestore
          .collection('customerDetails')
          .doc(widget.customerName)
          .collection('photos')
          .get();

      // Extract photo URLs from the query snapshot
      querySnapshot.docs.forEach((doc) {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('photoURL')) {
            photoURLs.add(data['photoURL']);
          }
        }
      });
    } catch (error) {
      print('Error retrieving photos: $error');
    }

    return photoURLs;
  }

  Widget _buildPhotosContent() {
    return FutureBuilder<List<String>>(
      future: _getPhotos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final List<String> photoURLs = snapshot.data!;
          return Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: photoURLs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _viewFullScreenPhoto(context, photoURLs[index]);
                  },
                  child: Image.network(photoURLs[index], fit: BoxFit.cover),
                );
              },
            ),
          );
        } else {
          return Center(child: Text('No photos available'));
        }
      },
    );
  }
  void _viewFullScreenPhoto(BuildContext context, String photoURL) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FullScreenPhoto(photoURL: photoURL)),
    );
  }

  Widget _buildFormContent() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Remove the TextField for entering the name
          TextField(
            decoration: InputDecoration(labelText: 'Complaint'),
            controller: _complaintController,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              String complaint = _complaintController.text.trim();
              if (widget.customerName.isNotEmpty && complaint.isNotEmpty) {
                // Pass widget.customerName instead of name
                _submitComplaint(widget.customerName, complaint);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Customer name and complaint cannot be empty')),
                );
              }
            },
            child: Text('Submit'),
          ),
          SizedBox(height: 20),
          Text(
            'Submission Success/Failure State',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }


  void _submitComplaint(String customerName, String complaint) {
    // Reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the document in the "Users" collection and "complaints" sub-collection
    CollectionReference complaintsRef = firestore.collection('Users').doc(customerName).collection('complaints');

    // Create a map with the complaint data
    Map<String, dynamic> data = {
      'name': customerName, // Use customerName instead of name
      'complaint': complaint,
      'timestamp': DateTime.now(), // Optional: Add a timestamp for sorting or reference
    };

    // Add the complaint data to Firestore
    complaintsRef.add(data)
        .then((_) {
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complaint submitted successfully')),
      );
      _complaintController.clear();
    })
        .catchError((error) {
      // Show an error message if submission fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit complaint: $error')),
      );
    });
  }

  Widget _buildFeedback() {
    return FeedbackForm(customerName:widget.customerName,);
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    // Switching content based on the selected index
    switch (selectedIndex) {
      case 0:
        content = _buildDetailsContent();
        break;
      case 1:
        content = _buildTrackingContent();
        break;
      case 2:
        content = _buildExpensesContent(context);
        break;
      case 3:
        content = _buildPhotosContent();
        break;
      case 4:
        content = _buildFormContent();
        break;
      case 5:
        content = _buildFeedback();
        break;
      default:
        content = SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Handle profile icon button press
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: MediaQuery.of(context).size.width * 0.5 - 50,
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(
                                value: completionPercentage / 100, // Dynamic value based on completion percentage
                                backgroundColor: Colors.black,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 4,
                              ),
                            ),
                            Text(
                              '${completionPercentage.toStringAsFixed(0)}%', // Show the completion percentage
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Center(child: content),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Tracking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Photos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Form',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
          // Additional bottom bar items and functionalities
        ],
      ),
    );
  }

  int selectedIndex = 0; // Index of the selected tab, defaults to 0
}

class TrackingStage {
  final String stageName;
  final bool completed;

  TrackingStage({required this.stageName, required this.completed});
}


