import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:user_app/API/api_connection.dart';

class MyTakoyakiFlavorSlider extends StatefulWidget {
  final Function(int)? onTapTile;
  final int selectedIndex;

  const MyTakoyakiFlavorSlider({
    Key? key,
    this.onTapTile,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<MyTakoyakiFlavorSlider> createState() => _MyTakoyakiFlavorSliderState();
}

class _MyTakoyakiFlavorSliderState extends State<MyTakoyakiFlavorSlider> {
  late List<Map<String, dynamic>> productList;

  @override
  void initState() {
    super.initState();
    productList = [];
    fetchTakoyakiProducts();
  }

  Future<List<Map<String, dynamic>>> fetchTakoyakiProducts() async {
    try {
      final response = await http.get(Uri.parse(API.fetchTakoyakiProduct));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> productList =
            List<Map<String, dynamic>>.from(data);

        // Ensure "image" field is not null in each product
        productList.forEach((product) {
          if (product["image"] == null) {
            product["image"] = ""; // or any other default value
          }
        });

        return productList;
      } else {
        throw Exception('Failed to load Takoyaki products');
      }
    } catch (e) {
      print('Error fetching Takoyaki products: $e');
      throw Exception('Failed to load Takoyaki products');
    }
  }

  Widget showImageFromBytes(dynamic imageData) {
    try {
      if (imageData != null) {
        Uint8List decodedBytes;
        if (imageData is String) {
          decodedBytes = base64.decode(imageData);
        } else {
          // Handle the case when imageData is not a String (e.g., if it's already Uint8List)
          decodedBytes = imageData;
        }
        return Image.memory(
          decodedBytes,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        );
      } else {
        // Handle the case when imageData is null
        return const SizedBox.shrink(); // or any other fallback widget
      }
    } catch (e) {
      print('Error decoding image data: $e');
      return const CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: productList.isEmpty
          ? const CircularProgressIndicator()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> takoyakiProduct = productList[index];
                return InkWell(
                  onTap: () {
                    widget.onTapTile?.call(index);
                  },
                  child: Container(
                    width: 150,
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: index == widget.selectedIndex
                                ? Border.all(color: Colors.red, width: 2.0)
                                : null,
                          ),
                          child: showImageFromBytes(takoyakiProduct["image"]),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          takoyakiProduct["product"],
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
