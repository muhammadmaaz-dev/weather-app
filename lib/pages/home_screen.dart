import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/models/weatherbundel_model.dart';
import 'package:weather/pages/example.dart';
import 'package:weather/pages/search_screen.dart';
import 'package:weather/services/weather_services.dart';
import 'package:weather/widgets/weather_detail_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _weatherService = WeatherServices();

  late Future<WeatherBundle> _bundelFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bundelFuture = _weatherService.fetchAllData("Islamabad");
  }

  DateTime getCityTime(int timestamp, int timezoneOffset) {
    return DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
      isUtc: true,
    ).add(Duration(seconds: timezoneOffset));
  }

  String formatTime(int timestamp, int timezoneOffset) {
    final date = getCityTime(timestamp, timezoneOffset);
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    // 12:00 PM case handle karein
    final displayHour = hour == 0 ? 12 : hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return "$displayHour:$minute $period";
  }

  String formatDuration(Duration d) {
    if (d.isNegative) return "0h 0m";
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    return "${hours}h ${minutes}m";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<WeatherBundle>(
          future: _bundelFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (snapshot.hasData) {
              final bundle = snapshot.data!;

              final weather = bundle.weather;
              final extra = bundle.extra;
              final aq = bundle.airQuality;

              final sunRiseCity = getCityTime(
                weather.sunrise,
                weather.timezone,
              );
              final sunSetCity = getCityTime(weather.sunset, weather.timezone);
              final lengthOfDay = sunSetCity.difference(sunRiseCity);

              final currentCityTime = DateTime.now().toUtc().add(
                Duration(seconds: weather.timezone),
              );
              Duration remainingDaylight = sunSetCity.difference(
                currentCityTime,
              );

              if (remainingDaylight.isNegative) {
                remainingDaylight = Duration.zero;
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 22,
                    horizontal: 18,
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: OpenContainer(
                          // 1. MATCH YOUR DESIGN: Set the color and shape to match your Container
                          closedColor: Colors.grey.shade200,
                          closedElevation:
                              0, // Remove shadow to keep your flat look
                          closedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),

                          // 2. THE TRANSITION TYPE: Standard "fade through" used by Google apps
                          transitionType: ContainerTransitionType.fadeThrough,
                          transitionDuration: const Duration(milliseconds: 400),

                          // 3. THE DESTINATION: Where to go when clicked
                          openBuilder: (context, action) {
                            return const SearchScreen(); // Replace with your actual Search Screen
                          },

                          // 4. YOUR EXISTING WIDGET (The "Closed" state)
                          closedBuilder: (context, openContainer) {
                            return Container(
                              height: 50,
                              // width: 370, // Optional: Let parent control width
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("Search Location"),
                                    Icon(Icons.search),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 80),

                      WeatherDetailsSection(
                        city: weather.cityName,
                        temperature:
                            "${weather.temprature.toStringAsFixed(0)}°",
                        time: formatTime(
                          DateTime.now().millisecondsSinceEpoch ~/ 1000,
                          weather.timezone,
                        ),
                        uv: extra.uvIndex.toStringAsFixed(1),
                        rain:
                            "${(extra.rainProbability! * 100).toStringAsFixed(0)}%",
                        airQuality: aq.aqi.toString(),
                        sunrise: formatTime(weather.sunrise, weather.timezone),
                        sunset: formatTime(weather.sunset, weather.timezone),
                        dayLength: formatDuration(lengthOfDay),
                        remainingDaylight: formatDuration(remainingDaylight),
                        imagePath: "assets/images/on_boarding.png",
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: Text("No Data"));
          },
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
