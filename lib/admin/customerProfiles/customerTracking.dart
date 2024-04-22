import 'package:flutter/material.dart';

class CustomerTracking extends StatefulWidget {
  const CustomerTracking({Key? key}) : super(key: key);

  @override
  State<CustomerTracking> createState() => _CustomerTrackingState();
}

class _CustomerTrackingState extends State<CustomerTracking> {
  List<bool> stageCompletion = List.filled(customStageNames.length, false);

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

  void _saveChanges() {
    // Implement saving changes to the database here
    // For demonstration purposes, let's print the updated stage completion statuses
    print(stageCompletion);
    // You can replace the above print statement with your database update logic
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
