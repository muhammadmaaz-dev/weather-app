import 'package:flutter/material.dart';
import 'package:weather/widgets/search_weather_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
          child: Column(
            children: [
              /// 🔹 FIXED SEARCH BAR
              TextField(
                decoration: InputDecoration(
                  hintText: "Search Location",
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// 🔹 SCROLLABLE WEATHER LIST
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      WeatherCard(),
                      WeatherCard(),
                      WeatherCard(),
                      WeatherCard(),
                      WeatherCard(),
                      WeatherCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
