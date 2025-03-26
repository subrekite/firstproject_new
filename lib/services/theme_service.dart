import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isFahrenheit = false; // New: Temperature Unit Toggle

  bool get isDarkMode => _isDarkMode;
  bool get isFahrenheit => _isFahrenheit;

  ThemeService() {
    _loadSettings();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveSettings();
    notifyListeners();
  }

  void toggleTemperatureUnit() {
    _isFahrenheit = !_isFahrenheit;
    _saveSettings();
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    _isFahrenheit = prefs.getBool('fahrenheit') ?? false;
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _isDarkMode);
    prefs.setBool('fahrenheit', _isFahrenheit);
  }
}
