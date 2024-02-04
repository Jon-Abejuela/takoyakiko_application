// ignore_for_file: prefer_const_constructors

import 'package:client_app/users/authentication/login.dart';
import 'package:client_app/users/screens/completed_screen.dart';
import 'package:client_app/users/screens/dashboard_screen.dart';
import 'package:client_app/users/screens/earnings.dart';
import 'package:client_app/users/screens/feedback_screen.dart';
import 'package:client_app/users/screens/order_screen.dart';
import 'package:client_app/users/screens/product_screen.dart';
import 'package:client_app/users/screens/user_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const TakoyakikoApplication());
}

class TakoyakikoApplication extends StatelessWidget {
  const TakoyakikoApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Takoyakiko',
      home: const LoginPage(),
      routes: {
        'loginpage': (context) => LoginPage(),
        'dashboard': (context) => DashBoardScreen(),
        'userScreen': (context) => UserScreen(),
        'orderScreen': (context) => OrderScreen(),
        'completedScreen': (context) => CompletedScreen(),
        'earningScreen': (context) => EarningScreen(),
        'productScreen': (context) => ProductScreen(),
        'feedbackScreen': (context) => FeedbackScreen(),
      },
    );
  }
}
