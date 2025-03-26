class AIInsights {
  final String currentSummary;
  final List<String> clothingItems;
  final List<String> activities;
  final String healthTips;
  final String energyAdvice;
  final String travelWarning;

  AIInsights({
    required this.currentSummary,
    required this.clothingItems,
    required this.activities,
    required this.healthTips,
    required this.energyAdvice,
    required this.travelWarning,
  });

  factory AIInsights.fromWeatherData(
    double temp,
    String condition,
    double windSpeed,
    double humidity,
    bool isDaytime,
  ) {
    String summary = '';
    List<String> clothing = [];
    List<String> activities = [];
    String health = '';
    String energy = '';
    String travel = '';

    // Temperature-based logic
    if (temp > 30) {
      summary = "Hot weather at ${temp.toStringAsFixed(0)}°C";
      clothing.addAll(['Light shirt', 'Shorts', 'Sunglasses']);
      activities.addAll(['Swimming', 'Indoor activities']);
      health = "Stay hydrated and avoid prolonged sun exposure.";
      energy = "Peak solar energy generation hours today.";
    } else if (temp > 20) {
      summary = "Pleasant ${temp.toStringAsFixed(0)}°C weather";
      clothing.addAll(['T-shirt', 'Light pants']);
      activities.addAll(['Hiking', 'Outdoor sports']);
    }

    // Condition-based adjustments
    if (condition.contains('rain')) {
      summary += " with rain expected";
      clothing.add('Umbrella');
      travel = "Allow extra travel time due to wet conditions.";
    }

    return AIInsights(
      currentSummary: summary,
      clothingItems: clothing,
      activities: activities,
      healthTips: health,
      energyAdvice: energy,
      travelWarning: travel,
    );
  }
}
