import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      //navigate to search screen
                    },
                    child: Container(
                      height: 50,
                      // width: 370,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Search Location"),
                            Icon(Icons.search),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 80),

                Container(
                  height: 180,
                  width: 180,
                  child: Image.asset("assets/images/on_boarding.png"),
                ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Islamabad ",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.location_on),
                  ],
                ),

                Text(
                  "31°",
                  style: TextStyle(fontSize: 65, fontWeight: FontWeight.bold),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        WeatherInfo(title: "TIME", value: "11:25 AM"),
                        WeatherInfo(title: "UV", value: "4"),
                        WeatherInfo(title: "% RAIN", value: "58%"),
                        WeatherInfo(title: "AQ", value: "22"),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            CustomPaint(
                              size: Size(constraints.maxWidth, 150),
                              painter: SunPathPainter(),
                            ),

                            Positioned(
                              left: 40,
                              top: 10,
                              child: _buildTimeLabel("Sunrise", "06:25 AM"),
                            ),
                            Positioned(
                              right: 35,
                              top: 10,
                              child: _buildTimeLabel("Sunset", "08:30 PM"),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 60,
                              child: Text(
                                "Horizon",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                            ),

                            Positioned(
                              left: 0,
                              bottom: 40,
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                  children: [
                                    TextSpan(text: "Length of Day: "),
                                    TextSpan(
                                      text: "13h 22m",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          255,
                                          0,
                                          0,
                                          0,
                                        ),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              bottom: 10,
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                  children: [
                                    TextSpan(text: "Remaining Daylight: "),
                                    TextSpan(
                                      text: "9h 12m",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          255,
                                          0,
                                          0,
                                          0,
                                        ),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeLabel(String label, String time) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        const SizedBox(height: 4),
        Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
      ],
    );
  }
}

class WeatherInfo extends StatelessWidget {
  final String title;
  final String value;

  const WeatherInfo({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class SunPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final height = size.height;

    final width = size.width;

    const double horizonY = 110.0;

    final double startX = width * 0.2;
    final double endX = width * 0.8;

    final horizonPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    _drawDashedLine(
      canvas,
      horizonPaint,
      Offset(0, horizonY),
      Offset(width, horizonY),
    );

    final nightPath = Path();
    nightPath.moveTo(0, horizonY);

    nightPath.quadraticBezierTo(startX / 2, horizonY + 40, startX, horizonY);

    final nightPaint = Paint()
      ..color = const Color(0xFF0C2D80)
      ..style = PaintingStyle.fill;

    canvas.drawPath(nightPath, nightPaint);

    final dayPath = Path();
    dayPath.moveTo(startX, horizonY);

    final controlX = startX + (endX - startX) / 2;
    dayPath.quadraticBezierTo(controlX, -20, endX, horizonY);

    final dayPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(startX, horizonY),
        Offset(startX, 0),
        [Colors.lightBlueAccent.withOpacity(0.2), Colors.lightBlueAccent],
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(dayPath, dayPaint);

    final dashedPaint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Sunrise Line
    _drawDashedLine(
      canvas,
      dashedPaint,
      Offset(startX, horizonY),
      Offset(startX, 60),
    );
    // Sunset Line
    _drawDashedLine(
      canvas,
      dashedPaint,
      Offset(endX, horizonY),
      Offset(endX, 60),
    );

    const double t = 0.35;

    // Bezier formula: B(t) = (1-t)^2 * P0 + 2(1-t)t * P1 + t^2 * P2
    final p0 = Offset(startX, horizonY);
    final p1 = Offset(controlX, -20);
    final p2 = Offset(endX, horizonY);

    final sunX =
        math.pow(1 - t, 2) * p0.dx +
        2 * (1 - t) * t * p1.dx +
        math.pow(t, 2) * p2.dx;
    final sunY =
        math.pow(1 - t, 2) * p0.dy +
        2 * (1 - t) * t * p1.dy +
        math.pow(t, 2) * p2.dy;

    // Draw Sun glow
    canvas.drawCircle(
      Offset(sunX, sunY),
      12,
      Paint()..color = Colors.orangeAccent.withOpacity(0.3),
    );
    // Draw Sun core
    canvas.drawCircle(Offset(sunX, sunY), 6, Paint()..color = Colors.orange);

    // Draw little cloud decoration (Optional simple circles)
    canvas.drawCircle(
      Offset(sunX - 8, sunY + 4),
      6,
      Paint()..color = Colors.lightBlue[100]!,
    );
    canvas.drawCircle(
      Offset(sunX + 8, sunY + 6),
      5,
      Paint()..color = Colors.lightBlue[100]!,
    );
  }

  // Helper to draw dashed lines
  void _drawDashedLine(Canvas canvas, Paint paint, Offset p1, Offset p2) {
    const int dashWidth = 4;
    const int dashSpace = 4;
    double startX = p1.dx;
    double currentX = startX;

    // Handle vertical vs horizontal
    if (p1.dy == p2.dy) {
      // Horizontal
      while (currentX < p2.dx) {
        canvas.drawLine(
          Offset(currentX, p1.dy),
          Offset(currentX + dashWidth, p1.dy),
          paint,
        );
        currentX += dashWidth + dashSpace;
      }
    } else {
      // Vertical
      double startY = p2.dy; // Drawing from bottom up
      double currentY = startY;
      while (currentY < p1.dy) {
        canvas.drawLine(
          Offset(p1.dx, currentY),
          Offset(p1.dx, currentY + dashWidth),
          paint,
        );
        currentY += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
