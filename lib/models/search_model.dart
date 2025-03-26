// models/search_model.dart
class CitySearchResult {
  final String name;
  final String country;
  final double lat;
  final double lon;

  CitySearchResult({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
  });

  factory CitySearchResult.fromJson(Map<String, dynamic> json) {
    return CitySearchResult(
      name: json['name'],
      country: json['sys']['country'] ?? json['country'] ?? '',
      lat: json['coord']['lat']?.toDouble() ?? json['lat']?.toDouble() ?? 0.0,
      lon: json['coord']['lon']?.toDouble() ?? json['lon']?.toDouble() ?? 0.0,
    );
  }
}
