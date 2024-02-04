// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/API/api_connection.dart';
import 'package:user_app/theme/colors.dart';
import 'package:user_app/users/authentication/user_provider.dart';
import 'package:user_app/users/screens/dashboard_screen.dart';
import 'package:user_app/widgets/button.dart';
import 'package:user_app/widgets/textfields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var userController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> authentication() async {
    final String username = userController.text.trim();
    final String password = passwordController.text.trim();
    // ignore: unused_local_variable
    int? userId;

    final response = await http.post(
      Uri.parse(API.loginConn),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': username,
        'password': password,
      },
    );
    setState(() {
      userController.clear();
      passwordController.clear();
    });

    if (response.statusCode == 200) {
      print('SUCCESS');

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final int? userId = responseData["userId"];

      if (userId != null) {
        Provider.of<UserProvider>(context, listen: false).setUserId(userId);

        Fluttertoast.showToast(
          msg: "Login Successfully",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: color3,
          gravity: ToastGravity.SNACKBAR,
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        print('Invalid userId received from the server.');
      }
    } else {
      print('FAILED');
      Fluttertoast.showToast(
        msg: "Invalid Credentials",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: color3,
        gravity: ToastGravity.SNACKBAR,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: color1,
      body: ListView(
        children: [
          //logo
          SizedBox(
            height: 200,
            child: Image.asset('images/takoyakiko.png'),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text("Takoyakiko",
                style: GoogleFonts.dmSerifDisplay(fontSize: 30)),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    //username
                    TextFields(
                      text: 'Username',
                      obscured: false,
                      control: userController,
                    ),
                    //password
                    TextFields(
                      text: 'Password',
                      obscured: true,
                      control: passwordController,
                    ),
                    //login btn
                    MyElvtdBtn(
                      onPressed: () {
                        authentication();
                      },
                      text: "Login",
                    ),
                    SizedBox(
                      height: 150,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ",
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 15,
                            )),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'registerPage');
                          },
                          child: Text(
                            "  Register",
                            style: GoogleFonts.dmSerifDisplay(
                              color: Colors.yellow,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
