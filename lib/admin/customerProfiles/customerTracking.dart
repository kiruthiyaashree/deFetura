import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerTracking extends StatefulWidget {
  final String customerName;
  const CustomerTracking({required this.customerName, Key? key}) : super(key: key);

  @override
  State<CustomerTracking> createState() => _CustomerTrackingState();
}

class _CustomerTrackingState extends State<CustomerTracking> {
  late List<bool> stageCompletion;

  @override
  void initState() {
    super.initState();
    // Initialize stageCompletion list with false values
    stageCompletion = List.filled(customStageNames.length, false);
    // Load stage completion data from Firestore when the widget initializes
    _loadStageCompletionData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: customStageNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(customStageNames[index]),
            trailing: Checkbox(
              value: stageCompletion[index],
              onChanged: (value) {
                setState(() {
                  stageCompletion[index] = value!;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveChanges,
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }

  void _loadStageCompletionData() {
    // Reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the document in Firestore
    DocumentReference customerDocRef = firestore
        .collection('customerDetails')
        .doc(widget.customerName) // Assuming customer name is the document ID
        .collection('tracking')
        .doc('trackingData');

    // Fetch data from Firestore and update stageCompletion list accordingly
    customerDocRef.get().then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          // Extract data from snapshot and update stageCompletion list
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          for (int i = 0; i < customStageNames.length; i++) {
            stageCompletion[i] = data[customStageNames[i]] ?? false;
          }
        });
      }
    }).catchError((error) {
      print("Error loading stage completion data: $error");
    });
  }

  void _saveChanges() {
    // Reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the document in Firestore for tracking data
    DocumentReference trackingDocRef = firestore
        .collection('customerDetails')
        .doc(widget.customerName) // Assuming customer name is the document ID
        .collection('tracking')
        .doc('trackingData');

    // Reference to the document in Firestore for percentage data
    DocumentReference percentageDocRef = firestore
        .collection('customerDetails')
        .doc(widget.customerName) // Assuming customer name is the document ID
        .collection('tracking')
        .doc('percentage');

    // Create a map of stage names and their completion statuses
    Map<String, dynamic> data = {};
    int completedStages = 0;
    for (int i = 0; i < customStageNames.length; i++) {
      data[customStageNames[i]] = stageCompletion[i];
      if (stageCompletion[i]) {
        completedStages++;
      }
    }

    // Calculate completion percentage
    double completionPercentage = (completedStages / customStageNames.length) * 100;
    completionPercentage = double.parse(completionPercentage.toStringAsFixed(2)); // Round to two decimal places

// Update the tracking data document with the new data
    trackingDocRef.set(data, SetOptions(merge: true))
        .then((value) {
      print("Tracking data updated successfully");
      // Update the percentage document with the completion percentage
      percentageDocRef.set({'percentage': completionPercentage}, SetOptions(merge: true))
          .then((value) => print("Completion percentage updated successfully"))
          .catchError((error) => print("Failed to update completion percentage: $error"));
    })
        .catchError((error) => print("Failed to update tracking data: $error"));

  }

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
