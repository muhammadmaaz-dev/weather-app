class WeatherModel {
  final String cityName;
  final int time;
  final double temprature;
  final int sunrise;
  final int sunset;

  WeatherModel({
    required this.cityName,
    required this.time,
    required this.temprature,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherModel.fromjson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      time: json['timezone'],
      temprature: json['main']['temp'] - 273.15,
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }
}
