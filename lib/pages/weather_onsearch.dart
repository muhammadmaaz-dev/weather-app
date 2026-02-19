import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weather/models/weatherbundel_model.dart';
import 'package:weather/widgets/weather_detail_section.dart'; // Required for DateFormat

class WeatherOnsearch extends StatelessWidget {
  // Fixed typo: weatherBundel -> weatherBundle
  final WeatherBundle weatherBundle;

  const WeatherOnsearch({super.key, required this.weatherBundle});

  // Helper: Format Unix timestamp to "06:25 AM" accounting for timezone
  String _formatTime(int timestamp, int timezoneOffset) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
      isUtc: true,
    ).add(Duration(seconds: timezoneOffset));
    return DateFormat('hh:mm a').format(date);
  }

  // Helper: Calculate duration (e.g., 13h 22m)
  String _formatDuration(int start, int end) {
    final duration = Duration(seconds: end - start);
    if (duration.isNegative) return "0h 0m";
    return "${duration.inHours}h ${duration.inMinutes.remainder(60)}m";
  }

  String _getWeatherImage(String? condition) {
    if (condition == null) return "assets/images/default.png";
    switch (condition.toLowerCase()) {
      case "clear":
        return "assets/images/sunny.png";
      case "clouds":
        return "assets/images/cloudy.png";
      case "rain":
      case "drizzle":
      case "mist":
        return "assets/images/rainy.png";
      case "thunderstorm":
        return "assets/images/thunder.png";
      case "snow":
        return "assets/images/snow.png";
      default:
        return "assets/images/default.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    final weather = weatherBundle.weather;
    final extra = weatherBundle.extra;
    final air = weatherBundle.airQuality;

    // Current time at the searched location
    final DateTime now = DateTime.now().toUtc().add(
      Duration(seconds: weather.timezone),
    );
    final String formattedTime = DateFormat('hh:mm a').format(now);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            child: Column(
              children: [
                // --- Header ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Add to List",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(Icons.add_circle_outline, size: 16.w),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 36.h),

                // --- Live Data Section ---
                WeatherDetailsSection(
                  city: weather.cityName,
                  temperature: "${weather.temprature.round()}°",
                  time: formattedTime,
                  uv: extra.uvIndex.toStringAsFixed(0),
                  rain: "${((extra.rainProbability ?? 0.0) * 100).round()}%",
                  airQuality: air.aqi.toString(),
                  sunrise: _formatTime(weather.sunrise, weather.timezone),
                  sunset: _formatTime(weather.sunset, weather.timezone),
                  dayLength: _formatDuration(weather.sunrise, weather.sunset),
                  remainingDaylight: _formatDuration(
                    (DateTime.now().millisecondsSinceEpoch / 1000).round(),
                    weather.sunset,
                  ),
                  imagePath: _getWeatherImage(
                    weather.mainCondition,
                  ), // Logic to change image can be added here
                  speed: weather.speed.toString(),
                  desc: weather.desc.toString(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
