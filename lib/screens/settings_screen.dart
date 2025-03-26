import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/theme_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSettingCard(
              icon: Icons.dark_mode,
              title: "Dark Mode",
              subtitle: "Enable or disable dark mode",
              trailing: Switch(
                value: themeService.isDarkMode,
                onChanged: (bool value) {
                  themeService.toggleTheme();
                },
              ),
            ),

            const SizedBox(height: 16),

            _buildSettingCard(
              icon: Icons.thermostat,
              title: "Temperature Unit",
              subtitle: "Switch between °C and °F",
              trailing: Switch(
                value: themeService.isFahrenheit,
                onChanged: (bool value) {
                  themeService.toggleTemperatureUnit();
                },
              ),
            ),

            const SizedBox(height: 16),

            _buildSettingCard(
              icon: Icons.info,
              title: "About App",
              subtitle: "Version $_appVersion",
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "Weather App",
                  applicationVersion: _appVersion,
                  applicationIcon: Icon(
                    Icons.cloud,
                    size: 50,
                    color: Colors.blue,
                  ),
                  children: const [
                    Text(
                      "This app provides real-time weather updates and forecasts.",
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.blue),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }
}
