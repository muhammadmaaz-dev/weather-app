import 'package:flutter/material.dart';
import 'package:weather/widgets/weather_detail_section.dart';

class WeatherOnsearch extends StatelessWidget {
  const WeatherOnsearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          Text(
                            "Add to List",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.add_circle_outline,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                WeatherDetailsSection(
                  city: "Islamabad",
                  temperature: "31°",
                  time: "11:25 AM",
                  uv: "4",
                  rain: "58%",
                  airQuality: "22",
                  sunrise: "06:25 AM",
                  sunset: "08:30 PM",
                  dayLength: "13h 22m",
                  remainingDaylight: "9h 12m",
                  imagePath: "assets/images/on_boarding.png",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
