import 'dart:convert';
import 'package:chatty/chat_model.dart';
import 'package:http/http.dart' as http;

class ChatGPTAPI {
  static const String baseUrl = 'https://api.openai.com/v1/chat/completions';
  static const String apiKey =
      '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';

  Future<ChatModel> getMessage(String message) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(
        {
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "assistant", "content": message}
          ]
        },
      ),
    );

    if (response.statusCode == 200) {
      return ChatModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get response from ChatGPT API');
    }
  }
}
