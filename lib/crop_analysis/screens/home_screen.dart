import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/image_picker_service.dart';
import '../services/disease_detection_service.dart';
import '../models/disease_result.dart';
import 'camera_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePickerService _pickerService = ImagePickerService();
  final DiseaseDetectionService _detectionService = DiseaseDetectionService();

  XFile? _imageFile;
  DiseaseResult? _result;
  bool _isAnalyzing = false;

  void _pickImage(ImageSource source) async {
    XFile? file;
    if (source == ImageSource.camera) {
      file = await Navigator.push<XFile>(
        context,
        MaterialPageRoute(builder: (context) => const CameraScreen()),
      );
    } else {
      file = await _pickerService.pickXFile(source);
    }

    if (file != null) {
      setState(() {
        _imageFile = file;
        _result = null; // Reset previous result
        _isAnalyzing = true;
      });
      _analyzeImage(file!);
    }
  }

  void _analyzeImage(XFile file) async {
    try {
      final result = await _detectionService.detectDisease(file);
      if (mounted) {
        setState(() {
          _result = result;
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });

        String errorMessage = "Failed to analyze image.\n\nError details: $e";
        if (e.toString().contains("NOT_A_CROP")) {
          errorMessage = "Please Insert Proper Crop/Plant Image";
        } else if (e.toString().contains("API Key not set")) {
          errorMessage =
              "API Key is missing. Please add your Gemini API Key in the code.";
        }

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Analysis Failed"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  void _reset() {
    setState(() {
      _imageFile = null;
      _result = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F9F6,
      ), // Light greenish/white background
      appBar: AppBar(
        title: Text(
          'Crop Doctor',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: Colors.green.shade900,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Info or Help
            },
            icon: Icon(Icons.info_outline, color: Colors.green.shade900),
          ),
        ],
      ),
      body: _imageFile == null ? _buildWelcomeView() : _buildAnalysisView(),
    );
  }

  Widget _buildWelcomeView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.eco,
            size: 100,
            color: Colors.green,
          ).animate().fade().scale(duration: 800.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 24),
          Text(
            "Scan & Detect",
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 12),
          Text(
            "Take a photo of your crop to\ndetect diseases instantly.",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(fontSize: 16, color: Colors.black54),
          ).animate().fadeIn(delay: 500.ms),
          const SizedBox(height: 48),
          _buildActionButton(
            label: "Take Photo",
            icon: Icons.camera_alt,
            onTap: () => _pickImage(ImageSource.camera),
          ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          _buildActionButton(
            label: "Upload from Gallery",
            icon: Icons.photo_library,
            onTap: () => _pickImage(ImageSource.gallery),
            isPrimary: false,
          ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  Widget _buildAnalysisView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Preview Header
          Stack(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: kIsWeb
                        ? NetworkImage(_imageFile!.path)
                        : FileImage(File(_imageFile!.path)) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: _reset,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          if (_isAnalyzing)
            _buildLoadingState()
          else if (_result != null)
            _buildResultView(_result!)
          else
            Container(), // Should not happen
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const CircularProgressIndicator(color: Colors.green),
          const SizedBox(height: 16),
          Text(
            "Analyzing Leaf...",
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ).animate().shimmer(duration: 1500.ms),
        ],
      ),
    );
  }

  Widget _buildResultView(DiseaseResult result) {
    final isHealthy = result.name.toLowerCase().contains("healthy");
    final color = isHealthy ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.cropName,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      result.name,
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withValues(alpha: 0.5)),
                ),
                child: Text(
                  "${(result.confidence * 100).toStringAsFixed(0)}% Confidence",
                  style: GoogleFonts.outfit(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ).animate().fadeIn().slideX(),

          const SizedBox(height: 16),

          _buildSectionTitle("Diagnosis"),
          Text(
            result.description,
            style: GoogleFonts.outfit(fontSize: 16, color: Colors.black54),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 24),

          _buildSectionTitle("Remedy / Suggestion"),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.medical_services_outlined,
                  color: Colors.green.shade700,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    result.remedy,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      color: Colors.green.shade900,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),

          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _reset,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                "Scan Another",
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 600.ms),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isPrimary = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: isPrimary ? Colors.green.shade600 : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: isPrimary ? null : Border.all(color: Colors.green.shade200),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isPrimary ? Colors.white : Colors.green.shade700),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isPrimary ? Colors.white : Colors.green.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
