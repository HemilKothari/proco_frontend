import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;
import 'package:jobhub_v1/models/request/auth/profile_update_model.dart';
import 'package:jobhub_v1/models/response/auth/profile_model.dart';
import 'package:jobhub_v1/models/response/jobs/swipe_res_model.dart';
import 'package:jobhub_v1/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHelper {
  static https.Client client = https.Client();

  static Future<bool> updateProfile(
    ProfileUpdateReq model,
    File? image,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.http(Config.apiUrl, Config.profileUrl);

    var request = https.MultipartRequest('PUT', url);

    request.headers['token'] = 'Bearer $token';

    // ✅ Add text fields
    request.fields['city'] = model.city ?? '';
    request.fields['state'] = model.state ?? '';
    request.fields['country'] = model.country ?? '';
    request.fields['phone'] = model.phone ?? '';
    request.fields['college'] = model.college ?? '';
    request.fields['branch'] = model.branch ?? '';
    request.fields['gender'] = model.gender ?? '';

    // if skills is list
    request.fields['skills'] = jsonEncode(model.skills);

    // ✅ Add image file
    if (image != null) {
      request.files.add(
        await https.MultipartFile.fromPath(
          'profile', // MUST match backend multer field
          image.path,
        ),
      );
    }

    final response = await request.send();

    return response.statusCode == 200;
  }

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
