import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isWeatherAlertsEnabled = true; // Default value for weather alerts
  bool _isDailyUpdatesEnabled = false; // Default value for daily updates

  void _updateNotificationPreferences() async {
    // Simulate API call to update notification preferences
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    if (!mounted) return; // Check if the widget is still mounted

    setState(() {
      _isLoading = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification preferences updated successfully!')),
    );
  }

  bool _isLoading = false; // Track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        automaticallyImplyLeading: true, // Back button
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(16),
            children: [
              // Weather Alerts Toggle
              ListTile(
                leading: Icon(Icons.notifications_active),
                title: Text('Weather Alerts'),
                subtitle: Text('Enable or disable weather alerts'),
                trailing: Switch(
                  value: _isWeatherAlertsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isWeatherAlertsEnabled = value;
                    });
                    _updateNotificationPreferences(); // Update preferences
                  },
                ),
              ),
              Divider(),

              // Daily Updates Toggle
              ListTile(
                leading: Icon(Icons.notifications_none),
                title: Text('Daily Updates'),
                subtitle: Text('Enable or disable daily updates'),
                trailing: Switch(
                  value: _isDailyUpdatesEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isDailyUpdatesEnabled = value;
                    });
                    _updateNotificationPreferences(); // Update preferences
                  },
                ),
              ),
            ],
          ),
          // Loading Indicator
          if (_isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
