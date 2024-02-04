import 'package:flutter/material.dart';

import 'package:user_app/theme/colors.dart';
import 'package:user_app/users/authentication/login.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: color4,
      child: ListView(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Menu'),
            onTap: () {
              Navigator.pushNamed(context, 'homeScreen');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            onTap: () {
              Navigator.pushNamed(context, 'cartScreen');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Orders'),
            onTap: () {
              Navigator.pushNamed(context, 'orderScreen');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, 'profileScreen');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Feedback'),
            onTap: () {
              Navigator.pushNamed(context, 'feedbackScreen');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
