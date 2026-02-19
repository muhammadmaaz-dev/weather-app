import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: SizedBox(
        height: 200.h,
        width: double.infinity,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(double.infinity, 135.h),
              painter: SunPathPainter(),
            ),

            Positioned(
              left: 36.w,
              top: 8.h,
              child: _timeLabel("Sunrise", sunrise),
            ),
            Positioned(
              right: 32.w,
              top: 8.h,
              child: _timeLabel("Sunset", sunset),
            ),

            Positioned(
              left: 0,
              bottom: 36.h,
              child: _richText("Length of Day: ", dayLength),
            ),
            Positioned(
              left: 0,
              bottom: 8.h,
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

  Widget _richText(String title, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
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
