import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice/pages/home_page.dart';
import 'package:practice/pages/login_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ( context , snapshot ) {
        if(snapshot.hasData){
          return BudgetTrackerApp();
          }else{
              return LoginPage();
        }
        },
      ),
    );
  }
}
