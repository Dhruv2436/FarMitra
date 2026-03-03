import 'package:flutter/material.dart';
import 'farmer/farmer_home.dart';

void main() {
  runApp(const FarmMitraApp());
}

class FarmMitraApp extends StatelessWidget {
  const FarmMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FarmMitra',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const FarmerHome(),
    );
  }
}