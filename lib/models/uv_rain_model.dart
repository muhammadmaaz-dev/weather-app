class ExtraWeather {
  final double uvIndex;
  final double? rainProbability;

  ExtraWeather({required this.uvIndex, this.rainProbability});

  factory ExtraWeather.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('current')) {
      final hourly = json['hourly'] as List?;
      final firstHourly = (hourly != null && hourly.isNotEmpty)
          ? hourly[0]
          : {};

      return ExtraWeather(
        uvIndex: (json['current']['uvi'] as num?)?.toDouble() ?? 0.0,
        rainProbability: (firstHourly['pop'] as num?)?.toDouble() ?? 0.0,
      );
    } else if (json.containsKey('list')) {
      final list = json['list'] as List?;
      final firstItem = (list != null && list.isNotEmpty) ? list[0] : {};

      return ExtraWeather(
        uvIndex: 0.0,
        rainProbability: (firstItem['pop'] as num?)?.toDouble() ?? 0.0,
      );
    }
    return ExtraWeather(uvIndex: 0.0, rainProbability: 0.0);
  }
}
