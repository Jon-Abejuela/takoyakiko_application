import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/API/api_connection.dart';
import 'package:user_app/theme/colors.dart';
import 'package:user_app/widgets/button.dart';
import 'package:user_app/widgets/textfields.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var fullnameController = TextEditingController();
  var ageController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var addressController = TextEditingController();

  Future<void> register() async {
    final String fullname = fullnameController.text.trim();
    final String age = ageController.text.trim();
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();
    final String address = addressController.text.trim();

    final response = await http.post(
      Uri.parse(API.registerConn),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'fullname': fullname,
        'age': age,
        'username': username,
        'password': password,
        'address': address,
      },
    );
    setState(() {
      fullnameController.clear();
      ageController.clear();
      usernameController.clear();
      passwordController.clear();
      addressController.clear();
    });
    if (response.statusCode == 201) {
      Fluttertoast.showToast(
        msg: 'User Registered Successfully',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: color3,
        gravity: ToastGravity.SNACKBAR,
      );
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, 'loginPage');
    } else {
      Fluttertoast.showToast(
        msg: 'Registration Failed',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: color3,
        gravity: ToastGravity.SNACKBAR,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 120,
            child: Image.asset('images/takoyakiko.png'),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text("Takoyakiko",
                style: GoogleFonts.dmSerifDisplay(fontSize: 25)),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              TextFields(
                text: 'Fullname',
                obscured: false,
                control: fullnameController,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFields(
                      text: 'Username',
                      obscured: false,
                      control: usernameController,
                    ),
                  ),
                  Expanded(
                    child: TextFields(
                      text: 'Age',
                      obscured: false,
                      control: ageController,
                    ),
                  )
                ],
              ),
              TextFields(
                text: 'Address',
                obscured: false,
                control: addressController,
              ),
              TextFields(
                text: 'Password',
                obscured: true,
                control: passwordController,
              ),
              const TextFields(
                text: 'Confirm Password',
                obscured: true,
              ),
              MyElvtdBtn(
                onPressed: () {
                  register();
                },
                text: "Register",
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 15,
                      )),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'loginPage');
                    },
                    child: Text(
                      " Login",
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
        ],
      ),
    );
  }
}
