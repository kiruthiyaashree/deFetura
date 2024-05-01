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
        QuerySnapshot expensesSnapshot = await FirebaseFirestore.instance
            .collection('customerDetails')
            .doc(widget.customerName)
            .collection('expenses')
            .get();

        List<Map<String, dynamic>> expensesData = [];
        List<double> expenseAmounts = [];

        for (var doc in expensesSnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('expense')) {
            double expense = data['expense'] is String ? double.tryParse(data['expense']) ?? 0 : data['expense'];
            String itemName = data['itemName'] ?? '';
            expensesData.add({'itemName': itemName, 'expense': expense});
            expenseAmounts.add(expense);
          }
        }

        // Update totalBudget with the most recent expense amount if there's an expense without an itemName
        if (expenseAmounts.isNotEmpty) {
          expenseAmounts.sort((a, b) => b.compareTo(a)); // Sort in descending order
          totalBudget = expenseAmounts.last; // Assign with the most recent expense amount
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
                  totalBudget -= expense;
                  if (totalBudget <= initialBudget * 0.4) {
                    _sendEmail();
                  }
                });
                FirebaseFirestore.instance.collection('customerDetails')
                    .doc(widget.customerName)
                    .collection('expenses')
                    .add({'itemName': itemName, 'expense': expense});
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
              'Total Budget: ${totalBudget.toStringAsFixed(2)}',
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
