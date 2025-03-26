import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/weather_screen.dart';
import 'services/theme_service.dart'; // Import the theme service

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => ThemeService(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        brightness:
            themeService.isDarkMode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: WeatherScreen(),
    );
  }
}
