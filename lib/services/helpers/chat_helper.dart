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

  // Apply for job
  static Future<List<dynamic>> apply(CreateChat model) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      'token': 'Bearer $token',
    };

    final url = Uri.http(Config.apiUrl, Config.chatsUrl);
    final response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      final first = initialChatFromJson(response.body).id;

      return [true, first];
    } else {
      return [false];
    }
  }
// FIX: added try-catch
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

     if (response.statusCode == 200) {
       final chats = getChatsFromJson(response.body);

       return chats;
     } else {
       throw Exception("Couldn't load chats");
     }
   } catch(e, s) {
     debugPrint('ERROR: $e');
     debugPrintStack(stackTrace: s);
     rethrow;
   }
  }
}
