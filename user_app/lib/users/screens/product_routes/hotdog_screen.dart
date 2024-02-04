import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:user_app/theme/colors.dart';
import 'package:user_app/widgets/drawer.dart';

class HotdogScreen extends StatelessWidget {
  const HotdogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Hotdog',
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      backgroundColor: color1,
    );
  }
}
