import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import '../services/theme_service.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../models/search_model.dart';
import '../services/ai_weather_service.dart';
import '../models/ai_insights_model.dart';
import '../services/alert_service.dart';
import '../models/weather_alert.dart';
import '../components/alert_chip.dart';
import 'settings_screen.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();
  late final AIWeatherService _aiWeatherService;
  late final AlertService _alertService;
  final TextEditingController _searchController = TextEditingController();

  WeatherModel? _weather;
  List<ForecastModel> _forecast = [];
  List<CitySearchResult> _searchResults = [];
  AIInsights? _aiInsights;
  List<WeatherAlert> _alerts = [];
  bool _isLoading = false;
  bool _isSearching = false;
  bool _isLoadingAI = false;
  bool _hasNewAlerts = false;
  String? _error;
  String? _searchError;
  String? _aiError;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _aiWeatherService = AIWeatherService(_weatherService);
    _alertService = AlertService(_weatherService);
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      Position position = await _locationService.getCurrentLocation();
      await _fetchWeatherByLocation(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchWeatherByLocation(double lat, double lon) async {
    try {
      final weatherData = await _weatherService.getWeatherByLocation(lat, lon);
      final forecastData = await _weatherService.get5DayForecast(lat, lon);
      final alerts = await _alertService.checkForAlerts(lat, lon);

      setState(() {
        _weather = WeatherModel.fromJson(weatherData);
        _forecast =
            (forecastData['list'] as List)
                .map((item) => ForecastModel.fromJson(item))
                .toList();
        _alerts = alerts;
        _hasNewAlerts = alerts.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _fetchAIInsights() async {
    if (_weather == null) return;

    setState(() {
      _isLoadingAI = true;
      _aiError = null;
    });

    try {
      final themeService = Provider.of<ThemeService>(context, listen: false);
      final isFahrenheit = themeService.isFahrenheit;
      final insights = await _aiWeatherService.getInsights(
        _weather!.lat,
        _weather!.lon,
        isFahrenheit,
      );

      setState(() {
        _aiInsights = insights;
      });
    } catch (e) {
      setState(() {
        _aiError = e.toString();
      });
    } finally {
      setState(() {
        _isLoadingAI = false;
      });
    }
  }

  Future<void> _searchCities(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _searchError = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchError = null;
    });

    try {
      final results = await _weatherService.searchCities(query);
      setState(() {
        _searchResults =
            results.map((json) => CitySearchResult.fromJson(json)).toList();
      });
    } catch (e) {
      setState(() {
        _searchError = 'Search failed: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _selectCity(CitySearchResult city) {
    _searchController.clear();
    setState(() {
      _currentTabIndex = 0;
      _searchResults = [];
    });
    _fetchWeatherByLocation(city.lat, city.lon);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeService = Provider.of<ThemeService>(context);
    final isFahrenheit = themeService.isFahrenheit;

    return Scaffold(
      appBar: AppBar(
        title:
            _currentTabIndex == 2
                ? Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: theme.hintColor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search cities...',
                            hintStyle: TextStyle(color: theme.hintColor),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          style: theme.textTheme.bodyMedium,
                          onChanged: _searchCities,
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchResults = []);
                          },
                        ),
                    ],
                  ),
                )
                : Text(_weather?.cityName ?? 'Weather App'),
        actions: [
          if (_currentTabIndex != 2) ...[
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    setState(() {
                      _hasNewAlerts = false;
                    });
                    _showAlertsDialog(context);
                  },
                ),
                if (_hasNewAlerts)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                    ),
                  ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  ),
            ),
          ],
        ],
      ),
      body: _buildCurrentTab(theme, isFahrenheit),
      floatingActionButton:
          _currentTabIndex == 0
              ? FloatingActionButton(
                onPressed: _fetchWeather,
                child: const Icon(Icons.refresh),
              )
              : _currentTabIndex == 1
              ? FloatingActionButton(
                onPressed: _fetchAIInsights,
                child: const Icon(Icons.auto_awesome),
              )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
            if (index != 2) {
              _searchController.clear();
              _searchResults = [];
            }
            if (index == 1 && _weather != null && _aiInsights == null) {
              _fetchAIInsights();
            }
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'AI'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
    );
  }

  Widget _buildCurrentTab(ThemeData theme, bool isFahrenheit) {
    switch (_currentTabIndex) {
      case 0:
        return _buildWeatherTab(theme, isFahrenheit);
      case 1:
        return _buildAITab(theme);
      case 2:
        return _buildSearchTab(theme);
      default:
        return _buildWeatherTab(theme, isFahrenheit);
    }
  }

  Widget _buildWeatherTab(ThemeData theme, bool isFahrenheit) {
    if (_isLoading) {
      return Center(
        child: SpinKitFadingCircle(color: theme.primaryColor, size: 50.0),
      );
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error: $_error',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchWeather,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (_weather == null) {
      return const Center(child: Text('No weather data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentWeatherCard(theme, isFahrenheit),
          const SizedBox(height: 20),
          _buildForecastSection(theme, isFahrenheit),
          const SizedBox(height: 20),
          _buildWeatherDetails(theme, isFahrenheit),
        ],
      ),
    );
  }

  Widget _buildCurrentWeatherCard(ThemeData theme, bool isFahrenheit) {
    double temp =
        isFahrenheit
            ? (_weather!.temperature * 9 / 5) + 32
            : _weather!.temperature;
    String unit = isFahrenheit ? '°F' : '°C';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _weather!.cityName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_alerts.isNotEmpty) AlertChip(alert: _alerts.first),
              ],
            ),
            const SizedBox(height: 12),
            Image.network(
              'https://openweathermap.org/img/wn/${_weather!.icon}@4x.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 12),
            Text(
              '${temp.toStringAsFixed(1)}$unit',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(_weather!.description, style: theme.textTheme.titleMedium),
            if (_alerts.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildAlertsSection(theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weather Alerts',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 8),
        ..._alerts.map((alert) => _buildAlertItem(theme, alert)),
      ],
    );
  }

  Widget _buildAlertItem(ThemeData theme, WeatherAlert alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: alert.color.withAlpha(51), // 0.2 opacity equivalent
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: alert.color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(alert.icon, color: alert.color),
              const SizedBox(width: 8),
              Text(
                alert.title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: alert.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(alert.description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
            'Issued: ${alert.issuedAt.toString().substring(0, 16)}',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildForecastSection(ThemeData theme, bool isFahrenheit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '5-Day Forecast',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                _forecast
                    .map((day) => _buildForecastCard(theme, day, isFahrenheit))
                    .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildForecastCard(
    ThemeData theme,
    ForecastModel forecast,
    bool isFahrenheit,
  ) {
    double temp =
        isFahrenheit
            ? (forecast.temperature * 9 / 5) + 32
            : forecast.temperature;
    String unit = isFahrenheit ? '°F' : '°C';
    String weekday = _getWeekdayName(forecast.date.weekday);

    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                weekday,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Image.network(
                'https://openweathermap.org/img/wn/${forecast.icon}@2x.png',
                width: 48,
                height: 48,
              ),
              const SizedBox(height: 8),
              Text(
                '${temp.toStringAsFixed(0)}$unit',
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  Widget _buildWeatherDetails(ThemeData theme, bool isFahrenheit) {
    double windSpeed =
        isFahrenheit ? _weather!.windSpeed / 1.609 : _weather!.windSpeed;
    String windUnit = isFahrenheit ? 'mph' : 'km/h';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather Details',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              theme,
              Icons.air,
              'Wind',
              '${windSpeed.toStringAsFixed(1)} $windUnit',
            ),
            _buildDetailRow(
              theme,
              Icons.speed,
              'Pressure',
              '${_weather!.pressure} hPa',
            ),
            _buildDetailRow(
              theme,
              Icons.water_drop,
              'Humidity',
              '${_weather!.humidity}%',
            ),
            _buildDetailRow(
              theme,
              Icons.visibility,
              'Visibility',
              '${_weather!.visibility} km',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.primaryColor),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAITab(ThemeData theme) {
    if (_isLoadingAI) {
      return Center(
        child: SpinKitFadingCircle(color: theme.primaryColor, size: 50.0),
      );
    }
    if (_aiError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'AI Error: $_aiError',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchAIInsights,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (_aiInsights == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, size: 64, color: theme.primaryColor),
            const SizedBox(height: 16),
            Text(
              'AI Weather Insights',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the AI button to generate insights',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Summary',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _aiInsights!.currentSummary,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommended Clothing',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        _aiInsights!.clothingItems
                            .map(
                              (item) => Chip(
                                label: Text(item),
                                backgroundColor: theme.primaryColor.withAlpha(
                                  51,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggested Activities',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        _aiInsights!.activities
                            .map(
                              (activity) => Chip(
                                label: Text(activity),
                                backgroundColor: theme.primaryColor.withAlpha(
                                  51,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
          ),
          if (_aiInsights!.healthTips.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Health Tips',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_aiInsights!.healthTips),
                  ],
                ),
              ),
            ),
          ],
          if (_aiInsights!.energyAdvice.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Energy Advice',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_aiInsights!.energyAdvice),
                  ],
                ),
              ),
            ),
          ],
          if (_aiInsights!.travelWarning.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Travel Warning',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_aiInsights!.travelWarning),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchTab(ThemeData theme) {
    return Column(
      children: [
        if (_searchError != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[800]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _searchError!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.red[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (_isSearching)
          const Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(),
          ),
        if (!_isSearching &&
            _searchResults.isEmpty &&
            _searchController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_off, size: 64, color: theme.hintColor),
                const SizedBox(height: 16),
                Text('No cities found', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'Try a different search term',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
        if (!_isSearching &&
            _searchResults.isEmpty &&
            _searchController.text.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 64, color: theme.hintColor),
                const SizedBox(height: 16),
                Text('Search for cities', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'Start typing to find locations worldwide',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: _searchResults.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final city = _searchResults[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _selectCity(city),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withAlpha(51),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                city.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${city.country} • ${city.lat.toStringAsFixed(2)}, ${city.lon.toStringAsFixed(2)}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: theme.hintColor),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAlertsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Weather Alerts'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _alerts.length,
                itemBuilder: (context, index) {
                  final alert = _alerts[index];
                  return _buildAlertItem(Theme.of(context), alert);
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
