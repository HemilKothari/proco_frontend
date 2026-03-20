import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as https;
import 'package:jobhub_v1/models/request/chat/create_chat.dart';
import 'package:jobhub_v1/models/response/chat/get_chat.dart';
import 'package:jobhub_v1/models/response/chat/intitial_msg.dart';
import 'package:jobhub_v1/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHelper {
  static https.Client client = https.Client();

  /// ✅ Apply / Create Chat
  static Future<Map<String, dynamic>> apply(CreateChat model) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      'token': 'Bearer $token',
    };

    final url = Uri.http(Config.apiUrl, Config.chatsUrl);

    try {
      final response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(model.toJson()),
      );

      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        final chat = InitialChat.fromJson(decoded['data']);

        return {
          "success": true,
          "chatId": chat.id,
        };
      } else {
        return {
          "success": false,
          "message": decoded['message'] ?? "Failed to create chat",
        };
      }
    } catch (e) {
      debugPrint("Apply Chat Error: $e");
      return {
        "success": false,
        "message": "Something went wrong",
      };
    }
  }

  static Future<List<GetChats>> getConversations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final requestHeaders = <String, String>{
        'Content-Type': 'application/json',
        'token': 'Bearer $token',
      };

      final url = Uri.http(Config.apiUrl, Config.chatsUrl);

      final response = await client.get(
        url,
        headers: requestHeaders,
      );

      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        final List data = decoded['data'] ?? [];

        return data.map((e) => GetChats.fromJson(e)).toList();
      } else {
        throw Exception(decoded['message'] ?? "Couldn't load chats");
      }
    } catch (e, s) {
      debugPrint('ERROR: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }
}
