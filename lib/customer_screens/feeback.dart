import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
class FeedbackForm extends StatefulWidget {
  final String customerName;

  const FeedbackForm({Key? key, required this.customerName}) : super(key: key);

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  String _name = '';
  double _qualitySliderValue = 0;
  double _onTimeSliderValue = 0;
  double _budgetSliderValue = 0;
  double _starRating = 0;
  String _comment = ''; // Added comment field
  @override
  void initState() {
    super.initState();
    _name = widget.customerName; // Initialize _name with customerName passed from widget
  }
  void _submitFeedback() {
    if (widget.customerName.isEmpty) {
      print(widget.customerName);
      // Show an error message or prompt the user to provide their name
      print('Name is empty. Please provide your name.');
      return; // Exit the method if customerName is empty
    }

    // Access Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a map containing feedback details
    Map<String, dynamic> feedbackData = {
      'name': widget.customerName,
      'quality': _qualitySliderValue,
      'onTime': _onTimeSliderValue,
      'budget': _budgetSliderValue,
      'starRating': _starRating,
      'comment': _comment,
    };

    // Add feedback data to Firestore
    firestore
        .collection('Users')
        .doc(widget.customerName)
        .collection('feedback')
        .add(feedbackData)
        .then((_) {
      print('Feedback submitted successfully');
      // You can add more actions here if needed
    }).catchError((error) {
      print('Error submitting feedback: $error');
    });
  }


  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text('Quality of work: ${_qualitySliderValue.toInt()}'),
              Slider(
                value: _qualitySliderValue,
                onChanged: (value) {
                  setState(() {
                    _qualitySliderValue = value;
                  });
                },
                min: 0,
                max: 10,
                divisions: 10,
                label: _qualitySliderValue.toInt().toString(),
                activeColor: Colors.green,
              ),
              SizedBox(height: 20),
              Text(
                'name:$_name',
              ),
              Text('Work completed on time: ${_onTimeSliderValue.toInt()}'),
              Slider(
                value: _onTimeSliderValue,
                onChanged: (value) {
                  setState(() {
                    _onTimeSliderValue = value;
                  });
                },
                min: 0,
                max: 10,
                divisions: 10,
                label: _onTimeSliderValue.toInt().toString(),
                activeColor: Colors.green,
              ),
              SizedBox(height: 20),
              Text('Within budget: ${_budgetSliderValue.toInt()}'),
              Slider(
                value: _budgetSliderValue,
                onChanged: (value) {
                  setState(() {
                    _budgetSliderValue = value;
                  });
                },
                min: 0,
                max: 10,
                divisions: 10,
                label: _budgetSliderValue.toInt().toString(),
                activeColor: Colors.green,
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text('Star Rating:'),
                    RatingBar.builder(
                      initialRating: _starRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 40,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _starRating = rating;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text('Comment:'), // Add a label for the comment box
              TextField( // Add a text field for entering comments
                onChanged: (value) {
                  setState(() {
                    _comment = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter your comment here',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitFeedback,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(16)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

