import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '82a940217f93f393b09f6622fc025d1f';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // [NEW METHOD] City search functionality
  Future<List<Map<String, dynamic>>> searchCities(String query) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/find?q=$query&type=like&sort=population&cnt=5&appid=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['list']);
    } else {
      throw Exception('City search failed. Status: ${response.statusCode}');
    }
  }

  // --- EXISTING METHODS (UNCHANGED) ---
  Future<Map<String, dynamic>> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/weather?q=$cityName&appid=$apiKey&units=metric'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> getWeatherByLocation(
    double lat,
    double lon,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
      ),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> get5DayForecast(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
      ),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  Future<Map<String, dynamic>> get5DayForecastByCity(String cityName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/forecast?q=$cityName&appid=$apiKey&units=metric'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}
