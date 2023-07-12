import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  home: CounterApp(),
));

class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Counter App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.amber,
            fontSize: 27,
          ),
        ),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Varad${"'"}s Counter Value :',
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.amberAccent,
                ),
              ),
              Text(
                '$counter',
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                counter += 1;
              });
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                counter -= 1;
              });
            },
            child: Icon(Icons.remove),
          ),
        ],
      ),
      backgroundColor: Colors.grey[800],
    );
  }
}
