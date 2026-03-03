import 'package:flutter/material.dart';

class DetailedWeatherScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailedWeatherScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {

    final description = data["weather"][0]["description"];
    final pressure = data["main"]["pressure"];
    final feelsLike = data["main"]["feels_like"];

    return Scaffold(
      appBar: AppBar(title: const Text("Detailed Weather")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Condition: $description"),
            Text("Pressure: $pressure hPa"),
            Text("Feels Like: $feelsLike°C"),
          ],
        ),
      ),
    );
  }
}