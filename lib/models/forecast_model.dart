class ForecastModel {
  final DateTime date; // Date of the forecast
  final double temperature; // Temperature in °C
  final String description; // Weather description
  final String icon; // Weather icon code

  ForecastModel({
    required this.date,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature:
          (json['main']['temp'] as num).toDouble(), // Ensure double conversion
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}
