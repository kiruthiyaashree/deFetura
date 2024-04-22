import 'package:flutter/material.dart';
import 'package:construction/customer_screens/feeback.dart'; // Assuming FeedbackForm is defined in this file
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io'; // Import path_provider plugin

class Profile extends StatefulWidget {
  final String userName;
  const Profile({Key? key, required this.userName}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // List to store tracking stages
  List<TrackingStage> trackingStages = [];

  @override
  void initState() {
    super.initState();
    // Initialize tracking stages
    _initializeTrackingStages();
  }

  List<String> customStageNames = [
    'started',
    'marking',
    'foundation of earth work excavation',
    'random rubble masonatory',
    'CR (course rubble) masontory',
    'earth filling / consolidation',
    'PCC (plain cement congrete)',
    'sill level brick work',
    'sill concrete',
    'lindel level brick work',
    'lindel sinside loft concrete',
    'roof level brick work',
    'roof slab RCC steel',
    'Fixing door and window frames',
    'electrical pipe gaddi work',
    'plastering work',
    'flooring /tiles work',
    'white wash/painting work',
    'electrification',
    'shutter fixing adn painting finish',
    'bath fittings',
    // Add more stage names here as per your requirement
  ];

  // Method to initialize tracking stages
  void _initializeTrackingStages() {
    // You can initialize the stages with their completion status here
    for (int i = 0; i < customStageNames.length; i++) {
      String stageName = customStageNames[i];
      trackingStages.add(TrackingStage(stageName: stageName, completed: false));
    }
  }

  Future<void> _viewPDFPlan(BuildContext context) async {
    final String path = 'assets/plan.pdf'; // Replace with the actual path to your PDF file
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFilePath = '${tempDir.path}/plan.pdf';
      final ByteData data = await rootBundle.load(path);
      final Uint8List bytes = data.buffer.asUint8List();
      await File(tempFilePath).writeAsBytes(bytes);
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => PDFView(filePath: tempFilePath)));
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget _buildTrackingContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'name:${widget.userName}',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'Project Name: ABC Project',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Location: XYZ Location',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Construction Start Date: January 1, 2024',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Construction End Date: June 30, 2025',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Architect: John Doe',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Contractor: XYZ Construction Company',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Building Type: Domestic House',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Number of Floors: 2',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Total Area: 20,000 sq. ft.',
            style: TextStyle(fontSize: 20),
          ),
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () {
              _viewPDFPlan(context); // Pass the context here
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesContent(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          ListTile(
            title: Text('Item 1'),
            subtitle: Text('Expense: \$100'),
          ),
          ListTile(
            title: Text('Item 2'),
            subtitle: Text('Expense: \$50'),
          ),
          // Add more list tiles as needed
        ],
      ),
    );
  }

  Widget _buildPhotosContent() {
    return Expanded(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.photo),
            title: Text('Photo 1'),
          ),
          ListTile(
            leading: Icon(Icons.video_library),
            title: Text('Video 1'),
          ),
          // Add more list tiles as needed
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Name'),
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(labelText: 'Complaint'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Implement form submission logic
            },
            child: Text('Submit'),
          ),
          SizedBox(height: 20),
          // Implement success/fail state here
          Text(
            'Submission Success/Failure State',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedback() {
    return FeedbackForm();
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
                            CircularProgressIndicator(
                              value: 0.5, // Example value
                              backgroundColor: Colors.black,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 4,
                            ),
                            Text(
                              '50%', // Example percentage
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
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

void main() {
  runApp(MaterialApp(
    home: Profile(userName: askUserName()),
  ));
}

String askUserName() {
  print('Enter your name:');
  String? name = stdin.readLineSync();
  while (name == null || name.isEmpty) {
    print('Please enter a valid name:');
    name = stdin.readLineSync();
  }
  return name;
}