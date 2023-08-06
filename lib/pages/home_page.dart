import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


Future<void> _addExpenseToFirestore(String category, double amount) async {
  try {
    final firestore = FirebaseFirestore.instance;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      final expenseData = {
        'category': category,
        'amount': amount,
      };

      await firestore.collection('expenses').add(expenseData);
    }
  } catch (e) {
    print('Error adding expense to Firestore: $e');
  }
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
    _addExpenseToFirestore(category, amount);
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 3,
        shadowColor: Colors.white,
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Budget Tracker',
          style: TextStyle(
            color: Colors.white,
            fontSize: 33,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(128.0,880.0,175.0,0.0),
        child: FloatingActionButton(
          elevation: 1,
          splashColor: Colors.white60,
          backgroundColor: Colors.grey[300],
          onPressed: () => _openExpenseDialog(),
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 35,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black,Colors.purpleAccent,Colors.teal], // Adjust colors as needed
            begin: Alignment.topRight,
            end: Alignment.bottomRight
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 60,
                  ),
                  const Divider(
                    color: Colors.white,
                    indent: 190,
                    endIndent: 190,
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
              color: Colors.blueAccent,
              thickness: 4,
              indent: 87,
              endIndent: 87,
            ),
            const SizedBox(height: 5),
            const Divider(
              color: Colors.amber,
              thickness: 4,
              indent: 177,
              endIndent: 177,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return Column(
                    children: [
                      Slidable(
                        endActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) => _deleteExpense(index),
                              icon: Icons.delete,
                              backgroundColor: Colors.red,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            expense.category,
                            style: const TextStyle(
                              fontSize: 21.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          trailing: Text(
                            'Rs ${expense.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 21.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.black45,
                        height: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ],
                  );
                },
              ),
            ),

          ],
        ),
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