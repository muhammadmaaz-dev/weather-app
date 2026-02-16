class ExtraWeather {
  final double uvIndex;
  final double? rainProbability;

  ExtraWeather({required this.uvIndex, this.rainProbability});

  factory ExtraWeather.fromJson(Map<String, dynamic> json) {
    return ExtraWeather(
      uvIndex: json['current']['uvi'].toDouble(),
      rainProbability: json['hourly'][0]['pop'],
    );
  }
}
