class Forecast {
  final DateTime date;
  final double temperature;
  final double humidity;
  final double windSpeed;

  Forecast({
    required this.date,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.parse(json['time']),
      temperature: json['temperature_2m'].toDouble(),
      humidity: json['relative_humidity_2m'].toDouble(),
      windSpeed: json['wind_speed_10m'].toDouble(),
    );
  }
}