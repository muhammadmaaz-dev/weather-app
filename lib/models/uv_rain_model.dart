class ExtraWeather {
  final double uvIndex;
  final double? rainProbability;

  ExtraWeather({required this.uvIndex, this.rainProbability});

  factory ExtraWeather.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('current')) {
      // Keep support for One Call API (in case user upgrades later)
      return ExtraWeather(
        uvIndex: json['current']['uvi']?.toDouble() ?? 0.0,
        rainProbability: json['hourly']?[0]['pop']?.toDouble() ?? 0.0,
      );
    } else if (json.containsKey('list')) {
      // Support for 5 Day / 3 Hour Forecast API
      final List list = json['list'];
      final firstItem = list.isNotEmpty ? list[0] : {};
      return ExtraWeather(
        uvIndex: 0.0, // Not available in free forecast API
        rainProbability: (firstItem['pop'] is num)
            ? firstItem['pop'].toDouble()
            : 0.0,
      );
    }
    // Default fallback
    return ExtraWeather(uvIndex: 0.0, rainProbability: 0.0);
  }
}
