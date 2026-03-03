import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../screens/weather_detail_screen.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WeatherDetailScreen(weather: weather),
          ),
        );
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(weather.cityName,
                  style: const TextStyle(fontSize: 20)),
              Image.network(
                "https://openweathermap.org/img/wn/${weather.icon}@4x.png",
                height: 100,
              ),
              Text("${weather.temperature}°C",
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold)),
              Text(weather.description),
            ],
          ),
        ),
      ),
    );
  }
}