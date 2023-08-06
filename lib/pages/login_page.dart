import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signIn() async {
    try {

      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator()
            );
          }
      );

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.of(context).pop();

      // Navigate to the BudgetTrackerApp after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BudgetTrackerApp()),
      );
    } catch (e) {
      // Handle login errors here (e.g., display an error message)
      print('Login failed: $e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[600],
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey,Colors.cyanAccent ,Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight// center: Alignment.center,
            // radius: 0.9,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                    size: 117,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'LOG IN',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 53,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                    indent: 112,endIndent: 112,
                    thickness: 3,
                  ),
                  const SizedBox(height: 54),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "    Email",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true, // Make the password field hidden
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "    Password",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 54),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: GestureDetector(
                      onTap: signIn,
                      child: Container(
                        width: 140,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
