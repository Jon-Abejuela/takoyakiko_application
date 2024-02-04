import 'package:client_app/theme/colors.dart';
import 'package:client_app/widgets/drawer.dart';
import 'package:flutter/material.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Completed Orders"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: color1,
      drawer: const MyDrawer(),
    );
  }
}
