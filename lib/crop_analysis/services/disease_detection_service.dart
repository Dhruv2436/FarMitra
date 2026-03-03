import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import '../models/disease_result.dart';

class DiseaseDetectionService {
  static const String _apiKey =
      "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";

  Future<DiseaseResult> detectDisease(XFile imageFile) async {
    try {
      // 1. Read image
      Uint8List imageBytes = await imageFile.readAsBytes();
      print("Original size: ${imageBytes.length}");

      // 2. Compress image using pure Dart 'image' package
      final decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) {
        throw Exception("Failed to decode image.");
      }

      // Resize if too large
      img.Image smallerImage = decodedImage;
      if (decodedImage.width > 1024 || decodedImage.height > 1024) {
        smallerImage = img.copyResize(
          decodedImage,
          width: decodedImage.width > decodedImage.height ? 1024 : null,
          height: decodedImage.height >= decodedImage.width ? 1024 : null,
        );
      }

      Uint8List compressed = Uint8List.fromList(
        img.encodeJpg(smallerImage, quality: 50),
      );
      print("Compressed size: ${compressed.length}");

      String base64Image = base64Encode(compressed);

      // 3. Prompt
      final prompt = '''
You are an expert plant pathologist. 
Identify the crop/plant in this image and diagnose any disease.
Return a valid JSON object with these fields:
{
  "isCrop": boolean (true if the image contains any plant or leaf),
  "cropName": "Name of the plant",
  "diseaseName": "Scientific or common name of the disease (or 'Healthy' if none)",
  "confidence": float (0.0 to 1.0),
  "description": "Short description of the diagnosis",
  "remedy": "Detailed advice for the farmer on how to treat or prevent this"
}
''';

      // 4. API Call to OpenRouter
      final response = await http.post(
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
          "HTTP-Referer": "http://localhost",
          "X-Title": "Crop Doctor",
        },
        body: jsonEncode({
          "model": "openai/gpt-4o-mini",
          "messages": [
            {
              "role": "user",
              "content": [
                {"type": "text", "text": prompt},
                {
                  "type": "image_url",
                  "image_url": {"url": "data:image/jpeg;base64,$base64Image"},
                },
              ],
            },
          ],
          "response_format": {"type": "json_object"},
        }),
      );

      print("STATUS: ${response.statusCode}");
      if (response.statusCode != 200) {
        throw Exception("HTTP Error: ${response.body}");
      }

      final data = jsonDecode(response.body);
      if (!data.containsKey("choices")) {
        throw Exception("Invalid response: $data");
      }

      String text = data["choices"][0]["message"]["content"];

      // Defensive: Strip markdown code blocks if the model ignored instructions
      if (text.contains("```json")) {
        text = text.replaceAll("```json", "");
        text = text.replaceAll("```", "");
      } else if (text.contains("```")) {
        text = text.replaceAll("```", "");
      }
      text = text.trim();

      final jsonResponse = jsonDecode(text);

      if (jsonResponse['isCrop'] == false) {
        throw Exception("NOT_A_CROP");
      }

      // 5. Return result
      return DiseaseResult(
        name: jsonResponse['diseaseName'],
        cropName: jsonResponse['cropName'],
        confidence: (jsonResponse['confidence'] as num).toDouble(),
        description: jsonResponse['description'],
        remedy: jsonResponse['remedy'],
        imagePath: imageFile.path,
      );
    } catch (e) {
      print("ERROR: $e");
      rethrow;
    }
  }
}
