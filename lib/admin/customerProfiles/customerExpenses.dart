import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:sms/sms.dart';
class CustomerExpensesPage extends StatefulWidget {
  final String customerName;

  const CustomerExpensesPage({required this.customerName, Key? key}) : super(key: key);

  @override
  _CustomerExpensesPageState createState() => _CustomerExpensesPageState();
}

class _CustomerExpensesPageState extends State<CustomerExpensesPage> {
  List<Map<String, dynamic>> expensesList = [];
  double initialBudget = 0;
  double totalBudget = 0;
  double original = 0;


// timestamp infos
  @override
  void initState() {
    super.initState();
    _fetchTotalBudget();
    _fetchExpenses();
  }

  Future<void> _fetchTotalBudget() async {
    try {
      DocumentSnapshot totalBudgetSnapshot = await FirebaseFirestore.instance
          .collection('customerDetails')
          .doc(widget.customerName)
          .collection('totalbudget')
          .doc('totalbudget')
          .get();
      if (totalBudgetSnapshot.exists) {
        Map<String, dynamic>? totalBudgetData = totalBudgetSnapshot.data() as Map<String, dynamic>?;

        if (totalBudgetData != null) {
          if(totalBudgetData['flag'] == true) {
            // update flag
            original = totalBudgetData['original'] is String ? double.tryParse(totalBudgetData['original'])!  ?? 0 : totalBudgetData['original'] ?? 0;
            totalBudget = totalBudgetData['totalbudget'] is String ? double.tryParse(totalBudgetData['totalbudget'])! ?? 0 : totalBudgetData['totalbudget'] ?? 0;
          }
          else{
            totalBudget = totalBudgetData['totalbudget'] is String ? double.tryParse(totalBudgetData['totalbudget']) ?? 0 : totalBudgetData['totalbudget'] ?? 0;
          }
        } else {
          initialBudget = 0;
          totalBudget = 0;
          original = 0;
        }

        // After fetching the totalBudget, call _fetchExpenses to ensure it's fetched before using it
        _fetchExpenses();
      }
    } catch (error) {
      print('Error fetching total budget: $error');
    }
  }

  Future<void> _fetchExpenses() async {
    try {
      if (widget.customerName != null && widget.customerName.isNotEmpty) {
        QuerySnapshot expensesSnapshot = await FirebaseFirestore.instance
            .collection('customerDetails')
            .doc(widget.customerName)
            .collection('expenses')
            .get();

        List<Map<String, dynamic>> expensesData = [];
        List<double> expenseAmountsWithoutItemName = [];

        for (var doc in expensesSnapshot.docs) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          if (data != null && data.containsKey('expense')) {
            double expense = data['expense'] is String ? double.tryParse(data['expense']) ?? 0 : data['expense'];
            String itemName = data['itemName'] ?? 'credited amount';

            if (itemName.isEmpty) {
              expenseAmountsWithoutItemName.add(expense);
            }

            expensesData.add({'itemName': itemName, 'expense': expense, 'timestamp': data['timestamp']});
          }
        }

        if (expenseAmountsWithoutItemName.isNotEmpty) {
          original = expenseAmountsWithoutItemName.last + totalBudget;
        }

        setState(() {
          expensesList = expensesData;
        });
      }
    } catch (e) {
      print('Error fetching expenses: $e');
    }
  }


  void _validateAndMail()
  {
    if (totalBudget <= original * 0.3) {
      print("The total budget is less than or equal to 30% of the original budget.");
      _sendEmail();
    }
  }
  void _addExpense(BuildContext context) async {
    String itemName = '';
    double expense = 0;
    DateTime timestamp = DateTime.now();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  itemName = value;
                },
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                onChanged: (value) {
                  expense = double.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(labelText: 'Amount'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                setState(() {
                  expensesList.add({'itemName': itemName, 'expense': expense, 'timestamp': timestamp});
                  if (itemName.isEmpty) {
                    totalBudget -= expense;
                  }
                });

                await FirebaseFirestore.instance.collection('customerDetails')
                    .doc(widget.customerName)
                    .collection('expenses')
                    .add({'itemName': itemName, 'expense': expense, 'timestamp': timestamp});

                await FirebaseFirestore.instance.collection('customerDetails')
                    .doc(widget.customerName)
                    .collection('totalbudget')
                    .doc('totalbudget')
                    .set({'totalbudget': (totalBudget - expense).toString(),},
                    SetOptions(merge: true));

                setState(() {
                  totalBudget -= expense;
                });
                _validateAndMail();
                Navigator.of(context).pop();
                _fetchTotalBudget(); // Call to update total budget
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
  void _sendSMS(String message, List<String> recipents) async {

  }
  Future<void> _sendEmail() async {
    String message = "This is a test message!";
    List<String> recipents = ["8438005578"];

    _sendSMS(message, recipents);

    }

    @override
    Widget build(BuildContext context) {

      // Sort the expensesList based on timestamp in descending order
      expensesList.sort((a, b) =>
          (b['timestamp'] as Timestamp).compareTo(a['timestamp'] as Timestamp));

      return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total Budget: $totalBudget',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: expensesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(expensesList[index]['itemName'] ?? ''),
                    subtitle: Text(
                        'Amount: ${expensesList[index]['expense'] ?? 'N/A'}'),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => _addExpense(context),
              tooltip: 'Add Expense',
              child: Icon(Icons.attach_money),
            ),
            SizedBox(height: 16), // Add some spacing between the buttons

          ],
        ),

      );
    }


}

