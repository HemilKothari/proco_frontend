import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;
import 'package:jobhub_v1/models/request/auth/profile_update_model.dart';
import 'package:jobhub_v1/models/response/auth/profile_model.dart';
import 'package:jobhub_v1/models/response/jobs/swipe_res_model.dart';
import 'package:jobhub_v1/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHelper {
  static https.Client client = https.Client();

  static Future<bool> updateProfile(ProfileUpdateReq model) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      'token': 'Bearer $token',
    };

    final url = Uri.http(Config.apiUrl, Config.profileUrl);
    final response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Fix: Pushes to the Personal Details even after filling it first time.
  // To replicate, sign up, fill in personal details after login, logout and
  // try logging in again, it'll still ask you to fill personal details
  static Future<ProfileRes?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint("Token Missing");
      return null;
    }

    final requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      'token': 'Bearer $token',
    };

    final url = Uri.http(Config.apiUrl, '/api/users');
    final response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final profile = profileResFromJson(response.body);
      return profile;
    } else {
      debugPrint(
          'Failed to load user profiles: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to get the profile [${response.statusCode}]');
    }
  }

  static Future<List<SwipedRes>> getUserProfiles(String agentId) async {
    final requestHeaders = {'Content-Type': 'application/json'};
    final url = Uri.http(Config.apiUrl, '${Config.profileUrl}/$agentId');

    final response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      if (data.isEmpty) {
        debugPrint('No users found for agent: $agentId');
      }

      return data.map((user) => SwipedRes.fromJson(user)).toList();
    } else {
      debugPrint('Failed to load user profiles: ${response.statusCode}');
      throw Exception('Failed to load user profiles');
    }
  }
}
