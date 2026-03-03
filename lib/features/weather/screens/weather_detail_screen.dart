import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherDetailScreen extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather Details")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              title: const Text("Humidity"),
              trailing: Text("${weather.humidity}%"),
            ),
            ListTile(
              title: const Text("Wind Speed"),
              trailing: Text("${weather.windSpeed} m/s"),
            ),
            ListTile(
              title: const Text("Pressure"),
              trailing: Text("${weather.pressure} hPa"),
            ),
          ],
        ),
      ),
    );
  }
}