import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;
import 'package:jobhub_v1/models/error.dart';
import 'package:jobhub_v1/models/request/auth/login_model.dart';
import 'package:jobhub_v1/models/request/auth/profile_update_model.dart';
import 'package:jobhub_v1/models/request/auth/signup_model.dart';
import 'package:jobhub_v1/models/response/auth/login_res_model.dart';
import 'package:jobhub_v1/models/response/auth/profile_model.dart';
import 'package:jobhub_v1/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static https.Client client = https.Client();

  static Future<List<dynamic>> login(LoginModel model) async {
    ErrorRes? error;
    final requestHeaders = <String, String>{'Content-Type': 'application/json'};

    final url = Uri.http(Config.apiUrl, Config.loginUrl);
    final response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();

      final token = loginResponseModelFromJson(response.body).userToken;
      final userId = loginResponseModelFromJson(response.body).id;
      final profile = loginResponseModelFromJson(response.body).profile;

      await prefs.setString('token', token);
      await prefs.setString('userId', userId);
      await prefs.setString('profile', profile);

      return [true];
    } else if (response.statusCode == 401) {
      error = errorResFromJson(response.body);
      return [false, error.message];
    } else {
      error = errorResFromJson(response.body);
      return [false, error.message];
    }
  }

  static Future<List<dynamic>> signup(SignupModel model) async {
    ErrorRes? error;
    try {
      final requestHeaders = <String, String>{
        'Content-Type': 'application/json'
      };
      final url = Uri.http(Config.apiUrl, Config.signupUrl);
      debugPrint(jsonEncode(model));
      final response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(model),
      );

      if (response.statusCode == 201) {
        return [true];
      } else {
        error = errorResFromJson(response.body);
        return [false, error.message];
      }
    } catch (e) {
      return [false, e.toString()];
    }
  }

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
      return null;
    }

    final requestHeaders = <String, String>{
      'Content-Type': 'application/json',
      'token': 'Bearer $token',
    };

    final url = Uri.http(Config.apiUrl, Config.profileUrl);
    final response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final profile = profileResFromJson(response.body);
      return profile;
    } else {
      throw Exception('Failed to get the profile');
    }
  }
}
