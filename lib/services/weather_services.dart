import 'dart:convert';

import 'package:weather/models/aq_model.dart';
import 'package:weather/models/uv_rain_model.dart';
import 'package:weather/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:weather/models/weatherbundel_model.dart';

class WeatherServices {
  final String apiKey = '2926502898242b0d607c1ea41a43b21c';

  Future<WeatherModel> fetchWeather(String cityName) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherModel.fromjson(json.decode(response.body));
    } else {
      throw Exception("Unable to Load Weather");
    }
  }

  Future<ExtraWeather> extraWeather(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=metric&appid=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return ExtraWeather.fromJson(json.decode(response.body));
    } else {
      throw Exception("Unable to Load Weather");
    }
  }

  Future<AirQuality> fetchAirQuality(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return AirQuality.fromJson(json.decode(response.body));
    } else {
      throw Exception("Unable to Load Air Quality");
    }
  }

  Future<WeatherBundle> fetchAllData(String cityName) async {
    final weather = await fetchWeather(cityName);

    final results = await Future.wait([
      extraWeather(weather.lat, weather.lon),
      fetchAirQuality(weather.lat, weather.lon),
    ]);

    final extra = results[0] as ExtraWeather;
    final air = results[1] as AirQuality;

    return WeatherBundle(weather: weather, extra: extra, airQuality: air);
  }
}
