import 'package:flutter/material.dart';
import 'package:meteo_minimaliste/services/weather_service.dart';
import '../models/weather.dart';
import '../models/forecast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  List<Forecast>? _forecast;
  final TextEditingController _controller = TextEditingController();
  String _error = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather('Paris');
  }

  void _fetchWeather(String city) async {
    if (city.isEmpty) {
      setState(() {
        _error = 'Veuillez entrer une ville';
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _error = '';
      _isLoading = true;
    });
    try {
      final weather = await _weatherService.getWeather(city);
      final forecast = await _weatherService.getForecast(city);
      setState(() {
        _weather = weather;
        _forecast = forecast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  BoxDecoration _getBackground() {
    // Pour l'instant, un fond par défaut (à personnaliser plus tard)
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue, Colors.lightBlue],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _getBackground(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Entrez une ville',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _fetchWeather(_controller.text),
                    ),
                  ),
                  onSubmitted: _fetchWeather,
                ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const CircularProgressIndicator(),
                if (_error.isNotEmpty && !_isLoading)
                  Text(
                    _error,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                if (_weather != null && !_isLoading) ...[
                  Text(
                    _weather!.cityName,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_weather!.temperature}°C',
                    style: const TextStyle(fontSize: 48),
                  ),
                  Text(
                    'Vitesse du vent : ${_weather!.windSpeed} km/h',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Heure : ${_weather!.time}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
                const SizedBox(height: 20),
                if (_forecast != null && !_isLoading) ...[
                  const Text(
                    'Prévisions sur 5 jours',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _forecast!.length,
                      itemBuilder: (context, index) {
                        final forecast = _forecast![index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  '${forecast.date.day}/${forecast.date.month}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text('${forecast.temperature}°C'),
                                Text('Humidité : ${forecast.humidity}%'),
                                Text('Vent : ${forecast.windSpeed} km/h'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}