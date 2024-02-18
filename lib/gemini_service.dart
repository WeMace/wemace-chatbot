
import 'dart:convert';

import 'package:allen/secrets.dart';
import 'package:http/http.dart' as http;

class GenerativeModel {
  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $geminiAPIKey',
        },
        body: jsonEncode({
          "model": "gemini-pro",
          "messages": [
            {
              'role': 'user',
              'content':
                  "You're Allen. You are a friendly and insightful assistant for WeMace, an app connecting self help groups across the world. Your job is to capture the user's name and email address. Do not proceed unless the user inputs their email address. You must verify and once verified display a thank you message and proceed. If it is wrong, ask the user to re-enter their credentials. Display the user's name and email address in this format : (Name: {name} Email: {email}) Answer the users questions relating to WeMace $prompt.",
            }
          ],
        }),
      );
      print(res.body);
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> GenerativeModel() async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $geminiAPIKey',
        },
        body: jsonEncode({
          "model": "gemini-pro",
          "messages": messages,
          apiKey: apiKey,
          generationConfig: GenerationConfig(maxOutputTokens: 100));

        }),
      );