import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        automaticallyImplyLeading: true, // Back button
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Home
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Navigate to Home Screen
              Navigator.pop(context); // Close the menu
            },
          ),
          Divider(),

          // Settings
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Navigate to Settings Screen
              Navigator.pushNamed(context, '/settings');
            },
          ),
          Divider(),

          // Notifications
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              // Navigate to Notifications Screen
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          Divider(),

          // Help & Support
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & Support'),
            onTap: () {
              // Navigate to Help & Support Screen
              Navigator.pushNamed(context, '/help_support');
            },
          ),
        ],
      ),
    );
  }
}
