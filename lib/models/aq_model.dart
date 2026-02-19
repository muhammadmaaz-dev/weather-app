class AirQuality {
  final int aqi;
  final double pm25;
  final double pm10;

  AirQuality({required this.aqi, required this.pm25, required this.pm10});

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List?;
    if (list != null && list.isNotEmpty) {
      final item = list[0];
      final main = item['main'] ?? {};
      final components = item['components'] ?? {};

      return AirQuality(
        aqi: (main['aqi'] as num?)?.toInt() ?? 0,
        pm25: (components['pm2_5'] as num?)?.toDouble() ?? 0.0,
        pm10: (components['pm10'] as num?)?.toDouble() ?? 0.0,
      );
    }
    // Return default/empty if data is missing
    return AirQuality(aqi: 0, pm25: 0.0, pm10: 0.0);
  }
}
