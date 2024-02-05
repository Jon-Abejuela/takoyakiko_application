// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:client_app/API/api_connection.dart';
import 'package:client_app/contents/dashboard_items.dart';
import 'package:client_app/theme/colors.dart';
import 'package:client_app/widgets/drawer.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(API.dashboardItems));

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);

        if (jsonResponse is List) {
          final List<Map<String, dynamic>> data =
              List<Map<String, dynamic>>.from(jsonResponse);

          setState(() {
            Contents.dashBoardItems = data;
          });

          print("Updating dashBoardItems with data: $data");
        } else if (jsonResponse is Map && jsonResponse.containsKey('error')) {
          print("Error: ${jsonResponse['error']}");
        } else {
          print("Unexpected response format: $jsonResponse");
        }
      } else {
        print("Error fetching: ${response.statusCode}");
      }
      print("Response Body: ${response.body}");
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: color1,
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                child: Icon(
                  Icons.admin_panel_settings_rounded,
                  size: 30,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Hello Admin",
                style: TextStyle(fontSize: 15),
              ),
              GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 20),
                primary: false,
                itemCount: Contents.dashBoardItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  Map<String, dynamic> dashDisplay =
                      Contents.dashBoardItems[index];
                  return Card(
                    child: Container(
                      color: color2.withOpacity(0),
                      child: InkWell(
                        onTap: () {
                          if (dashDisplay['subtitle'] == 'Users') {
                            Navigator.pushNamed(context, 'userScreen');
                          } else if (dashDisplay['subtitle'] == 'Orders') {
                            Navigator.pushNamed(context, 'orderScreen');
                          } else if (dashDisplay['subtitle'] ==
                              'Completed Orders') {
                            Navigator.pushNamed(context, 'completedScreen');
                          } else if (dashDisplay['subtitle'] == 'Earnings') {
                            Navigator.pushNamed(context, 'earningScreen');
                          } else if (dashDisplay['subtitle'] == 'Products') {
                            Navigator.pushNamed(context, 'productScreen');
                          } else if (dashDisplay['subtitle'] == 'Feedbacks') {
                            Navigator.pushNamed(context, 'feedbackScreen');
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dashDisplay["title"].toString(),
                              style: TextStyle(fontSize: 30),
                            ),
                            Text(
                              dashDisplay["subtitle"].toString(),
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
