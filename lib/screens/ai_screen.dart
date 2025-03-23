import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/ai_provider.dart'; // Import the AI provider

class AIScreen extends StatelessWidget {
  const AIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final aiProvider = Provider.of<AIProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('AI Features'),
        automaticallyImplyLeading: true, // Back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // AI Toggle
            SwitchListTile(
              title: Text('Enable AI Features'),
              value: aiProvider.isAIEnabled,
              onChanged: aiProvider.toggleAI,
            ),
            SizedBox(height: 20),
            // Weather Chart
            if (aiProvider.isAIEnabled)
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots:
                            aiProvider.weatherData
                                .asMap()
                                .entries
                                .map((e) => FlSpot(e.key.toDouble(), e.value))
                                .toList(),
                        isCurved: true,
                        color: Colors.blue,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20),
            // AI Recommendations
            if (aiProvider.isAIEnabled)
              aiProvider.isLoading
                  ? CircularProgressIndicator() // Show loading indicator
                  : ElevatedButton(
                    onPressed: aiProvider.fetchAIRecommendations,
                    child: Text('Get AI Recommendations'),
                  ),
          ],
        ),
      ),
    );
  }
}
