import 'package:flutter/material.dart';

enum AlertSeverity { advisory, watch, warning }

class WeatherAlert {
  final String id;
  final String title;
  final String description;
  final AlertSeverity severity;
  final DateTime issuedAt;
  final DateTime? expiresAt;
  final String alertType;
  final Map<String, dynamic> metadata;

  WeatherAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.issuedAt,
    this.expiresAt,
    required this.alertType,
    this.metadata = const {},
  });

  Color get color {
    switch (severity) {
      case AlertSeverity.warning:
        return Colors.red;
      case AlertSeverity.watch:
        return Colors.orange;
      case AlertSeverity.advisory:
        return Colors.yellow;
    }
  }

  IconData get icon {
    switch (alertType) {
      case 'temperature':
        return Icons.thermostat;
      case 'wind':
        return Icons.air;
      case 'precipitation':
        return Icons.water_drop;
      case 'storm':
        return Icons.flash_on;
      default:
        return Icons.warning;
    }
  }

  String get severityText {
    switch (severity) {
      case AlertSeverity.warning:
        return 'WARNING';
      case AlertSeverity.watch:
        return 'WATCH';
      case AlertSeverity.advisory:
        return 'ADVISORY';
    }
  }
}
