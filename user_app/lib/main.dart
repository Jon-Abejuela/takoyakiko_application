// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/users/authentication/login.dart';
import 'package:user_app/users/authentication/register.dart';
import 'package:user_app/users/authentication/user_provider.dart';
import 'package:user_app/users/screens/cart_screen.dart';
import 'package:user_app/users/screens/dashboard_screen.dart';
import 'package:user_app/users/screens/feedback_screen.dart';
import 'package:user_app/users/screens/order_screen.dart';
import 'package:user_app/users/screens/product_routes/burger_screen.dart';
import 'package:user_app/users/screens/product_routes/friednoodles_screen.dart';
import 'package:user_app/users/screens/product_routes/fries_screen.dart';
import 'package:user_app/users/screens/product_routes/hotdog_screen.dart';
import 'package:user_app/users/screens/product_routes/milktea_screen.dart';
import 'package:user_app/users/screens/product_routes/takoyaki_screen.dart';
import 'package:user_app/users/screens/profile_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: TakoyakikoApplicationUser(),
  ));
}

class TakoyakikoApplicationUser extends StatelessWidget {
  const TakoyakikoApplicationUser({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Takoyakiko',
      home: LoginPage(),
      routes: {
        'loginPage': (context) => LoginPage(),
        'registerPage': (context) => RegisterPage(),
        'homeScreen': (context) => HomeScreen(),
        'orderScreen': (context) => OrderScreen(),
        'profileScreen': (context) => ProfileScreen(),
        'feedbackScreen': (context) => FeedbackScreen(),
        'cartScreen': (context) => CartScreen(),
        'takoyakiScreen': (context) => TakoyakiScreen(),
        'burgerScreen': (context) => BurgerScreen(),
        'friesScreen': (context) => FriesScreen(),
        'milkteaScreen': (context) => MilkteaScreen(),
        'friedNoodleScreen': (context) => FriedNoodleScreen(),
        'hotdogScreen': (context) => HotdogScreen(),
      },
    );
  }
}
