import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _fetchWeather('Paris');
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
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
    if (_weather == null) {
      return const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A1428), Color(0xFF1A2639)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    }
    final temp = _weather!.temperature;
    if (temp > 20) {
      return const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF281B3D), Color(0xFF3A2F5F)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    } else if (temp < 10) {
      return const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A2639), Color(0xFF2D3B55)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    } else {
      return const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A1428), Color(0xFF1A2639)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    }
  }

  IconData _getWeatherIcon(double temperature) {
    if (temperature > 20) {
      return Icons.wb_sunny;
    } else if (temperature < 10) {
      return Icons.water_drop;
    } else {
      return Icons.cloud;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _getBackground(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Champ de recherche avec effet glassmorphism et bordure dynamique
                Focus(
                  focusNode: _focusNode,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _focusNode.hasFocus
                            ? const Color.fromRGBO(64, 196, 255, 0.6)
                            : const Color.fromRGBO(255, 255, 255, 0.3),
                        width: _focusNode.hasFocus ? 2.5 : 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: 'Entrez une ville',
                            hintStyle: GoogleFonts.poppins(
                              color: const Color.fromRGBO(255, 255, 255, 0.5),
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: _focusNode.hasFocus
                                    ? Colors.blueAccent
                                    : const Color.fromRGBO(255, 255, 255, 0.7),
                              ),
                              onPressed: () => _fetchWeather(_controller.text),
                            ),
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          onSubmitted: _fetchWeather,
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 800.ms, curve: Curves.easeInOut).slideY(begin: -0.3),
                const SizedBox(height: 40),
                // Indicateur de chargement
                if (_isLoading)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ).animate().fadeIn(duration: 400.ms, curve: Curves.easeInOut),
                // Message d'erreur
                if (_error.isNotEmpty && !_isLoading)
                  Text(
                    _error,
                    style: GoogleFonts.poppins(
                      color: Colors.redAccent.shade100,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 400.ms, curve: Curves.easeInOut),
                // Météo actuelle
                if (_weather != null && !_isLoading) ...[
                  Text(
                    _weather!.cityName,
                    style: GoogleFonts.poppins(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.4),
                          blurRadius: 8,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 800.ms, curve: Curves.easeInOut).slideY(begin: 0.3),
                  const SizedBox(height: 20),
                  Icon(
                    _getWeatherIcon(_weather!.temperature),
                    size: 100,
                    color: const Color.fromRGBO(255, 255, 255, 0.9),
                  ).animate().scale(duration: 800.ms, curve: Curves.easeInOut),
                  const SizedBox(height: 20),
                  Text(
                    '${_weather!.temperature.toStringAsFixed(1)}°C',
                    style: GoogleFonts.poppins(
                      fontSize: 72,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(duration: 800.ms, curve: Curves.easeInOut).slideY(begin: 0.3),
                  const SizedBox(height: 12),
                  Text(
                    'Vent : ${_weather!.windSpeed.toStringAsFixed(1)} km/h',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: const Color.fromRGBO(255, 255, 255, 0.7),
                      fontWeight: FontWeight.w400,
                    ),
                  ).animate().fadeIn(duration: 800.ms, curve: Curves.easeInOut).slideY(begin: 0.3),
                  Text(
                    'Heure : ${_weather!.time}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: const Color.fromRGBO(255, 255, 255, 0.7),
                      fontWeight: FontWeight.w400,
                    ),
                  ).animate().fadeIn(duration: 800.ms, curve: Curves.easeInOut).slideY(begin: 0.3),
                ],
                const SizedBox(height: 48),
                // Prévisions sur 5 jours
                if (_forecast != null && !_isLoading) ...[
                  Text(
                    'Prévisions sur 5 jours',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(duration: 800.ms, curve: Curves.easeInOut).slideY(begin: 0.3),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _forecast!.length,
                      itemBuilder: (context, index) {
                        final forecast = _forecast![index];
                        return GestureDetector(
                          onTap: () {
                            // Animation de surbrillance au tap
                            setState(() {});
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 160,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Card(
                              elevation: 0,
                              color: const Color.fromRGBO(255, 255, 255, 0.15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: const Color.fromRGBO(255, 255, 255, 0.3)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${forecast.date.day}/${forecast.date.month}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Icon(
                                          _getWeatherIcon(forecast.temperature),
                                          size: 50,
                                          color: const Color.fromRGBO(255, 255, 255, 0.8),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          '${forecast.temperature.toStringAsFixed(1)}°C',
                                          style: GoogleFonts.poppins(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Humidité : ${forecast.humidity.toStringAsFixed(0)}%',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: const Color.fromRGBO(255, 255, 255, 0.7),
                                          ),
                                        ),
                                        Text(
                                          'Vent : ${forecast.windSpeed.toStringAsFixed(1)} km/h',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: const Color.fromRGBO(255, 255, 255, 0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ).animate().fadeIn(duration: 800.ms, delay: (150 * index).ms, curve: Curves.easeInOut).slideX(begin: 0.3);
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