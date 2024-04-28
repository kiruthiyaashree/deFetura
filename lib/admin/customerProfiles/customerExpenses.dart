import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class CustomerExpensesPage extends StatefulWidget {
  final String customerName;
  const CustomerExpensesPage({required this.customerName, Key? key}) : super(key: key);

  @override
  _CustomerExpensesPageState createState() => _CustomerExpensesPageState();
}

class _CustomerExpensesPageState extends State<CustomerExpensesPage> {
  List<Map<String, dynamic>> expensesList = [];
  double initialBudget = 100000; // Initialize initial budget
  double totalBudget = 100000; // Initialize total budget

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
              onPressed: () async {
                setState(() {
                  expensesList.add({'itemName': itemName, 'expense': expense});
                  totalBudget -= expense; // Subtract expense from total budget
                  if (totalBudget <= initialBudget * 0.4) {
                    _sendEmail();
                  }
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
    final smtpServer = gmail('keerthikeerthe@gmail.com', '54432100');
    final message = Message()
      ..from = Address('keerthikeerthe@gmail.com', 'keerthi')
      ..recipients.add('kiruthiyaashree@example.com') // Replace with recipient's email
      ..subject = 'Budget Alert!'
      ..text = 'Your total budget has fallen below or equals to 40% of the initial budget.';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      print('Failed to send email: $e');
    }
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
              'Total Budget: \$${totalBudget.toStringAsFixed(2)}',
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
