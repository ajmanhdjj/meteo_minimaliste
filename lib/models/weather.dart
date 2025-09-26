class Weather {
  final String cityName;
  final double temperature;
  final int humidity;
  final String icon;
  final String description;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.humidity,
    required this.icon,
    required this.description,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'],
      icon: json['weather'][0]['icon'],
      description: json['weather'][0]['description'],
    );
  }
}

class Forecast {
  final DateTime date;
  final double temperature;
  final String icon;

  Forecast({
    required this.date,
    required this.temperature,
    required this.icon,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['main']['temp'].toDouble(),
      icon: json['weather'][0]['icon'],
    );
  }
}