import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90, // 🔥 Increased height
      child: Stack(
        clipBehavior: Clip.none, // 🔥 Allow overflow
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
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                children: const [
                  _NavItem(icon: Icons.home, label: "Home"),
                  _NavItem(icon: Icons.grass, label: "Soil"),
                  SizedBox(width: 70), // space for center button
                  _NavItem(icon: Icons.store, label: "Market"),
                  _NavItem(icon: Icons.person, label: "Profile"),
                ],
              ),
            ),
          ),

          // ✅ PERFECT CENTER BUTTON POSITION
          Positioned(
            top: -25, // 🔥 Pushes button up properly
            child: Column(
              children: [
                Container(
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

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.grey),
        Text(
          label,
          style: const TextStyle(
              fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}