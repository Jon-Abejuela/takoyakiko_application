import 'dart:convert';
import 'dart:typed_data';
import 'package:client_app/API/api_connection.dart';
import 'package:client_app/theme/colors.dart';
import 'package:client_app/users/screens/add_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late List productList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    productList = [];
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    var response = await http.get(Uri.parse(API.fetchProduct));

    if (response.statusCode == 200) {
      setState(() {
        productList = json.decode(response.body);
        isLoading = false;
      });
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

  Future<void> _pickImage(Map<String, dynamic> product) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        List<int> imageBytes = await pickedFile.readAsBytes();

        String base64Image = base64Url.encode(imageBytes);

        setState(() {
          product['image'] = base64Image;
        });
      } catch (e) {
        print('Error encoding image data: $e');
      }
    }
  }

  Future<void> _updateProduct(Map<String, dynamic> product) async {
    var response = await http.post(
      Uri.parse(API.updateProduct),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(product),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Product Updated Successfully");
      print('Product updated successfully');
    } else {
      print('Error updating product');
    }
  }

  Future<void> _deleteProduct(String productId) async {
    var response = await http.delete(
      Uri.parse(API.deleteProduct + '?product_id=$productId'),
    );
    print('Deleting product with ID: $productId');

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Product Deleted Successfully");

      print('Product deleted successfully');
    } else {
      print('Error deleting product');
    }
  }

  void _showProductDetails(BuildContext context, Map<String, dynamic> product) {
    TextEditingController productNameController =
        TextEditingController(text: product['product_name']);
    TextEditingController stockQtyController =
        TextEditingController(text: product['stock_qty']);
    TextEditingController stockLimitController =
        TextEditingController(text: product['stock_limit']);
    TextEditingController categoryController =
        TextEditingController(text: product['category']);
    TextEditingController priceController =
        TextEditingController(text: product['price']);

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
                GestureDetector(
                  onTap: () async {
                    await _pickImage(product);
                    setState(() {});
                  },
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: showImage(product['image']),
                  ),
                ),
                TextField(
                  controller: productNameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: stockQtyController,
                  decoration:
                      const InputDecoration(labelText: 'Stock Quantity'),
                ),
                TextField(
                  controller: stockLimitController,
                  decoration: const InputDecoration(labelText: 'Stock Limit'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      product['product_name'] = productNameController.text;
                      product['stock_qty'] = stockQtyController.text;
                      product['stock_limit'] = stockLimitController.text;
                      product['category'] = categoryController.text;
                      product['price'] = priceController.text;
                    });

                    _updateProduct(product);

                    Navigator.pop(context);
                  },
                  child: const Text('Save Changes'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _deleteProduct(product['product_id']);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete Product'),
                ),
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
        title: const Text("Products"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProductScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
            ),
          )
        ],
      ),
      backgroundColor: color1,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    _showProductDetails(context, productList[index]);
                  },
                  child: Card(
                    color: color3,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(productList[index]['product_name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stock Quantity: ${productList[index]['stock_qty']}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Stock Limit: ${productList[index]['stock_limit']}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Category: ${productList[index]['category']}',
                            style: const TextStyle(fontSize: 9),
                          ),
                        ],
                      ),
                      leading: SizedBox(
                        width: 100,
                        height: 100,
                        child: showImage(productList[index]['image']),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
