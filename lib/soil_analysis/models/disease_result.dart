class DiseaseResult {
  final String name;
  final String cropName;
  final double confidence;
  final String description;
  final String remedy;
  final String imagePath; // Path to the analyzed image

  DiseaseResult({
    required this.name,
    required this.cropName,
    required this.confidence,
    required this.description,
    required this.remedy,
    required this.imagePath,
  });
}
