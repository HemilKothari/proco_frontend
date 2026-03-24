import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;
import 'package:jobhub_v1/models/request/auth/login_model.dart';
import 'package:jobhub_v1/models/request/auth/signup_model.dart';
import 'package:jobhub_v1/models/response/auth/login_res_model.dart';
import 'package:jobhub_v1/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static https.Client client = https.Client();

  static Future<List<dynamic>> login(LoginModel model) async {
    final requestHeaders = <String, String>{'Content-Type': 'application/json'};
    final url = Uri.https(Config.apiUrl, Config.loginUrl);

    final response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model),
    );

    debugPrint('Login Response: ${response.body}');

    // ✅ Guard against empty body (Render cold start)
    if (response.body.isEmpty) {
      return [false, 'Server is starting up, please try again'];
    }

    // ✅ Parse once, read fields directly — no ErrorRes model needed
    final Map<String, dynamic> body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final loginRes = loginResponseModelFromJson(response.body);

      await prefs.setString('token', loginRes.userToken);
      await prefs.setString('userId', loginRes.id);
      await prefs.setString('profile', loginRes.profile);

      return [true];
    } else {
      // ✅ Server always sends { success: false, message: "..." }
      final message = body['message'] as String? ?? 'An error occurred';
      return [false, message];
    }
  }

  static Future<List<dynamic>> signup(SignupModel model) async {
    try {
      final requestHeaders = <String, String>{
        'Content-Type': 'application/json'
      };
      final url = Uri.https(Config.apiUrl, Config.signupUrl);

      debugPrint(jsonEncode(model));

      final response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(model),
      );

      if (response.body.isEmpty) {
        return [false, 'Server is starting up, please try again'];
      }

      if (response.statusCode == 201) {
        return [true];
      } else {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final message = body['message'] as String? ?? 'An error occurred';
        return [false, message];
      }
    } catch (e) {
      return [false, e.toString()];
    }
  }
}
