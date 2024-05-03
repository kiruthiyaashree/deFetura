import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _fetchExpenses() async {
    try {
      if (widget.customerName != null && widget.customerName.isNotEmpty) {
        // Retrieve initial totalBudget from Firestore
        DocumentSnapshot totalBudgetSnapshot = await FirebaseFirestore.instance
            .collection('customerDetails')
            .doc(widget.customerName)
            .collection('totalbudget')
            .doc('totalbudget')
            .get();

        if (totalBudgetSnapshot.exists) {
          Map<String, dynamic>? totalBudgetData = totalBudgetSnapshot.data() as Map<String, dynamic>?;

          if (totalBudgetData != null) {
            initialBudget = totalBudgetData['initialBudget'] ?? 0;
            totalBudget = totalBudgetData['totalBudget'] ?? 0;
          } else {
            // If the document doesn't exist or data is null, initialize totalBudget to 0
            initialBudget = 0;
            totalBudget = 0;
          }
        }

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
            String itemName = data['itemName'] ?? '';

            // Check if the expense has no itemName
            if (itemName.isEmpty) {
              // Add the expense amount to the list of expenses without an itemName
              expenseAmountsWithoutItemName.add(expense);
            }

            expensesData.add({'itemName': itemName, 'expense': expense, 'timestamp': data['timestamp']});
          }
        }

        if (expenseAmountsWithoutItemName.isNotEmpty) {
          print(totalBudget);

          totalBudget = expenseAmountsWithoutItemName.last;
        }

        setState(() {
          expensesList = expensesData;
        });
      }
    } catch (e) {
      print('Error fetching expenses: $e');
    }
  }

  void _addExpense(BuildContext context) async {
    String itemName = '';
    double expense = 0;

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
                  expensesList.add({'itemName': itemName, 'expense': expense});
                  if (itemName.isEmpty) {
                    totalBudget -= expense;
                  }
                  if (totalBudget <= initialBudget * 0.4) {
                    _sendEmail();
                  }
                });

                // Update totalBudget in Firestore
                FirebaseFirestore.instance.collection('customerDetails')
                    .doc(widget.customerName)
                    .collection('expenses')
                    .add({'itemName': itemName, 'expense': expense});

                // Update totalBudget in Firestore
                FirebaseFirestore.instance.collection('customerDetails')
                    .doc(widget.customerName)
                    .collection('totalbudget')
                    .doc('totalbudget')
                    .set({'initialBudget': initialBudget, 'totalBudget': totalBudget - expense}, SetOptions(merge: true));

                // Update the displayed totalBudget
                setState(() {
                  totalBudget -= expense;
                });

                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendEmail() async {
    // Your email sending logic remains the same
  }

  @override
  Widget build(BuildContext context) {
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
                  subtitle: Text('Amount: ${expensesList[index]['expense'] ?? 'N/A'}'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addExpense(context),
        tooltip: 'Add Expense',
        child: Icon(Icons.attach_money),
      ),
    );
  }
}
