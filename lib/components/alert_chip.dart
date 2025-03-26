import 'package:flutter/material.dart';
import '../models/weather_alert.dart';

class AlertChip extends StatelessWidget {
  final WeatherAlert alert;
  const AlertChip({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: alert.color.withAlpha(51), // 0.2 opacity equivalent
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: alert.color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(alert.icon, size: 16, color: alert.color),
          const SizedBox(width: 6),
          Text(
            alert.severityText,
            style: TextStyle(
              color: alert.color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
