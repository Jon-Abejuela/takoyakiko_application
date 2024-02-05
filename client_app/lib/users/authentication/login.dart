import 'package:client_app/API/api_connection.dart';
import 'package:client_app/theme/colors.dart';
import 'package:client_app/users/screens/dashboard_screen.dart';
import 'package:client_app/widgets/button.dart';
import 'package:client_app/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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
      Fluttertoast.showToast(
        msg: "Login Succesfully",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: color3,
        gravity: ToastGravity.SNACKBAR,
      );
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const DashBoardScreen()));
    } else {
      print(response.body);
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
                        print(Text("${userController.text}"));
                        print(Text("${passwordController.text}"));
                      },
                      text: "Login",
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
