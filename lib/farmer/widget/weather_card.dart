import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final Map<String, dynamic>? weatherData;

  const WeatherCard({super.key, this.weatherData});

  @override
  Widget build(BuildContext context) {
    // Default values if data is missing
    final temp = weatherData?['main']?['temp']?.round() ?? 17;
    final city = weatherData?['name'] ?? "Unknown Location";
    final humidity = weatherData?['main']?['humidity'] ?? 50;
    final precip = weatherData?['rain']?['1h'] ?? 0.0; // Rain in last hour
    final pressure = weatherData?['main']?['pressure'] ?? 1013;
    final wind = weatherData?['wind']?['speed'] ?? 0.0;
    final maxTemp = weatherData?['main']?['temp_max']?.round() ?? 23;
    final minTemp = weatherData?['main']?['temp_min']?.round() ?? 12;

    // Convert sunset/sunrise timestamps
    String formatTime(int? timestamp) {
      if (timestamp == null) return "--:--";
      final dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'pm' : 'am';
      return "$hour:$minute $period";
    }

    final sunriseTime = formatTime(weatherData?['sys']?['sunrise']);
    final sunsetTime = formatTime(weatherData?['sys']?['sunset']);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 20,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        city,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.cloud_queue_rounded,
                size: 48,
                color: Colors.blueAccent,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${temp > 0 ? '+' : ''}$temp°C",
                style: const TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 16),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "H: $maxTemp°C",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Text(
                      "L: $minTemp°C",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoItem("Humidity", "$humidity%"),
              _infoItem("Precipitation", "${precip}mm"),
              _infoItem("Pressure", "$pressure hpa"),
              _infoItem("Wind", "${wind}m/s"),
            ],
          ),
          const SizedBox(height: 32),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey.withOpacity(0.2),
              ),
              Positioned(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orangeAccent.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sunriseTime,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const Text(
                    "Sunrise",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    sunsetTime,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const Text(
                    "Sunset",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
