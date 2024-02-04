import 'package:client_app/theme/colors.dart';
import 'package:client_app/users/authentication/login.dart';
import 'package:flutter/material.dart';

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
            child: const Text(
              "Hi Admin",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          ListTile(
            leading: const Icon(Icons.space_dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pushNamed(context, 'dashboard');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Orders'),
            onTap: () {
              Navigator.pushNamed(context, 'dashboard');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Payments'),
            onTap: () {
              Navigator.pushNamed(context, 'dashboard');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Feedbacks'),
            onTap: () {
              Navigator.pushNamed(context, 'dashboard');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => const LoginPage())));
            },
          ),
        ],
      ),
    );
  }
}
