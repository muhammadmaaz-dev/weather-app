import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(body: Center(child: SunriseSunsetCard())),
    ),
  );
}

class SunriseSunsetCard extends StatelessWidget {
  const SunriseSunsetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SUNRISE & SUNSET",
            style: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 30),

          // The Custom Chart Area
          const SizedBox(
            height: 150,
            width: double.infinity,
            child: SunriseSunsetGraph(),
          ),

          const SizedBox(height: 20),

          // Footer Info
          Row(
            children: [
              Text(
                "Length of day: ",
                style: TextStyle(color: Colors.grey[500], fontSize: 16),
              ),
              const Text(
                "13H 12M",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                "Remaining daylight: ",
                style: TextStyle(color: Colors.grey[500], fontSize: 16),
              ),
              const Text(
                "9H 22M",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SunriseSunsetGraph extends StatelessWidget {
  const SunriseSunsetGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // The Graph Painter
            CustomPaint(
              size: Size(constraints.maxWidth, 150),
              painter: SunPathPainter(),
            ),

            // Labels positioned absolutely to match the graph points
            // Note: In a real app, you would calculate these 'left' positions dynamically
            // based on the same logic used in the painter.
            Positioned(
              left: 40,
              top: 30,
              child: _buildTimeLabel("Sunrise", "06:25 AM"),
            ),
            Positioned(
              right: 40,
              top: 30,
              child: _buildTimeLabel(
                "Sunset",
                "08:30 PM",
              ), // Image said Sunrise, corrected to Sunset
            ),
            Positioned(
              right: 0,
              bottom: 40,
              child: Text(
                "Horizon",
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ),
          ],
        );
      },
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

class SunPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final width = size.width;
    final height = size.height;

    // Configuration
    const double horizonY = 110.0; // Y position of the horizon line
    const double startX = 80.0; // X position where the "Day" curve starts
    const double endX = 300.0; // X position where the "Day" curve ends

    // 1. Draw Horizon Line (Dashed)
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

    // 2. Draw the "Night" Curve (Dark Blue, Left side)
    // We simulate a sine wave dip below the horizon
    final nightPath = Path();
    nightPath.moveTo(0, horizonY);
    // Quadratic bezier to create the dip
    nightPath.quadraticBezierTo(startX / 2, horizonY + 40, startX, horizonY);

    final nightPaint = Paint()
      ..color =
          const Color(0xFF0C2D80) // Dark Navy Blue
      ..style = PaintingStyle.fill;

    canvas.drawPath(nightPath, nightPaint);

    // 3. Draw the "Day" Curve (Light Blue Gradient, Center)
    final dayPath = Path();
    dayPath.moveTo(startX, horizonY);
    // Control point is in the middle of X, and high up (Y=20)
    final controlX = startX + (endX - startX) / 2;
    dayPath.quadraticBezierTo(controlX, -20, endX, horizonY);

    final dayPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(startX, horizonY),
        Offset(startX, 0),
        [
          Colors.lightBlueAccent.withOpacity(0.2), // Bottom color
          Colors.lightBlueAccent, // Top color
        ],
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(dayPath, dayPaint);

    // 4. Draw Vertical Dashed Lines (Sunrise/Sunset markers)
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

    // 5. Draw the Sun Icon
    // We need to calculate a point on the curve.
    // Since we used a Quadratic Bezier, we can calculate the point for t (0.0 to 1.0)
    // Let's assume current time is roughly 30% through the day (t = 0.3)
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
