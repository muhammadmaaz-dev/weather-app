import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather/models/weatherbundel_model.dart';
import 'package:weather/pages/weather_onsearch.dart';
import 'package:weather/services/weather_services.dart';
import 'package:weather/widgets/search_weather_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final WeatherServices _weatherServices = WeatherServices();
  bool _isLoading = false;

  void _searchLocation() async {
    final city = _controller.text.trim();
    if (city.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      print("1. Fetching data for: $city");
      final WeatherBundle data = await _weatherServices.fetchAllData(city);

      print("2. Data fetched successfully! Navigating to WeatherOnsearch...");
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherOnsearch(weatherBundle: data),
        ),
      );
    } catch (e) {
      print("Error caught in SearchScreen: $e"); // Add this line
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("City not found or network error")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                onSubmitted: (_) => _searchLocation(),
                decoration: InputDecoration(
                  hintText: "Search Location",
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  suffixIcon: _isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _searchLocation,
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
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
