import 'package:flutter/material.dart';

class CustomerExpensesPage extends StatefulWidget {
  const CustomerExpensesPage({Key? key}) : super(key: key);

  @override
  _CustomerExpensesPageState createState() => _CustomerExpensesPageState();
}

class _CustomerExpensesPageState extends State<CustomerExpensesPage> {
  List<Map<String, dynamic>> expensesList = [];
  double totalBudget = 1000; // Initialize total budget

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
                decoration: InputDecoration(labelText: 'Expense'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  expensesList.add({'itemName': itemName, 'expense': expense});
                  totalBudget -= expense; // Subtract expense from total budget
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0,30,0,0),
            child:
            Text(
              'Total Budget: \$${totalBudget.toStringAsFixed(2)}', // Display total budget
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expensesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(expensesList[index]['itemName']),
                  subtitle: Text('Expense: \$${expensesList[index]['expense']}'),
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
