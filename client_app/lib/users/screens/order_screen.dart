import 'package:client_app/API/api_connection.dart';
import 'package:client_app/theme/colors.dart';
import 'package:client_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(API.fetchOrders));

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);

        if (jsonResponse is List) {
          setState(() {
            orders = List<Map<String, dynamic>>.from(jsonResponse);
          });
        } else if (jsonResponse is Map && jsonResponse.containsKey('error')) {
          print("Error: ${jsonResponse['error']}");
        } else {
          print("Unexpected response format: $jsonResponse");
        }
      } else {
        print("Error fetching: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> updateOrderStatus(int index, String newStatus) async {
    try {
      final response = await http.post(
        Uri.parse(API.updateOrderStatus),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({
          'orders_id': orders[index]['orders_id'].toString(),
          'new_status': newStatus
        }),
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final dynamic jsonResponse = jsonDecode(response.body);

          if (jsonResponse['success'] == true) {
            print(jsonResponse['message']);

            fetchData();
          } else {
            print(jsonResponse['message']);
          }
        } else {
          print("Empty response body");
        }
      } else {
        print("Error updating order status: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception updating order status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: color1,
      drawer: const MyDrawer(),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final productName = order['product_name'] ?? 'Unknown Product';
          final userFullname = order['user_fullname'] ?? 'Unknown User';
          final quantity = order['quantity'] ?? 'Unknown';
          final totalPrice = order['total_price'] ?? 0.0;

          return Card(
            color: color3,
            child: ListTile(
              title: Text(
                "$userFullname",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Order: $productName"),
                  Text("Quantity: $quantity"),
                  Text(
                    "₱ $totalPrice",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              trailing: getOrderStatusButton(order, index),
            ),
          );
        },
      ),
    );
  }

  Widget getOrderStatusButton(Map<String, dynamic>? order, int index) {
    if (order == null) {
      // Handle the case when order is null (optional)
      return const SizedBox(); // or another widget or null
    }

    String buttonText = '';
    bool isButtonEnabled = false;

    if (order['status'] == 'open') {
      buttonText = 'Approve';
      isButtonEnabled = true;
    } else if (order['status'] == 'process') {
      buttonText = 'Out for Delivery';
      isButtonEnabled = true;
    } else if (order['status'] == 'finished' ||
        order['status'] == 'completed') {
      buttonText = 'To be Received';
    } else {
      buttonText = 'Unknown Status';
    }

    return ElevatedButton(
      onPressed: isButtonEnabled
          ? () {
              // Handle button press based on the order status
              if (order['status'] == 'open') {
                // Make HTTP request to update order status to 'process'
                updateOrderStatus(index, 'process');
              } else if (order['status'] == 'process') {
                // Make HTTP request to update order status to 'finished'
                updateOrderStatus(index, 'finished');
              }
            }
          : null,
      style: ElevatedButton.styleFrom(
        primary: isButtonEnabled ? Colors.green : Colors.grey,
      ),
      child: Text(buttonText),
    );
  }
}
