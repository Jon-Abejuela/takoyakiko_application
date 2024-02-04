import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_app/theme/colors.dart';

class MyElvtdBtn extends StatelessWidget {
  const MyElvtdBtn({super.key, required this.onPressed, required this.text});

  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      width: 200,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color3,
        ),
        child: Text(
          text,
          style: GoogleFonts.dmSerifDisplay(
              color: const Color.fromARGB(255, 49, 49, 49), fontSize: 18),
        ),
      ),
    );
  }
}
