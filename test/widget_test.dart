import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firstproject_new/screens/main.dart'; // Ensure this import is correct

void main() {
  testWidgets('WeatherApp renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(WeatherApp()); // Use WeatherApp instead of MyApp

    // Verify that the WeatherHomePage is rendered.
    expect(find.text('Weather App'), findsOneWidget); // AppBar title
    expect(find.byIcon(Icons.menu), findsOneWidget); // Menu icon
    expect(
      find.byIcon(Icons.notifications),
      findsOneWidget,
    ); // Notifications icon
    expect(find.byIcon(Icons.settings), findsOneWidget); // Settings icon
    expect(
      find.text('Welcome to the Weather App!'),
      findsOneWidget,
    ); // Homepage text
  });
}
