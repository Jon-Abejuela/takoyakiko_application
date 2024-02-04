import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_app/contents/menu_items.dart';
import 'package:user_app/theme/colors.dart';

class MyMenuBar extends StatelessWidget {
  const MyMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20),
      primary: false,
      itemCount: Contents.menuItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemBuilder: (context, index) {
        Map<String, dynamic> menuDisplay = Contents.menuItems[index];
        return Card(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color2,
              image: DecorationImage(
                image: AssetImage(menuDisplay['image']),
                fit: BoxFit.cover,
              ),
            ),
            child: InkWell(
              onTap: () {
                if (menuDisplay['product'] == 'Takoyaki') {
                  Navigator.pushNamed(context, 'takoyakiScreen');
                } else if (menuDisplay['product'] == 'Burgers') {
                  Navigator.pushNamed(context, 'burgerScreen');
                } else if (menuDisplay['product'] == 'Fries') {
                  Navigator.pushNamed(context, 'friesScreen');
                } else if (menuDisplay['product'] == 'Milktea') {
                  Navigator.pushNamed(context, 'milkteaScreen');
                } else if (menuDisplay['product'] == 'Fried Noodles') {
                  Navigator.pushNamed(context, 'friedNoodleScreen');
                } else if (menuDisplay['product'] == 'Hotdog') {
                  Navigator.pushNamed(context, 'hotdogScreen');
                }
              },
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    color: Colors.transparent,
                    child: Text(
                      menuDisplay["product"],
                      style: GoogleFonts.dmSerifDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            const Shadow(
                                blurRadius: 10.0,
                                color: Colors.black,
                                offset: Offset(1.0, 1.0))
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
