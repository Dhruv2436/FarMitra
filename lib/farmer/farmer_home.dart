import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../common/app_colors.dart';
import '../services/weather_service.dart';
import 'widget/header_section.dart';
import 'widget/weather_card.dart';
import 'widget/bottom_nav.dart';
import '../weather_details_page.dart';
import '../chatbot_overlay.dart';
import 'package:farmitra/crop_analysis/screens/home_screen.dart';


class FarmerHome extends StatefulWidget {
  const FarmerHome({super.key});

  @override
  State<FarmerHome> createState() => _FarmerHomeState();
}

class _FarmerHomeState extends State<FarmerHome> {
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _error = "Location services are disabled.";
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error = "Location permission permanently denied.";
          _isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      final weatherService = WeatherService();
      final data = await weatherService.fetchWeather(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _weatherData = data;
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _error = "Error fetching weather";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderSection(),
            const SizedBox(height: 12),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (_weatherData != null)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeatherDetailsPage(
                        weatherData: _weatherData!, // ✅ fixed null issue
                      ),
                    ),
                  );
                },
                child: WeatherCard(
                  weatherData: _weatherData!, // ✅ FIXED HERE
                ),
              ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    floatingActionButton: FloatingActionButton(
  backgroundColor: Colors.green,
  onPressed: () {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return const ChatbotOverlay();
      },
    );
  },
  child: const Icon(Icons.smart_toy),
),
    );
  }
}