import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:user_app/theme/colors.dart';
import 'package:user_app/widgets/drawer.dart';
import 'package:user_app/widgets/menu_bar.dart';
import 'package:user_app/widgets/search_bar.dart';

class HomeScreen extends StatelessWidget {
  final int? userId;
  const HomeScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu',
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: color1,
      drawer: const MyDrawer(),
      //SEARCH
      body: const Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MySearchBar(),
              MyMenuBar(),
            ],
          ),
        ),
      ),
    );
  }
}
