import 'dart:convert';

import 'package:weather/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherServices {
  final String apiKey = '2926502898242b0d607c1ea41a43b21c';

  Future<WeatherModel> fetchWeather(String cityName) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey',
    );

    final response = await http.get(url);

    if (response == 200) {
      return WeatherModel.fromjson(json.decode(response.body));
    } else {
      throw Exception("Unable to Load Weather");
    }
  }
}
