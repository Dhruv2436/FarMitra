import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import '../widgets/weather_card.dart';
import '../widgets/sun_curve.dart';
import '../models/weather_model.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  WeatherModel? weather;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    final position = await LocationService().getCurrentLocation();
    final data = await WeatherService()
        .fetchWeather(position.latitude, position.longitude);

    setState(() {
      weather = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const SunCurve(),
                  const SizedBox(height: 20),
                  WeatherCard(weather: weather!),
                ],
              ),
            ),
    );
  }
}