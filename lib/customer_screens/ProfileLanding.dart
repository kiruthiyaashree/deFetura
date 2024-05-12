import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:construction/customer_screens/feeback.dart';
// import 'package:construction/customer_screens/feedback.dart'; // Assuming FeedbackForm is defined in this file
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

import '../models/customer_details_model.dart';
import 'package:construction/repositories/customer_details_repository.dart';

import 'Full_screen_photo.dart';

class Profile extends StatefulWidget {
  String customerName;
  Profile({required this.customerName, Key? key}) : super(key: key);

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
        Map<String, dynamic> data =
        snapshot.data() as Map<String, dynamic>;
        setState(() {
          for (int i = 0; i < trackingStages.length; i++) {
            String stageName = trackingStages[i].stageName;
            trackingStages[i] = TrackingStage(
              stageName: stageName,
              completed:
              data.containsKey(stageName) ? data[stageName] : false,
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
      trackingStages
          .add(TrackingStage(stageName: stageName, completed: false));
    }
  }

  Widget _buildTrackingContent() {
    int completedStagesCount =
        trackingStages.where((stage) => stage.completed).length;
    completionPercentage =
        (completedStagesCount / trackingStages.length) * 100;

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
      future: CustomerDetailsRepository.instance
          .getCustomerDetails(widget.customerName),
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
                  'address: ${customerDetails.address}',
                  style: TextStyle(fontSize: 20),
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
            .orderBy('timestamp', descending: true)
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

  Widget _buildExpensesColumn(
      List<DocumentSnapshot> documents, BuildContext context) {
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
                  Navigator.of(context).pop();
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
    CollectionReference expensesRef = firestore
        .collection('customerDetails')
        .doc(widget.customerName)
        .collection('expenses');

    // Reference to the document in the "customerDetails/customerName/totalbudget" collection
    DocumentReference totalBudgetRef = firestore
        .collection('customerDetails')
        .doc(widget.customerName)
        .collection('totalbudget')
        .doc('totalbudget');

    // Create a map with the expense data
    Map<String, dynamic> data = {
      'expense': amount,
      'timestamp': DateTime.now(), // Optional: Add a timestamp for sorting or reference
    };

    // Add the expense data to Firestore
    expensesRef.add(data).then((_) {
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Expense added successfully')),
      );

      // Check if the totalbudget document exists
      totalBudgetRef.get().then((totalBudgetSnapshot) {
        if (totalBudgetSnapshot.exists) {
          // If the document exists, retrieve the current total budget and update it
          Map<String, dynamic> totalBudgetData = totalBudgetSnapshot.data() as Map<String, dynamic>;
          double currentTotalBudget = double.parse(totalBudgetData['totalbudget']);
          double originalAmount = double.parse(amount);
          double newTotalBudget = currentTotalBudget + originalAmount;
          totalBudgetRef.update({'original':newTotalBudget.toString(),'totalbudget': newTotalBudget.toString()}).then((_) {
            // Show a success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Total budget updated successfully')),
            );
          }).catchError((error) {
            // Show an error message if updating the total budget fails
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update total budget: $error')),
            );
          });
        } else {
          // If the document doesn't exist, set it with the original amount
          totalBudgetRef.set({'flag': true, 'original': amount, 'totalbudget': amount}).then((_) {
            // Show a success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Total budget added successfully')),
            );
          }).catchError((error) {
            // Show an error message if setting the total budget fails
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add total budget: $error')),
            );
          });
        }
      }).catchError((error) {
        // Show an error message if retrieving the total budget fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to retrieve total budget: $error')),
        );
      });
    }).catchError((error) {
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
      MaterialPageRoute(
        builder: (context) => FullScreenPhoto(photoURL: photoURL),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.customerName),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Tracking'),
              Tab(text: 'Expenses'),
              Tab(text: 'Photos'),
              Tab(text: 'Feedback'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDetailsContent(),
            _buildTrackingContent(),
            _buildExpensesContent(context),
            _buildPhotosContent(),
            FeedbackForm(customerName: widget.customerName,), // Assuming FeedbackForm is a widget for collecting feedback
          ],
        ),
      ),
    );
  }
}

class TrackingStage {
  final String stageName;
  final bool completed;

  TrackingStage({required this.stageName, required this.completed});
}
