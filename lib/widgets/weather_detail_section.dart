import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:weather/pages/home_screen.dart';
import 'package:weather/widgets/sun_path.dart';

class WeatherDetailsSection extends StatelessWidget {
  final String city;
  final String temperature;
  final String time;
  final String uv;
  final String rain;
  final String airQuality;
  final String sunrise;
  final String sunset;
  final String dayLength;
  final String remainingDaylight;
  final String imagePath;

  const WeatherDetailsSection({
    super.key,
    required this.city,
    required this.temperature,
    required this.time,
    required this.uv,
    required this.rain,
    required this.airQuality,
    required this.sunrise,
    required this.sunset,
    required this.dayLength,
    required this.remainingDaylight,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Weather Image
        SizedBox(height: 180, width: 180, child: Image.asset(imagePath)),

        const SizedBox(height: 20),

        /// City + Location Icon
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              city,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.location_on),
          ],
        ),

        /// Temperature
        Text(
          temperature,
          style: const TextStyle(fontSize: 65, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        /// Weather Info Row
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              WeatherInfo(title: "TIME", value: time),
              WeatherInfo(title: "UV", value: uv),
              WeatherInfo(title: "% RAIN", value: rain),
              WeatherInfo(title: "AQ", value: airQuality),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// Sun Path Section
        SunPathCard(
          sunrise: sunrise,
          sunset: sunset,
          dayLength: dayLength,
          remainingDaylight: remainingDaylight,
        ),
      ],
    );
  }
}
