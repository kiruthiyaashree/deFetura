import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  String _name = '';
  double _qualitySliderValue = 0;
  double _onTimeSliderValue = 0;
  double _budgetSliderValue = 0;
  double _starRating = 0;

  void _submitFeedback() {
    // Here, you can process the feedback data, e.g., send it to an API or save it locally
    print('Name: $_name');
    print('Quality: $_qualitySliderValue');
    print('On Time: $_onTimeSliderValue');
    print('Within Budget: $_budgetSliderValue');
    print('Star Rating: $_starRating');
    // You can add more actions based on the feedback data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FeedbackForm(),
  ));
}
