import 'package:flutter/material.dart';
import 'package:meteo_minimaliste/services/weather_service.dart';
import '../models/weather.dart';
import '../models/forecast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  List<Forecast>? _forecast;
  final TextEditingController _controller = TextEditingController();
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchWeather('Paris'); // Ville par défaut
  }

  void _fetchWeather(String city) async {
    setState(() {
      _error = '';
    });
    try {
      final weather = await _weatherService.getWeather(city);
      final forecast = await _weatherService.getForecast(city);
      setState(() {
        _weather = weather;
        _forecast = forecast;
      });
    } catch (e) {
      setState(() {
        _error = 'Ville non trouvée ou erreur API';
      });
    }
  }

  // Choisir un fond selon la météo
  BoxDecoration _getBackground() {
    if (_weather == null) {
      return const BoxDecoration(color: Colors.grey);
    }
    final icon = _weather!.icon;
    if (icon.contains('d')) {
      return const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.yellow],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    } else if (icon.contains('n')) {
      return const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo, Colors.grey],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    } else if (icon.contains('c')) {
      return const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    }
    return const BoxDecoration(color: Colors.grey);
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
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _fetchWeather(_controller.text),
                    ),
                  ),
                  onSubmitted: _fetchWeather,
                ),
                const SizedBox(height: 20),
                if (_error.isNotEmpty)
                  Text(
                    _error,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                if (_weather != null) ...[
                  Text(
                    _weather!.cityName,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Image.network(
                    'http://openweathermap.org/img/wn/${_weather!.icon}@2x.png',
                    width: 100,
                    height: 100,
                  ),
                  Text(
                    '${_weather!.temperature}°C',
                    style: const TextStyle(fontSize: 48),
                  ),
                  Text(
                    _weather!.description,
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Humidité : ${_weather!.humidity}%',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
                const SizedBox(height: 20),
                if (_forecast != null) ...[
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
                                Image.network(
                                  'http://openweathermap.org/img/wn/${forecast.icon}@2x.png',
                                  width: 50,
                                  height: 50,
                                ),
                                Text('${forecast.temperature}°C'),
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