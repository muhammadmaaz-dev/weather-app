import 'dart:math' as math show pow;
import 'dart:ui' as ui;

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/models/weatherbundel_model.dart';
import 'package:weather/pages/search_screen.dart';
import 'package:weather/services/weather_services.dart';
import 'package:weather/widgets/weather_detail_section.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherServices _weatherServices = WeatherServices();
  WeatherBundle? _weatherBundle;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _determinePositionAndFetchWeather();
  }

  Future<void> _determinePositionAndFetchWeather() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Check GPS
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _errorMessage = 'Location services are disabled.';
        _isLoading = false;
      });
      return;
    }

    // 2. Check Permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _errorMessage = 'Location permissions are denied';
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _errorMessage = 'Location permissions are permanently denied.';
        _isLoading = false;
      });
      return;
    }

    // 3. Get Position & Fetch Weather
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final data = await _weatherServices.fetchAllDataByLocation(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _weatherBundle = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // --- Helper Functions ---
  String _formatTime(int timestamp, int timezoneOffset) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
      isUtc: true,
    ).add(Duration(seconds: timezoneOffset));
    return DateFormat('hh:mm a').format(date);
  }

  String _formatDuration(int start, int end) {
    final duration = Duration(seconds: end - start);
    return "${duration.inHours}h ${duration.inMinutes.remainder(60)}m";
  }

  String getWeatherImage(String? condition) {
    if (condition == null) {
      return "assets/images/default.png";
    }

    final c = condition.toLowerCase().trim();

    if (c.contains('thunder')) {
      return "assets/images/thunder.png";
    } else if (c.contains('rain') || c.contains('drizzle')) {
      return "assets/images/rainy.png";
    } else if (c.contains('snow')) {
      return "assets/images/snow.png";
    } else if (c.contains('clear')) {
      return "assets/images/sunny.png";
    } else if (c.contains('cloud') ||
        c.contains('mist') ||
        c.contains('fog') ||
        c.contains('haze') ||
        c.contains('dust') ||
        c.contains('smoke')) {
      return "assets/images/cloudy.png";
    }

    return "assets/images/default.png";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_errorMessage, textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                          _errorMessage = '';
                        });
                        _determinePositionAndFetchWeather();
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 22,
                    horizontal: 18,
                  ),
                  child: Column(
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
                              height: 48.h,
                              // width: 370, // Optional: Let parent control width
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18.w),
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

                      SizedBox(height: 72.h),
                      WeatherDetailsSection(
                        city: _weatherBundle!.weather.cityName,
                        temperature:
                            "${_weatherBundle!.weather.temprature.round()}°",
                        time: DateFormat('hh:mm a').format(DateTime.now()),
                        uv: _weatherBundle!.extra.uvIndex.toStringAsFixed(0),
                        rain:
                            "${(_weatherBundle!.extra.rainProbability! * 100).round()}%",
                        airQuality: _weatherBundle!.airQuality.aqi.toString(),
                        sunrise: _formatTime(
                          _weatherBundle!.weather.sunrise,
                          _weatherBundle!.weather.timezone,
                        ),
                        sunset: _formatTime(
                          _weatherBundle!.weather.sunset,
                          _weatherBundle!.weather.timezone,
                        ),
                        dayLength: _formatDuration(
                          _weatherBundle!.weather.sunrise,
                          _weatherBundle!.weather.sunset,
                        ),
                        // Calculate remaining daylight dynamically
                        remainingDaylight:
                            (_weatherBundle!.weather.sunset >
                                (DateTime.now().millisecondsSinceEpoch / 1000))
                            ? _formatDuration(
                                (DateTime.now().millisecondsSinceEpoch / 1000)
                                    .round(),
                                _weatherBundle!.weather.sunset,
                              )
                            : "0h 0m",
                        imagePath: getWeatherImage(
                          _weatherBundle!.weather.mainCondition,
                        ),

                        speed: _weatherBundle!.weather.speed.toString(),
                        desc: _weatherBundle!.weather.desc.toString(),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

Widget _buildTimeLabel(String label, String time) {
  return Column(
    children: [
      Text(
        label,
        style: TextStyle(color: Colors.grey[400], fontSize: 10.sp),
      ),
      SizedBox(height: 3.h),
      Text(
        time,
        style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
      ),
    ],
  );
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
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.grey,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
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
