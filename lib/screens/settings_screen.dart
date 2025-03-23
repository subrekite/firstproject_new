import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart'; // Import the settings provider

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        automaticallyImplyLeading: true, // Back button
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Theme Selection
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Theme'),
            subtitle: Text('Change app theme'),
            onTap: () {
              settingsProvider.setTheme(
                settingsProvider.theme == "Light" ? "Dark" : "Light",
              );
            },
          ),
          Divider(),

          // Notifications
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            subtitle: Text('Enable or disable notifications'),
            onTap: () {
              settingsProvider.toggleNotifications();
            },
          ),
          Divider(),

          // Temperature Units
          ListTile(
            leading: Icon(Icons.thermostat),
            title: Text('Temperature Units'),
            subtitle: Text('Switch between Celsius and Fahrenheit'),
            onTap: () {
              _showTemperatureUnitDialog(context, settingsProvider);
            },
          ),
          Divider(),

          // Location Settings
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Location'),
            subtitle: Text('Change location settings'),
            onTap: () {
              settingsProvider.setLocation('New Location');
            },
          ),
          Divider(),

          // About
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            subtitle: Text('Learn more about the app'),
            onTap: () {
              debugPrint('About clicked');
            },
          ),
        ],
      ),
    );
  }

  // Helper function to show temperature unit dialog
  void _showTemperatureUnitDialog(
    BuildContext context,
    SettingsProvider settingsProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Temperature Units'),
          content: Text('Choose your preferred temperature unit:'),
          actions: [
            TextButton(
              onPressed: () {
                settingsProvider.setTemperatureUnit('Celsius');
                Navigator.pop(context);
              },
              child: Text('Celsius'),
            ),
            TextButton(
              onPressed: () {
                settingsProvider.setTemperatureUnit('Fahrenheit');
                Navigator.pop(context);
              },
              child: Text('Fahrenheit'),
            ),
          ],
        );
      },
    );
  }
}
