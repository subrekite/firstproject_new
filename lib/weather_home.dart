import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  String city = "New York";
  double temperature = 25.0;
  String weatherCondition = "Rainy";
  String currentTime = DateFormat('hh:mm a').format(DateTime.now());

  List<Map<String, dynamic>> forecast = [
    {"day": "Mon", "icon": "🌦", "temp": "19°C"},
    {"day": "Tue", "icon": "🌧", "temp": "18°C"},
    {"day": "Wed", "icon": "⛈", "temp": "16°C"},
    {"day": "Thu", "icon": "🌧", "temp": "17°C"},
    {"day": "Fri", "icon": "🌦", "temp": "20°C"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade900, Colors.blueGrey.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔹 Top Bar (Search, Menu, Settings)
                Row(
                  children: [
                    Icon(Icons.menu, color: Colors.white, size: 30),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Enter city",
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          onSubmitted: (value) {
                            setState(() {
                              city = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.settings, color: Colors.white, size: 30),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔹 City Name & Time
                Text(
                  city,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  currentTime,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),

                const SizedBox(height: 30),

                // 🔹 Rainy Icon Box (Fixed Overflow)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 230, // 🔹 Increased height to fix overflow
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "🌧",
                        style: const TextStyle(
                          fontSize: 60,
                        ), // 🔹 Reduced icon size slightly
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${temperature.toStringAsFixed(1)}°C",
                        style: const TextStyle(
                          fontSize: 32, // 🔹 Slightly reduced font size
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        weatherCondition,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // 🔹 Weather Forecast Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Weather Forecast",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // 🔹 Weather Forecast Bar (Moved Down)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:
                        forecast.map((day) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                day["day"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                day["icon"],
                                style: const TextStyle(fontSize: 24),
                              ),
                              SizedBox(height: 5),
                              Text(
                                day["temp"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),

                const Spacer(),

                // 🔹 Bottom Navigation Bar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.home, color: Colors.white, size: 32),
                      Icon(Icons.smart_toy, color: Colors.white, size: 32),
                      Icon(Icons.notifications, color: Colors.white, size: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
