import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as https;
import 'package:jobhub_v1/models/request/messaging/send_message.dart';
import 'package:jobhub_v1/models/response/messaging/messaging_res.dart';
import 'package:jobhub_v1/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MesssagingHelper {
  static https.Client client = https.Client();

  // Apply for job
  static Future<List<dynamic>> sendMessage(SendMessage model) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      'token': 'Bearer $token',
    };

    final url = Uri.http(Config.apiUrl, Config.messagingUrl);
    final response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      final message = ReceivedMessge.fromJson(jsonDecode(response.body));

      final Map<String, dynamic> responseMap = jsonDecode(response.body);
      return [true, message, responseMap];
    } else {
      return [false];
    }
  }

  // FIX: added try-catch
  static Future<List<ReceivedMessge>> getMessages(
    String chatId,
    int offset,
  ) async {
    try {
      debugPrint('----------FETCHING MESSAGES-------------');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final requestHeaders = <String, String>{
        'Content-Type': 'application/json',
        'token': 'Bearer $token',
      };

      final url = Uri.http(
        Config.apiUrl,
        '${Config.messagingUrl}/$chatId',
        {'page': offset.toString()},
      );
      final response = await client.get(
        url,
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        final messages = receivedMessgeFromJson(response.body);

        return messages;
      } else {
        throw Exception(' failed to load messages');
      }
    } catch (e, s) {
      debugPrint('Error Occurred: -------------- $e ---------------');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }
}
