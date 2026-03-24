import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as https;
import 'package:jobhub_v1/models/request/bookmarks/bookmarks_model.dart';
import 'package:jobhub_v1/models/response/bookmarks/all_bookmarks.dart';
import 'package:jobhub_v1/models/response/bookmarks/book_res.dart';
import 'package:jobhub_v1/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookMarkHelper {
  static https.Client client = https.Client();

  /// ================= ADD BOOKMARK =================
  static Future<Map<String, dynamic>> addBookmarks(
      BookmarkReqResModel model) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {"success": false, "message": "User not authenticated"};
      }

      final requestHeaders = <String, String>{
        'Content-Type': 'application/json',
        'token': 'Bearer $token',
      };

      final url = Uri.https(Config.apiUrl, Config.bookmarkUrl);

      final response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(model.toJson()),
      );

      debugPrint("ADD BOOKMARK RESPONSE: ${response.body}");

      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        final bookmark = bookMarkReqResFromJson(decoded['data']);

        return {
          "success": true,
          "bookmarkId": bookmark.id,
        };
      } else {
        return {
          "success": false,
          "message": decoded['message'] ?? "Failed to add bookmark",
        };
      }
    } catch (e) {
      debugPrint("Add Bookmark Error: $e");
      return {
        "success": false,
        "message": "Something went wrong",
      };
    }
  }

  /// ================= DELETE BOOKMARK =================
  static Future<bool> deleteBookmarks(String jobId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) return false;

      final requestHeaders = <String, String>{
        'Content-Type': 'application/json',
        'token': 'Bearer $token',
      };

      final url = Uri.https(Config.apiUrl, '${Config.bookmarkUrl}/$jobId');

      final response = await client.delete(
        url,
        headers: requestHeaders,
      );

      debugPrint("DELETE BOOKMARK RESPONSE: ${response.body}");

      final decoded = json.decode(response.body);

      return response.statusCode == 200 && decoded['success'] == true;
    } catch (e) {
      debugPrint("Delete Bookmark Error: $e");
      return false;
    }
  }

  /// ================= GET ALL BOOKMARKS =================
  static Future<List<AllBookmark>> getBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception("User not authenticated");
      }

      final requestHeaders = <String, String>{
        'Content-Type': 'application/json',
        'token': 'Bearer $token',
      };

      final url = Uri.https(Config.apiUrl, Config.bookmarkUrl);

      final response = await client.get(
        url,
        headers: requestHeaders,
      );

      debugPrint("GET BOOKMARKS RESPONSE: ${response.body}");

      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        final List data = decoded['data'] ?? [];

        return data
            .map((e) => AllBookmark.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(decoded['message'] ?? "Failed to load bookmarks");
      }
    } catch (e) {
      debugPrint("Get Bookmarks Error: $e");
      rethrow;
    }
  }
}
