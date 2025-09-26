import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  final String apiKey;

  WeatherService() : apiKey = dotenv.env['API_KEY'] ?? '';

  Future<Weather> getWeather(String city) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/weather?q=$city&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erreur lors de la récupération de la météo');
    }
  }

  Future<List<Forecast>> getForecast(String city) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/forecast?q=$city&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['list'];
      return data
          .where((item) => item['dt_txt'].contains('12:00:00')) // Prévisions à midi
          .map((item) => Forecast.fromJson(item))
          .toList();
    } else {
      throw Exception('Erreur lors de la récupération des prévisions');
    }
  }
}