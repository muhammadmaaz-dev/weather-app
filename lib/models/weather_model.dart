class WeatherModel {
  final String cityName;
  final int timezone;
  final double temprature;
  final int sunrise;
  final int sunset;
  final double lat;
  final double lon;
  final double speed;
  final String desc;
  final String mainCondition;

  WeatherModel({
    required this.cityName,
    required this.timezone,
    required this.temprature,
    required this.sunrise,
    required this.sunset,
    required this.lat,
    required this.lon,
    required this.speed,
    required this.desc,
    required this.mainCondition,
  });

  factory WeatherModel.fromjson(Map<String, dynamic> json) {
    if (json['cod'] != 200 && json['cod'] != 200.0 && json['cod'] != "200") {
      throw Exception('Weather data error: ${json['message']}');
    }

    final weatherList = json['weather'] as List?;
    final weatherItem = (weatherList != null && weatherList.isNotEmpty)
        ? weatherList[0]
        : {'main': 'Clear', 'description': 'No description'};

    return WeatherModel(
      cityName: json['name'] ?? 'Unknown City',
      timezone: json['timezone'] ?? 0,
      temprature: (json['main']?['temp'] as num?)?.toDouble() ?? 0.0,
      sunrise: (json['sys']?['sunrise'] as num?)?.toInt() ?? 0,
      sunset: (json['sys']?['sunset'] as num?)?.toInt() ?? 0,
      lat: (json['coord']?['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['coord']?['lon'] as num?)?.toDouble() ?? 0.0,
      speed: (json['wind']?['speed'] as num?)?.toDouble() ?? 0.0,
      desc: weatherItem['description'] ?? '',
      mainCondition: weatherItem['main'] ?? 'Clear',
    );
  }
}
