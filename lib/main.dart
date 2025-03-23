import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/weather_provider.dart'; // Import the weather provider
import 'providers/user_provider.dart'; // Import the user provider //
import 'providers/settings_provider.dart'; // Import the settings provider
import 'providers/ai_provider.dart';

import 'screens/settings_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/ai_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/weather_forecast_screen.dart'; // Correct import for ProfileScreen

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),

        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AIProvider()),
      ],
      child: WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          settingsProvider.theme == "Light"
              ? ThemeData.light() // Light theme
              : ThemeData.dark(), // Dark theme
      initialRoute: '/',
      routes: {
        '/': (context) => WeatherHomePage(),
        '/settings': (context) => SettingsScreen(),
        '/notifications': (context) => NotificationsScreen(),
        '/menu': (context) => MenuScreen(),
        '/ai': (context) => AIScreen(),
        '/profile': (context) => ProfileScreen(), // Correct usage
      },
    );
  }
}

class WeatherHomePage extends StatelessWidget {
  const WeatherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(weatherProvider.location), // Dynamic location
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Navigator.pushNamed(context, '/menu');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Weather
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        weatherProvider.day, // Dynamic day
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wb_sunny, size: 50, color: Colors.orange),
                          SizedBox(width: 10),
                          Text(
                            weatherProvider.temperature, // Dynamic temperature
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${weatherProvider.chanceOfRain} Chance of Rain', // Dynamic data
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Weather Forecast Bar
              Text(
                '5-Day Forecast',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      weatherProvider.forecast.map((forecastItem) {
                        return _buildForecastItem(
                          context,
                          forecastItem['day']!,
                          _getIcon(forecastItem['icon']!),
                          forecastItem['temp']!,
                        );
                      }).toList(),
                ),
              ),
              SizedBox(height: 20),

              // Weather Details
              Text(
                'Weather Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children:
                        weatherProvider.details.entries.map((entry) {
                          return _buildWeatherDetailRow(
                            entry.key,
                            entry.value,
                            _getIcon(entry.key),
                          );
                        }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Sunrise & Sunset
              Text(
                'Sunrise & Sunset',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSunriseSunsetRow(
                        'Sunrise',
                        weatherProvider.sunrise,
                        Icons.wb_sunny,
                      ),
                      _buildSunriseSunsetRow(
                        'Sunset',
                        weatherProvider.sunset,
                        Icons.nightlight_round,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'AI'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/ai');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }

  // Helper function to build forecast items
  Widget _buildForecastItem(
    BuildContext context,
    String day,
    IconData icon,
    String temp,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => WeatherForecastScreen(
                  day: day,
                  temperature: temp,
                  weatherCondition: 'Sunny', // Replace with actual condition
                ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Icon(icon, size: 30),
            Text(
              temp,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build weather detail rows
  Widget _buildWeatherDetailRow(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: Text(value),
    );
  }

  // Helper function to build sunrise/sunset rows
  Widget _buildSunriseSunsetRow(String title, String time, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.orange),
        SizedBox(height: 10),
        Text(title, style: TextStyle(fontSize: 16)),
        Text(time, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Helper function to map weather conditions to icons
  IconData _getIcon(String condition) {
    switch (condition) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.wb_cloudy;
      case 'rain':
        return Icons.grain;
      default:
        return Icons.wb_sunny;
    }
  }
}
