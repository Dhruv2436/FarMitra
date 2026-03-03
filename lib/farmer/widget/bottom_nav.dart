import 'package:flutter/material.dart';
import 'package:farmitra/crop_analysis/screens/home_screen.dart'; // Crop Analysis Home
import 'package:farmitra/soil_analysis/screens/soil_home_screen.dart'; // Soil Analysis Home

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90, // Increased height
      child: Stack(
        clipBehavior: Clip.none, // Allow overflow
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 0,
            left: 12,
            right: 12,
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black12,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Home Tab
                  _NavItem(
                    icon: Icons.home,
                    label: "Home",
                    onTap: () {
                      // Navigate to crop_analysis home (or main home)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(),
                        ),
                      );
                    },
                  ),

                  // Soil Tab
                  _NavItem(
                    icon: Icons.grass,
                    label: "Soil",
                    onTap: () {
                      // Navigate to SoilHomeScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SoilHomeScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 70), // space for center button

                  // Market Tab
                  _NavItem(
                    icon: Icons.store,
                    label: "Market",
                    onTap: () {
                      // TODO: Implement Market screen navigation
                    },
                  ),

                  // Profile Tab
                  _NavItem(
                    icon: Icons.person,
                    label: "Profile",
                    onTap: () {
                      // TODO: Implement Profile screen navigation
                    },
                  ),
                ],
              ),
            ),
          ),

          // Center Button for Crop Doctor
          Positioned(
            top: -25,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomeScreen(), // Crop Analysis screen
                      ),
                    );
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 12,
                          color: Colors.black26,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Crop Doctor",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Updated _NavItem to include optional onTap callback
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}