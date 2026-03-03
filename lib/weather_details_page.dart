import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherDetailsPage extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const WeatherDetailsPage({
    super.key,
    required this.weatherData,
  });

  @override
  Widget build(BuildContext context) {
    final cityName = weatherData["city"]?["name"] ?? "Unknown";

    final List forecastList = weatherData["list"] ?? [];

    // Get one data per day (around 12 PM)
    final dailyData = forecastList
        .where((item) =>
            item["dt_txt"] != null &&
            item["dt_txt"].toString().contains("12:00:00"))
        .take(5)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF6FA8C9),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // City Name
            Text(
              cityName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // Forecast Card
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: dailyData.isEmpty
                    ? const Center(child: Text("No forecast available"))
                    : ListView.builder(
                        itemCount: dailyData.length,
                        itemBuilder: (context, index) {
                          final item = dailyData[index];

                          final date = DateTime.parse(
                              item["dt_txt"]);

                          final day =
                              DateFormat('EEE').format(date);

                          final tempMin =
                              item["main"]?["temp_min"] ?? 0;

                          final tempMax =
                              item["main"]?["temp_max"] ?? 0;

                          final rain =
                              item["pop"] != null
                                  ? (item["pop"] * 100)
                                      .toInt()
                                  : 0;

                          final wind =
                              item["wind"]?["speed"] ?? 0;

                          final description =
                              item["weather"]?[0]
                                      ?["main"] ??
                                  "";

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                              children: [
                                Text(day,
                                    style:
                                        const TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight
                                                    .w500)),

                                Row(
                                  children: [
                                    const Icon(
                                        Icons.water_drop,
                                        size: 16,
                                        color: Colors
                                            .blue),
                                    const SizedBox(
                                        width: 4),
                                    Text("$rain%"),
                                    const SizedBox(
                                        width: 10),
                                    const Icon(
                                        Icons.air,
                                        size: 16,
                                        color: Colors
                                            .grey),
                                    const SizedBox(
                                        width: 4),
                                    Text(
                                        "$wind m/s"),
                                  ],
                                ),

                                Text(description),

                                Text(
                                  "${tempMax.toStringAsFixed(0)}°/${tempMin.toStringAsFixed(0)}°",
                                  style: const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}