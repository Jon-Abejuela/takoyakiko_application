import 'package:client_app/theme/colors.dart';
import 'package:client_app/widgets/drawer.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedbacks"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: color1,
      drawer: const MyDrawer(),
    );
  }
}
