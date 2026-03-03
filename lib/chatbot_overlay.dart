import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'services/chatgpt_service.dart';
import '../farmer/widget/peacock_loader.dart';

class ChatbotOverlay extends StatefulWidget {
  const ChatbotOverlay({super.key});

  @override
  State<ChatbotOverlay> createState() => _ChatbotOverlayState();
}

class _ChatbotOverlayState extends State<ChatbotOverlay> {
  final TextEditingController _controller = TextEditingController();
  final ChatGPTService _chatService = ChatGPTService();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // ================= LOAD HISTORY =================
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("chat_history");

    if (saved != null) {
      List decoded = jsonDecode(saved);
      _messages = decoded.map((e) => Map<String, String>.from(e)).toList();
    }

    // First time greeting
    if (_messages.isEmpty) {
      _messages.add({
        "role": "assistant",
        "content":
            "🌾 Welcome to Farmitra AI!\n\nHow can I assist you with soil, crops, fertilizers, irrigation, or pests today?"
      });
    }

    setState(() {});
    _scrollToBottom();
  }

  // ================= SAVE HISTORY =================
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("chat_history", jsonEncode(_messages));
  }

  // ================= SEND MESSAGE =================
  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    String userText = _controller.text.trim();

    setState(() {
      _messages.add({"role": "user", "content": userText});
      _isLoading = true;
    });

    _controller.clear();
    _scrollToBottom();

    // Clean messages to avoid sending previous errors
    List<Map<String, String>> apiMessages = [
      {
        "role": "system",
        "content":
            "You are an agricultural expert AI helping farmers with soil health, crop diseases, fertilizers, irrigation, and pest control in simple language."
      },
      ..._messages.where((m) =>
          (m["role"] == "user") ||
          (m["role"] == "assistant" &&
              !(m["content"]?.startsWith("⚠") ?? false)))
    ];

    print("Sending messages to API: $apiMessages");

    String reply = await _chatService.sendMessage(apiMessages);

    setState(() {
      _messages.add({"role": "assistant", "content": reply});
      _isLoading = false;
    });

    _saveHistory();
    _scrollToBottom();
  }

  // ================= AUTO SCROLL =================
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Farmitra AI 🌾",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove("chat_history");
                      setState(() => _messages.clear());
                      _loadHistory();
                    },
                  ),
                ],
              ),
            ),
            const Divider(),

            // Chat messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  bool isUser = _messages[index]["role"] == "user";
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.green[200] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: MarkdownBody(
                        data: _messages[index]["content"] ?? "",
                        styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (_isLoading)
  const Padding(
    padding: EdgeInsets.all(8.0),
    child: PeacockLoader(),
  ),

            // Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Ask about farming...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.green),
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}