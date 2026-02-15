import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Top Section: Location, Temp, Cloud ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side: Text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Mumbai",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Using RichText to make the degree symbol smaller and aligned top
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "20",
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                              height: 1.0,
                            ),
                          ),
                          TextSpan(
                            text: "°",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                              fontFeatures: [FontFeature.superscripts()],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Right side: Cloud Icon
                // Note: Using a standard icon here. For the exact multi-colored
                // vector look, you would usually use an SvgPicture.asset.
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Icon(
                    Icons.cloud_queue_rounded, // Outline cloud look
                    size: 100,
                    color: Color(0xFF64B5F6), // Light blue
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
