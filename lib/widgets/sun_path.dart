import 'package:flutter/material.dart';
import 'package:weather/pages/home_screen.dart';

class SunPathCard extends StatelessWidget {
  final String sunrise;
  final String sunset;
  final String dayLength;
  final String remainingDaylight;

  const SunPathCard({
    required this.sunrise,
    required this.sunset,
    required this.dayLength,
    required this.remainingDaylight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: Stack(
          children: [
            CustomPaint(
              size: const Size(double.infinity, 150),
              painter: SunPathPainter(),
            ),

            Positioned(
              left: 40,
              top: 10,
              child: _timeLabel("Sunrise", sunrise),
            ),
            Positioned(right: 35, top: 10, child: _timeLabel("Sunset", sunset)),

            Positioned(
              left: 0,
              bottom: 40,
              child: _richText("Length of Day: ", dayLength),
            ),
            Positioned(
              left: 0,
              bottom: 10,
              child: _richText("Remaining Daylight: ", remainingDaylight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeLabel(String label, String time) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        const SizedBox(height: 4),
        Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
      ],
    );
  }

  Widget _richText(String title, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        children: [
          TextSpan(text: title),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
