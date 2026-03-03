// services/chatgpt_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatGPTService {
  static const String _apiKey = "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"; // Replace with your API key

  Future<String> sendMessage(List<Map<String, String>> messages) async {
    try {
      final response = await http.post(
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "openai/gpt-oss-120b",
          "messages": messages,
          "temperature": 0.7,
        }),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        if (data["choices"][0]["message"] != null) {
          return data["choices"][0]["message"]["content"];
        } else if (data["choices"][0]["content"] != null) {
          return data["choices"][0]["content"][0]["text"];
        } else {
          return "⚠ Unexpected API response";
        }
      } else {
        final error = jsonDecode(response.body);
        return "⚠ ${error["error"]["message"]}";
      }
    } catch (e) {
      return "⚠ Network Error: $e";
    }
  }
}