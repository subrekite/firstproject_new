import 'package:flutter/material.dart';

class WeatherProvider with ChangeNotifier {
  String location = "Thika";
  String day = "Friday";
  String temperature = "24° / 16°";
  String chanceOfRain = "71%";

  List<Map<String, String>> forecast = [
    {"day": "Mon", "icon": "cloudy", "temp": "22°C"},
    {"day": "Tue", "icon": "sunny", "temp": "26°C"},
    {"day": "Wed", "icon": "rain", "temp": "20°C"},
    {"day": "Thu", "icon": "cloudy", "temp": "23°C"},
    {"day": "Fri", "icon": "sunny", "temp": "27°C"},
  ];

  Map<String, String> details = {
    "UV Index": "Moderate",
    "Wind": "5 km/h",
    "Pressure": "1016.3 mb",
    "Humidity": "92%",
    "Dew Point": "18°",
    "Visibility": "8.05 km",
  };

  String sunrise = "06:35";
  String sunset = "18:41";
}
