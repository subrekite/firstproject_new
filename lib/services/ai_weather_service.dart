import 'package:firstproject_new/models/ai_insights_model.dart';
import 'package:firstproject_new/services/weather_service.dart';

class AIWeatherService {
  final WeatherService weatherService;

  AIWeatherService(this.weatherService);

  Future<AIInsights> getInsights(
    double lat,
    double lon,
    bool isFahrenheit,
  ) async {
    try {
      final weatherData = await weatherService.getWeatherByLocation(lat, lon);

      final temp =
          isFahrenheit
              ? (weatherData['main']['temp'] * 9 / 5) + 32
              : weatherData['main']['temp'];

      return AIInsights.fromWeatherData(
        temp.toDouble(),
        weatherData['weather'][0]['description'],
        weatherData['wind']['speed'].toDouble(),
        weatherData['main']['humidity'].toDouble(),
        _isDaytime(
          weatherData['dt'],
          weatherData['sys']['sunrise'],
          weatherData['sys']['sunset'],
        ),
      );
    } catch (e) {
      throw Exception('Failed to generate insights: ${e.toString()}');
    }
  }

  bool _isDaytime(int currentTime, int sunrise, int sunset) {
    return currentTime > sunrise && currentTime < sunset;
  }
}
