import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/API/api_connection.dart';
import 'package:user_app/theme/colors.dart';
import 'package:user_app/users/authentication/user_provider.dart';
import 'package:user_app/widgets/drawer.dart';

class Product {
  final int cartId;
  final int productId;
  final String productName;
  final String productQuantity;
  final String image;
  final String price;
  bool isSelected;

  Product({
    required this.cartId,
    required this.productId,
    required this.productName,
    required this.productQuantity,
    required this.image, // Added image field
    required this.price,
    this.isSelected = false,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<Product>> cartDataFuture;
  late int userId;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserProvider>(context, listen: false).userId ?? 0;
    cartDataFuture = fetchData();
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
      return const Icon(
        Icons.error,
        color: Colors.red,
      );
    }
  }

  Future<List<Product>> fetchData() async {
    try {
      final response = await http.post(
        Uri.parse(API.fetchCart),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          return data.map((item) {
            return Product(
              cartId: item['cart_id'],
              productId: item['product_id'],
              productName: item['product_name'],
              productQuantity: item['quantity'].toString(),
              price: item['price'].toString(),
              image: item['image'] ?? '',
              isSelected: false,
            );
          }).toList();
        } else {
          return [];
        }
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to fetch cart data');
      }
    } catch (e) {
      print('Error fetching cart data: $e');
      return [];
    }
  }

  Future<void> deleteSelectedProducts(List<int> selectedCartIds) async {
    try {
      final response = await http.post(
        Uri.parse(API.deleteCart),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'cart_ids': selectedCartIds}),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Deleted successfully");
        setState(() {
          cartDataFuture = fetchData();
        });
      } else if (response.statusCode == 404) {
        // Handle 404 if needed
      } else {
        throw Exception('Failed to delete selected products');
      }
    } catch (e) {
      print('Error deleting selected products: $e');
      throw Exception('Error: $e');
    }
  }

  Future<void> addCheckOut(List<Product> selectedProducts) async {
    Fluttertoast.showToast(msg: "Add to pending order");
    try {
      List<int> cartIds =
          selectedProducts.map((product) => product.cartId).toList();

      List<Map<String, dynamic>> postDataList = [];

      for (Product selectedProduct in selectedProducts) {
        postDataList.add({
          'user_id': userId,
          'product_id': selectedProduct.productId,
          'quantity': selectedProduct.productQuantity,
          'totalPrice': selectedProduct.price,
        });
      }

      // Create a single request containing all the data
      final response = await http.post(
        Uri.parse(API.addCheckOut),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'cart_ids': cartIds,
          'products_data': postDataList,
        }),
      );

      if (response.statusCode == 200) {
        // Update the local state after successful data posting
        setState(() {
          cartDataFuture = fetchData();
        });
      } else {
        throw Exception('Failed to add product to pending order');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Product> fetchCartItemDetails(int cartId) async {
    final List<Product> cartData = await fetchData();
    final selectedCartItem = cartData.firstWhere(
      (product) => product.cartId == cartId,
      orElse: () => Product(
        cartId: 0,
        productName: '',
        productId: 0, // Use an appropriate default integer value
        productQuantity: '',
        price: '',
        image: '',
      ),
    );
    return selectedCartItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Cart',
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              cartDataFuture.then((cartData) {
                List<int> selectedCartIds = cartData
                    .where((product) => product.isSelected)
                    .map((product) => product.cartId)
                    .toList();
                deleteSelectedProducts(selectedCartIds);
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart_checkout),
            onPressed: () {
              cartDataFuture.then((cartData) async {
                List<Product> selectedProducts =
                    cartData.where((product) => product.isSelected).toList();

                if (selectedProducts.isNotEmpty) {
                  await addCheckOut(selectedProducts);

                  List<int> cartIds = selectedProducts
                      .map((product) => product.cartId)
                      .toList();
                  deleteSelectedProducts(cartIds);
                } else {
                  Fluttertoast.showToast(msg: "No items selected");
                }
              });
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      backgroundColor: color1,
      body: FutureBuilder<List<Product>>(
        future: cartDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.connectionState == ConnectionState.done &&
              (snapshot.data == null || snapshot.data!.isEmpty)) {
            return const Center(child: Text('No items in the cart'));
          } else {
            List<Product> cartData = snapshot.data!;
            return ListView.builder(
              shrinkWrap: false,
              itemCount: cartData.length,
              itemBuilder: (context, index) {
                Product product = cartData[index];
                return Card(
                  color: color3,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8),
                    leading: product.image.isNotEmpty
                        ? showImage(product.image)
                        : SizedBox.shrink(),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Semantics(
                            label: 'Product: ${product.productName}',
                            child: Text(product.productName),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Semantics(
                            label: 'Price: ${product.price}',
                            child: Text(
                              '₱ ${product.price}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text('Quantity: ${product.productQuantity}'),
                    trailing: Checkbox(
                      value: product.isSelected,
                      onChanged: (value) {
                        setState(() {
                          product.isSelected = value!;
                        });
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
