class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final double windSpeed;
  final double pressure;
  final int humidity;
  final double visibility;
  final double lat; // Add this
  final double lon; // Add this

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.pressure,
    required this.humidity,
    required this.visibility,
    required this.lat, // Add this
    required this.lon, // Add this
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pressure: (json['main']['pressure'] as num).toDouble(),
      humidity: json['main']['humidity'],
      visibility: (json['visibility'] as num).toDouble() / 1000,
      lat: (json['coord']['lat'] as num).toDouble(), // Add this
      lon: (json['coord']['lon'] as num).toDouble(), // Add this
    );
  }
}
