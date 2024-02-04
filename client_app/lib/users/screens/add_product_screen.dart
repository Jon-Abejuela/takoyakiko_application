// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:client_app/API/api_connection.dart';
import 'package:client_app/contents/dashboard_items.dart';
import 'package:client_app/theme/colors.dart';
import 'package:client_app/widgets/drawer.dart';
import 'package:client_app/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String? selectedCategory;
  String imageData = "";
  File imageFile = File('');
  final picker = ImagePicker();
  TextEditingController productName = TextEditingController();
  TextEditingController stock_qty = TextEditingController();
  TextEditingController stock_limit = TextEditingController();
  TextEditingController price = TextEditingController();

  Future choiceImage() async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
      imageData = base64Encode(imageFile.readAsBytesSync());
      return imageData;
    }
  }

  showImage(String imageData) {
    if (imageData.isNotEmpty) {
      try {
        return Image.memory(base64Decode(imageData));
      } catch (e) {
        print("Error decoding image: $e");
      }
    }

    return Container(
      width: 100,
      height: 100,
      color: color4,
      child: const Center(
        child: Text(
          'No Image Selected',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future addProduct() async {
    var data = {
      "product_name": productName.text,
      "category": selectedCategory.toString(),
      "stock_qty": stock_qty.text,
      "stock_limit": stock_limit.text,
      "price": price.text,
      "image": imageData,
    };
    print(data);

    var response = await http.post(
      Uri.parse(API.addProduct),
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print(response.body);
      Fluttertoast.showToast(msg: "Success");
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(msg: "Please Do not leave any fields blank");
    }
    setState(() {
      productName.clear();
      stock_limit.clear();
      stock_qty.clear();
      price.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: color1,
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ignore: unnecessary_null_comparison
              imageFile == null
                  ? const Text("No Image Selected")
                  : SizedBox(
                      child: showImage(imageData),
                      width: 300,
                      height: 200,
                    ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFields(
                        text: 'Product Name',
                        obscured: false,
                        control: productName,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        choiceImage();
                      },
                      icon: const Icon(Icons.image),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                        color: color2, borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Select a Category",
                        contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                      ),
                      items: Contents.categorySelection.map((map) {
                        return DropdownMenuItem(
                          value: map["category"].toString(),
                          child: Text(map['category'].toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                          print("selectedCategory: $selectedCategory");
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      SizedBox(
                        height: 60,
                        width: 170,
                        child: TextFields(
                          text: 'Stock Input',
                          obscured: false,
                          control: stock_qty,
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        width: 170,
                        child: TextFields(
                          text: 'Stock Limit',
                          obscured: false,
                          control: stock_limit,
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: 150,
                        decoration: BoxDecoration(
                            color: color2,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Text(
                                "₱",
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            constraints: BoxConstraints(
                                minHeight: 60,
                                maxHeight: 60,
                                minWidth: 150,
                                maxWidth: 150),
                          ),
                          controller: price,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: color3,
        focusColor: color1,
        onPressed: () {
          addProduct();
        },
        icon: const Icon(Icons.add),
        label: const Text("Add"),
      ),
    );
  }
}
