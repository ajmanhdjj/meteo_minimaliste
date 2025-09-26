import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../models/forecast.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1';
  static const String _geocodingUrl = 'https://geocoding-api.open-meteo.com/v1';

  Future<Map<String, dynamic>> _getCoordinates(String city) async {
    final response = await http.get(
      Uri.parse('$_geocodingUrl/search?name=$city&count=1'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        return {
          'latitude': data['results'][0]['latitude'],
          'longitude': data['results'][0]['longitude'],
          'cityName': data['results'][0]['name'],
        };
      } else {
        throw Exception('Ville non trouvée');
      }
    } else {
      throw Exception('Erreur lors de la recherche des coordonnées');
    }
  }

  Future<Weather> getWeather(String city) async {
    final coords = await _getCoordinates(city);
    final latitude = coords['latitude'];
    final longitude = coords['longitude'];
    final cityName = coords['cityName'];

    final response = await http.get(
      Uri.parse(
          '$_baseUrl/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,wind_speed_10m'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body), cityName);
    } else {
      throw Exception('Erreur API: ${response.statusCode}');
    }
  }

  Future<List<Forecast>> getForecast(String city) async {
    final coords = await _getCoordinates(city);
    final latitude = coords['latitude'];
    final longitude = coords['longitude'];

    final response = await http.get(
      Uri.parse(
          '$_baseUrl/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m&forecast_days=5'),
    );

    if (response.statusCode == 200) {
      final hourly = jsonDecode(response.body)['hourly'];
      final times = hourly['time'] as List<dynamic>;
      final temperatures = hourly['temperature_2m'] as List<dynamic>;
      final humidities = hourly['relative_humidity_2m'] as List<dynamic>;
      final windSpeeds = hourly['wind_speed_10m'] as List<dynamic>;

      // Créer une liste de prévisions en combinant les données
      final List<Forecast> forecasts = [];
      for (int i = 0; i < times.length; i += 24) { // Une prévision par jour (à 12h00)
        if (i < times.length) {
          forecasts.add(Forecast.fromJson({
            'time': times[i],
            'temperature_2m': temperatures[i],
            'relative_humidity_2m': humidities[i],
            'wind_speed_10m': windSpeeds[i],
          }));
        }
      }
      return forecasts;
    } else {
      throw Exception('Erreur API: ${response.statusCode}');
    }
  }
}