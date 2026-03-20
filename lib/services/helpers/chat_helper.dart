import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as https;
import 'package:jobhub_v1/models/request/chat/create_chat.dart';
import 'package:jobhub_v1/models/response/chat/get_chat.dart';
import 'package:jobhub_v1/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHelper {
  static https.Client client = https.Client();

  /// ================= CREATE CHAT =================
  static Future<Map<String, dynamic>> createChat(CreateChat model) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {
          "success": false,
          "message": "User not authenticated",
        };
      }

      final url = Uri.http(Config.apiUrl, Config.chatsUrl);

      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': 'Bearer $token',
        },
        body: jsonEncode(model.toJson()),
      );

      debugPrint("CREATE CHAT RESPONSE: ${response.body}");

      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        return {
          "success": true,
          "chatId": decoded['data']?['_id'] ?? '',
        };
      } else {
        return {
          "success": false,
          "message": decoded['message'] ?? "Failed to create chat",
        };
      }
    } catch (e) {
      debugPrint("Create Chat Error: $e");
      return {
        "success": false,
        "message": "Something went wrong",
      };
    }
  }

  /// ================= GET CONVERSATIONS =================
  static Future<List<GetChats>> getConversations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception("User not authenticated");
      }

      final url = Uri.http(Config.apiUrl, Config.chatsUrl);

      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': 'Bearer $token',
        },
      );

      debugPrint("GET CHATS RESPONSE: ${response.body}");

      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        final List data = decoded['data'] ?? [];

        return data
            .map((e) => GetChats.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(decoded['message'] ?? "Couldn't load chats");
      }
    } catch (e, s) {
      debugPrint('GET CHATS ERROR: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }
}
