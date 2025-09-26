class Weather {
  final String time; // Heure de la donnée
  final double temperature; // Température à 2m
  final double windSpeed; // Vitesse du vent à 10m
  final String cityName; // Nom de la ville (à obtenir via une API de géocodage)

  Weather({
    required this.time,
    required this.temperature,
    required this.windSpeed,
    required this.cityName,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String cityName) {
    return Weather(
      time: json['current']['time'],
      temperature: json['current']['temperature_2m'].toDouble(),
      windSpeed: json['current']['wind_speed_10m'].toDouble(),
      cityName: cityName,
    );
  }
}