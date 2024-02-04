import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:user_app/API/api_connection.dart';
import 'package:user_app/contents/carousel_images.dart';
import 'package:user_app/theme/colors.dart';
import 'package:user_app/users/authentication/user_provider.dart';
import 'package:user_app/widgets/drawer.dart';

class BurgerScreen extends StatefulWidget {
  const BurgerScreen({Key? key}) : super(key: key);

  @override
  State<BurgerScreen> createState() => _BurgerScreenState();
}

class _BurgerScreenState extends State<BurgerScreen> {
  late List<Map<String, dynamic>> burgerProducts;
  bool isLoading = true;
  late int userId;

  late Map<String, dynamic> selectedQuantity;
  late TextEditingController quantityController;
  late TextEditingController priceController;
  late int productId;

  Future<void> fetchBurgerProducts() async {
    var response = await http.get(Uri.parse(API.fetchBurgerProduct));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> productsData =
          List<Map<String, dynamic>>.from(json.decode(response.body));

      setState(() {
        burgerProducts = productsData;
        isLoading = false;
      });
    } else {
      print(
          "Failed to fetch Burger products. Status code: ${response.statusCode}");
    }
  }

  Widget showImage(String imageData) {
    try {
      Uint8List decodedBytes = base64.decode(imageData);
      return Image.memory(
        decodedBytes,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } catch (e) {
      print('Error decoding image data: $e');
      return const CircularProgressIndicator();
    }
  }

  @override
  void initState() {
    super.initState();
    burgerProducts = [];
    selectedQuantity = {};
    quantityController = TextEditingController();
    priceController = TextEditingController();
    fetchBurgerProducts();
    userId = Provider.of<UserProvider>(context, listen: false).userId ?? 0;
  }

  Widget buildImage(String burgerSlider, int index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        color: color2,
        child: Image.asset(
          burgerSlider,
          fit: BoxFit.cover,
        ),
      );

  void updatePrice() {
    int selectedQty = int.tryParse(quantityController.text) ?? 0;
    double totalPrice =
        selectedQty * double.parse(selectedQuantity["price"].toString());
    priceController.text = totalPrice.toString();
  }

  void addToCart(Map<String, dynamic> data, int userId) async {
    try {
      data['user_id'] = userId.toString();
      data['product_id'] = data['product_id'].toString();
      data['quantity'] = data['quantity'].toString();
      data['totalPrice'] = data['totalPrice'].toString();

      print('Data to be sent: $data');
      var response =
          await http.post(Uri.parse(API.addToCart), body: jsonEncode(data));
      print('Response from server: ${response.body}');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Added to cart successfully");
        print('Data successfully sent to the server');
      } else {
        print(
            'Failed to send data to the server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  void _showProductDetails(BuildContext context, Map<String, dynamic> product) {
    productId = int.tryParse(product['product_id'].toString()) ?? 0;
    selectedQuantity = product;
    priceController.text = selectedQuantity["price"].toString();
    quantityController.text = "1"; // Set default quantity to 1

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: color2,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: GestureDetector(
                    child: showImage(selectedQuantity['image']),
                  ),
                ),
                Text(
                  selectedQuantity["product_name"],
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 10),
                SizedBox(
                  width: 136,
                  child: TextField(
                    decoration:
                        const InputDecoration(labelText: "Enter quantity: "),
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      updatePrice();
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        String productName = selectedQuantity["product_name"];
                        int selectedQty =
                            int.tryParse(quantityController.text) ?? 0;

                        double totalPrice = selectedQty *
                            double.parse(selectedQuantity["price"]);

                        Map<String, dynamic> selectedValues = {
                          'product_id': productId,
                          'user_id': userId,
                          'productName': productName,
                          'quantity': selectedQty,
                          'totalPrice': totalPrice,
                          'statusOrder': 'pending',
                        };

                        addToCart(selectedValues, userId);

                        Navigator.pop(context);
                      },
                      child: const Text("Add"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Burgers',
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      backgroundColor: color1,
      body: Column(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
            ),
            itemCount: BurgerSlider.burgerImageSlider.length,
            itemBuilder: (context, index, realIndex) {
              final burgerSlider = BurgerSlider.burgerImageSlider[index];
              return buildImage(burgerSlider, index);
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: burgerProducts.length,
                    itemBuilder: (context, index) {
                      final product = burgerProducts[index];
                      return InkWell(
                        onTap: () {
                          _showProductDetails(context, burgerProducts[index]);
                        },
                        child: Card(
                          color: color3,
                          child: ListTile(
                            title: Text(product['product_name'] ?? ''),
                            subtitle: Text('Price: ${product['price'] ?? ''}'),
                            leading: SizedBox(
                              width: 100,
                              height: 100,
                              child: showImage(product['image']),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
