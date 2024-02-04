import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import 'package:user_app/API/api_connection.dart';
import 'package:user_app/contents/carousel_images.dart';
import 'package:user_app/theme/colors.dart';
import 'package:user_app/users/authentication/user_provider.dart';
import 'package:user_app/widgets/drawer.dart';

class TakoyakiScreen extends StatefulWidget {
  const TakoyakiScreen({Key? key}) : super(key: key);

  @override
  _TakoyakiScreenState createState() => _TakoyakiScreenState();
}

class _TakoyakiScreenState extends State<TakoyakiScreen> {
  late List<Map<String, dynamic>> takoyakiProducts;
  bool isLoading = true;
  late int userId;

  Future<void> fetchTakoyakiProducts() async {
    var response = await http.get(Uri.parse(API.fetchTakoyakiProduct));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> productsData =
          List<Map<String, dynamic>>.from(json.decode(response.body));

      setState(() {
        takoyakiProducts = productsData;
        isLoading = false;
      });
    } else {
      print(
          "Failed to fetch Takoyaki products. Status code: ${response.statusCode}");
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
    takoyakiProducts = [];
    fetchTakoyakiProducts();
    userId = Provider.of<UserProvider>(context, listen: false).userId ?? 0;
  }

  Widget buildImage(String takoyakiSlider, int index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        color: color2,
        child: Image.asset(
          takoyakiSlider,
          fit: BoxFit.cover,
        ),
      );

  void addToCart(Map<String, dynamic> data, int userId) async {
    try {
      // Convert numeric values to strings
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
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());

    int price = int.tryParse(product['price'] ?? '') ?? 0;
    int productId = int.tryParse(product['product_id'].toString()) ?? 0;

    var takoyakiQuantity = [
      {"qty": 4, "compu": 1},
      {"qty": 8, "compu": 2},
      {"qty": 12, "compu": 3},
      {"qty": 16, "compu": 4},
    ];

    Map<String, dynamic> selectedQuantity = takoyakiQuantity.first;

    priceController.text = (price *
            (selectedQuantity["compu"] is int
                ? selectedQuantity["compu"]
                : int.tryParse(selectedQuantity["compu"].toString()) ?? 0))
        .toString();

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
                    child: showImage(product['image']),
                  ),
                ),
                Text(
                  product["product_name"],
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Select Quantity",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 136,
                  child: DropdownButtonFormField(
                    value: selectedQuantity,
                    decoration: const InputDecoration(
                      hintText: "Select Quantity",
                      contentPadding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                    ),
                    items: takoyakiQuantity.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option["qty"].toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedQuantity = value as Map<String, dynamic>;
                        priceController.text = (price *
                                (selectedQuantity["compu"] is int
                                    ? selectedQuantity["compu"]
                                    : int.tryParse(selectedQuantity["compu"]
                                            .toString()) ??
                                        0))
                            .toString();
                      });
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
                        String productName = product["product_name"];
                        String selectedQty = selectedQuantity["qty"].toString();
                        double totalPrice = double.parse(priceController.text);

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
        title: Text('Takoyaki'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: MyDrawer(),
      backgroundColor: color1,
      body: Column(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
            ),
            itemCount: TakoyakiSlider.takoyakiImageSlider.length,
            itemBuilder: (context, index, realIndex) {
              final takoyakiSlider = TakoyakiSlider.takoyakiImageSlider[index];
              return buildImage(takoyakiSlider, index);
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: takoyakiProducts.length,
                    itemBuilder: (context, index) {
                      final product = takoyakiProducts[index];
                      return InkWell(
                        onTap: () {
                          _showProductDetails(context, takoyakiProducts[index]);
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
