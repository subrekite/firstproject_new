import '../models/weather_alert.dart';
import '../services/weather_service.dart';

class AlertService {
  final WeatherService _weatherService;

  AlertService(this._weatherService);

  Future<List<WeatherAlert>> checkForAlerts(double lat, double lon) async {
    try {
      final weather = await _weatherService.getWeatherByLocation(lat, lon);
      final alerts = <WeatherAlert>[];

      // Temperature alert
      if (weather['main']['temp'] > 35) {
        alerts.add(
          WeatherAlert(
            id: 'heat-${DateTime.now().millisecondsSinceEpoch}',
            title: 'Extreme Heat Warning',
            description: 'Temperatures reaching ${weather['main']['temp']}°C',
            severity: AlertSeverity.warning,
            issuedAt: DateTime.now(),
            alertType: 'temperature',
            metadata: {'temperature': weather['main']['temp']},
          ),
        );
      }

      // Wind alert
      if (weather['wind']['speed'] > 15) {
        alerts.add(
          WeatherAlert(
            id: 'wind-${DateTime.now().millisecondsSinceEpoch}',
            title: 'High Wind Alert',
            description: 'Winds at ${weather['wind']['speed']} km/h',
            severity: AlertSeverity.watch,
            issuedAt: DateTime.now(),
            alertType: 'wind',
            metadata: {'speed': weather['wind']['speed']},
          ),
        );
      }

      // Precipitation alert
      if (weather['weather'][0]['main'].toLowerCase().contains('rain')) {
        alerts.add(
          WeatherAlert(
            id: 'precip-${DateTime.now().millisecondsSinceEpoch}',
            title: 'Rain Advisory',
            description: weather['weather'][0]['description'],
            severity: AlertSeverity.advisory,
            issuedAt: DateTime.now(),
            alertType: 'precipitation',
          ),
        );
      }

      return alerts;
    } catch (e) {
      return []; // Return empty list on error
    }
  }
}
