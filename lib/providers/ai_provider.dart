import 'package:flutter/material.dart';

class AIProvider with ChangeNotifier {
  bool _isAIEnabled = false; // Whether AI features are enabled
  bool _isLoading = false; // Whether AI is processing
  final List<double> _weatherData = [
    20,
    22,
    25,
    23,
    21,
  ]; // Example weather data

  bool get isAIEnabled => _isAIEnabled;
  bool get isLoading => _isLoading;
  List<double> get weatherData => _weatherData;

  void toggleAI(bool value) {
    _isAIEnabled = value;
    notifyListeners(); // Notify listeners to update the UI
  }

  void fetchAIRecommendations() async {
    _isLoading = true;
    notifyListeners();

    // Simulate AI processing delay
    await Future.delayed(Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    // Show result (you can use a callback or another method to display the result)
  }
}
