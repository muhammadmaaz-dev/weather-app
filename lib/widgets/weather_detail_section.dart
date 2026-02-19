import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final String speed;
  final String desc;

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
    required this.speed,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Weather Image
        SizedBox(height: 160.h, width: 160.w, child: Image.asset(imagePath)),

        SizedBox(height: 18.h),

        /// City + Location Icon
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              city,
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.location_on),
          ],
        ),

        /// Temperature
        Text(
          temperature,
          style: TextStyle(fontSize: 58.sp, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 8.h),

        /// Weather Info Row
        Container(
          padding: EdgeInsets.symmetric(vertical: 18.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              WeatherInfo(title: "TIME", value: time),
              WeatherInfo(title: "W.SPEED", value: speed),
              WeatherInfo(title: "% RAIN", value: rain),
              WeatherInfo(title: "AQ", value: airQuality),
              WeatherInfo(title: "DESC.", value: desc),
            ],
          ),
        ),

        SizedBox(height: 18.h),

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
