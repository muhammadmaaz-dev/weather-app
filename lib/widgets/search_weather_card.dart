import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6.w),
      child: Container(
        width: 340.w,
        padding: EdgeInsets.all(28.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
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
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Using RichText to make the degree symbol smaller and aligned top
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "20",
                            style: TextStyle(
                              fontSize: 54.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF333333),
                              height: 1.0,
                            ),
                          ),
                          TextSpan(
                            text: "°",
                            style: TextStyle(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF333333),
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
                  margin: EdgeInsets.only(top: 8.h),
                  child: Icon(
                    Icons.cloud_queue_rounded, // Outline cloud look
                    size: 90.w,
                    color: const Color(0xFF64B5F6), // Light blue
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
