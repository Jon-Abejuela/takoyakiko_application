import 'package:flutter/material.dart';
import 'package:user_app/theme/colors.dart';

class TextFields extends StatelessWidget {
  final dynamic control;
  final String text;
  final bool obscured;

  const TextFields(
      {super.key, this.control, required this.text, required this.obscured});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: TextField(
        obscureText: obscured,
        style: const TextStyle(color: Color.fromARGB(255, 68, 68, 68)),
        decoration: InputDecoration(
          fillColor: color2,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: Color.fromARGB(173, 134, 134, 134)),
          hintText: text,
        ),
        controller: control,
      ),
    );
  }
}
