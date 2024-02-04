import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:user_app/API/api_connection.dart';
import 'package:user_app/theme/colors.dart';
import 'package:user_app/widgets/drawer.dart';
import '../authentication/user_provider.dart';

class OrderProduct {
  final int orderId;
  final int productId;
  final String productName;
  final String productQuantity;
  final String total_price;
  final String? status;
  final String image; // Added image field

  OrderProduct({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.productQuantity,
    required this.total_price,
    required this.status,
    required this.image,
  });
}

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late List<OrderProduct> orderData = [];
  late int userId;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserProvider>(context, listen: false).userId ?? 0;
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.post(
        Uri.parse(API.fetchOrder),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          orderData = data.map((item) {
            return OrderProduct(
              orderId: item['orders_id'],
              productId: item['product_id'],
              productName: item['product_name'],
              productQuantity: item['quantity'].toString(),
              total_price: item['total_price'].toString(),
              status: item['status'],
              image: item['image'] ?? '', // Added image field
            );
          }).toList();
        });
      } else if (response.statusCode == 404) {
        print("No orders found for the user");
        setState(() {
          orderData = [];
        });
      } else {
        print("Error response body: ${response.body}");
        print("Error response status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception is $e");
    }
  }

  Widget showImage(String imageData) {
    try {
      Uint8List decodedBytes = base64.decode(imageData);
      return Image.memory(
        decodedBytes,
        width: 50,
        height: 100,
        fit: BoxFit.cover,
      );
    } catch (e) {
      print('Error decoding image data: $e');
      return const Icon(
        Icons.error,
        color: Colors.red, // You can customize the error icon color
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Orders',
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      backgroundColor: color1,
      body: orderData.isNotEmpty
          ? ListView.builder(
              itemCount: orderData.length,
              itemBuilder: (context, index) {
                OrderProduct orderProduct = orderData[index];
                return Card(
                  color: color3,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8),
                    leading: orderProduct.image.isNotEmpty
                        ? showImage(orderProduct.image)
                        : SizedBox.shrink(),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Semantics(
                            label: 'Product: ${orderProduct.productName}',
                            child: Text(orderProduct.productName),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Semantics(
                            label: 'Total Price: ${orderProduct.total_price}',
                            child: Text(
                              '₱ ${orderProduct.total_price}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text('Quantity: ${orderProduct.productQuantity}'),
                    trailing: getOrderStatusButton(orderProduct),
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget getOrderStatusButton(OrderProduct orderProduct) {
    String buttonText = 'Pending';
    bool isButtonEnabled = false;

    if (orderProduct.status == 'open') {
      buttonText = 'Pending';
    } else if (orderProduct.status == 'process') {
      buttonText = 'Preparing Order';
    } else if (orderProduct.status == 'finished') {
      buttonText = 'Order Arrived';
      isButtonEnabled = true;
    }

    return ElevatedButton(
      onPressed:
          isButtonEnabled ? () => handleButtonPressed(orderProduct) : null,
      style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 247, 193, 17)),
      child: Text(buttonText),
    );
  }

  void handleButtonPressed(OrderProduct orderProduct) {
    print('Order received for orderId: ${orderProduct.orderId}');
  }
}
