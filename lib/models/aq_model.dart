class AirQuality {
  final int aqi;
  final double pm25;
  final double pm10;

  AirQuality({required this.aqi, required this.pm25, required this.pm10});

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    return AirQuality(
      aqi: json['list'][0]['main']['aqi'],
      pm25: json['list'][0]['components']['pm2_5'].toDouble(),
      pm10: json['list'][0]['components']['pm10'].toDouble(),
    );
  }
}
