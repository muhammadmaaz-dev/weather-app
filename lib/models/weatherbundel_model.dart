import 'package:weather/models/aq_model.dart';
import 'package:weather/models/uv_rain_model.dart';
import 'package:weather/models/weather_model.dart';

class WeatherBundle {
  final WeatherModel weather;
  final ExtraWeather extra;
  final AirQuality airQuality;

  WeatherBundle({
    required this.weather,
    required this.extra,
    required this.airQuality,
  });
}
