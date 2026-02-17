class WeatherModel {
  final String cityName;
  final int timezone;
  final double temprature;
  final int sunrise;
  final int sunset;
  final double lat;
  final double lon;

  WeatherModel({
    required this.cityName,
    required this.timezone,
    required this.temprature,
    required this.sunrise,
    required this.sunset,
    required this.lat,
    required this.lon,
  });

  factory WeatherModel.fromjson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      timezone: json['timezone'],
      temprature: (json['main']['temp'] as num).toDouble(),
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      lat: (json['coord']['lat'] as num).toDouble(),
      lon: (json['coord']['lon'] as num).toDouble(),
    );
  }
}
