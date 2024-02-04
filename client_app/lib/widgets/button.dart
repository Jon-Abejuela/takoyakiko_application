import 'package:client_app/theme/colors.dart';
import 'package:flutter/material.dart';

class MyElvtdBtn extends StatelessWidget {
  const MyElvtdBtn({super.key, required this.onPressed, required this.text});

  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 150,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color3,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Color.fromARGB(255, 49, 49, 49)),
        ),
      ),
    );
  }
}
