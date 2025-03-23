import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  String theme = "Light"; // Default theme
  bool notificationsEnabled = true;
  String temperatureUnit = "Celsius"; // Default unit
  String location = "Unknown";

  void toggleNotifications() {
    notificationsEnabled = !notificationsEnabled;
    notifyListeners();
  }

  void setTheme(String newTheme) {
    theme = newTheme;
    notifyListeners();
  }

  void setTemperatureUnit(String unit) {
    temperatureUnit = unit;
    notifyListeners();
  }

  void setLocation(String newLocation) {
    location = newLocation;
    notifyListeners();
  }
}
