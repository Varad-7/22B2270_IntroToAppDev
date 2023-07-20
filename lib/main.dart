import 'package:flutter/material.dart';

void main() {
  runApp(BudgetTrackerApp());
}

class BudgetTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budget Tracker',
      home: BudgetTrackerScreen(),
    );
  }
}

class BudgetTrackerScreen extends StatefulWidget {
  @override
  _BudgetTrackerScreenState createState() => _BudgetTrackerScreenState();
}

class _BudgetTrackerScreenState extends State<BudgetTrackerScreen> {
  List<Expense> expenses = [];

  void _addExpense(String category, double amount) {
    setState(() {
      expenses.add(Expense(category: category, amount: amount));
    });
  }

  void _deleteExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
  }

  double get totalAmount {
    return expenses.fold(0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent[200],
        title: const Text(
          'Budget Tracker',
          style: TextStyle(
            color: Colors.black,
            fontSize: 33,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(128.0,880.0,175.0,0.0),
        child: FloatingActionButton(
          splashColor: Colors.white60,
          backgroundColor: Colors.cyanAccent,
          onPressed: () => _openExpenseDialog(),
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 31,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(7.0),
            child: Column(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 60,
                ),
                Divider(
                  color: Colors.white,
                  indent: 163,
                  endIndent: 163,
                  thickness: 2.5,
                ),
                Text(
                  'Total: RS ${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 29.0,
                      fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.lightGreenAccent,
            thickness: 4,
            indent: 87,
            endIndent: 87,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                          expense.category,
                        style: const TextStyle(
                          fontSize: 21.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Rs ${expense.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 21.0,
                                fontWeight: FontWeight.bold,
                            color: Colors.white),
                          ),
                          IconButton(
                            icon: const Icon(
                                Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () => _deleteExpense(index),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 2,
                      indent: 50,
                      endIndent: 50,
                    ), // Divider line after each expense item
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openExpenseDialog() {
    String category = '';
    double amount = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: const Center(child: Text('Add Expense')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (value) {
                  setState(() {
                    category = value;
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    amount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (category.isNotEmpty && amount != 0.0) {
                  _addExpense(category, amount);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class Expense {
  final String category;
  final double amount;

  Expense({required this.category, required this.amount});
}
