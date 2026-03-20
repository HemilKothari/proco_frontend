import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/models/request/auth/login_model.dart';
import 'package:jobhub_v1/services/helpers/auth_helper.dart';
import 'package:jobhub_v1/views/ui/auth/login.dart';
import 'package:jobhub_v1/views/ui/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Simple model to hold one device session
class DeviceSession {
  final String device;
  final String platform;
  final String date;

  DeviceSession({
    required this.device,
    required this.platform,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'device': device,
        'platform': platform,
        'date': date,
      };

  factory DeviceSession.fromJson(Map<String, dynamic> json) => DeviceSession(
        device: json['device'] ?? 'Unknown Device',
        platform: json['platform'] ?? 'Unknown Platform',
        date: json['date'] ?? '',
      );
}

class LoginNotifier extends ChangeNotifier {
  bool _obscureText = true;
  bool get obscureText => _obscureText;
  set obscureText(bool newState) {
    _obscureText = newState;
    notifyListeners();
  }

  bool _firstTime = true;
  bool get firstTime => _firstTime;
  set firstTime(bool newState) {
    _firstTime = newState;
    notifyListeners();
  }

  bool? _entrypoint;
  bool get entrypoint => _entrypoint ?? false;
  set entrypoint(bool newState) {
    _entrypoint = newState;
    notifyListeners();
  }

  bool? _loggedIn;
  bool get loggedIn => _loggedIn ?? false;
  set loggedIn(bool newState) {
    _loggedIn = newState;
    notifyListeners();
  }

  // ✅ Holds the list of stored device sessions
  List<DeviceSession> _deviceSessions = [];
  List<DeviceSession> get deviceSessions => _deviceSessions;

  getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    entrypoint = prefs.getBool('entrypoint') ?? false;
    final token = prefs.getString('token');
    loggedIn = token != null;
    await loadDeviceSessions();
  }

  final loginFormKey = GlobalKey<FormState>();
  final profileFormKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = loginFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool profileValidation() {
    final form = profileFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> userLogin(LoginModel model) async {
    await AuthHelper.login(model).then((response) async {
      if (response[0]) {
        // ✅ Save this device session on successful login
        await saveDeviceSession();

        Get.snackbar(
          'Login Success',
          'Enjoy your search for a job',
          colorText: Color(kLight.value),
          backgroundColor: Color(kLightBlue.value),
          icon: const Icon(Icons.add_alert),
        );

        await Future.delayed(const Duration(seconds: 1));
        Get.offAll(() => const MainScreen());
      } else {
        Get.snackbar(
          response[1],
          'Please try again',
          colorText: Color(kLight.value),
          backgroundColor: Color(kOrange.value),
          icon: const Icon(Icons.add_alert),
        );
      }
    });
  }

  // ✅ Reads real device info and saves the session to SharedPreferences
  Future<void> saveDeviceSession() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      String deviceName = 'Unknown Device';
      String platformName = 'Unknown Platform';

      if (GetPlatform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        deviceName = '${info.manufacturer} ${info.model}';
        platformName = 'Android ${info.version.release}';
      } else if (GetPlatform.isIOS) {
        final info = await deviceInfo.iosInfo;
        deviceName = info.name;
        platformName = '${info.systemName} ${info.systemVersion}';
      } else if (GetPlatform.isWeb) {
        final info = await deviceInfo.webBrowserInfo;
        deviceName = info.browserName.name;
        platformName = 'Web';
      }

      final date = DateTime.now().toString().substring(0, 10);

      final session = DeviceSession(
        device: deviceName,
        platform: platformName,
        date: date,
      );

      final prefs = await SharedPreferences.getInstance();
      final existing = prefs.getStringList('device_sessions') ?? [];

      // ✅ Avoid duplicate entries for same device on same day
      final alreadyExists = existing.any((e) {
        final decoded = DeviceSession.fromJson(jsonDecode(e));
        return decoded.device == session.device && decoded.date == session.date;
      });

      if (!alreadyExists) {
        existing.add(jsonEncode(session.toJson()));
        await prefs.setStringList('device_sessions', existing);
      }

      await loadDeviceSessions();
    } catch (e) {
      debugPrint('Error saving device session: $e');
    }
  }

  // ✅ Loads stored sessions from SharedPreferences into the list
  Future<void> loadDeviceSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getStringList('device_sessions') ?? [];
      _deviceSessions = stored
          .map((e) => DeviceSession.fromJson(jsonDecode(e)))
          .toList()
          .reversed
          .toList(); // newest first
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading device sessions: $e');
    }
  }

  // ✅ Removes a single device session by index
  Future<void> removeDeviceSession(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getStringList('device_sessions') ?? [];

      // _deviceSessions is reversed, so map back to original index
      final originalIndex = stored.length - 1 - index;
      if (originalIndex >= 0 && originalIndex < stored.length) {
        stored.removeAt(originalIndex);
        await prefs.setStringList('device_sessions', stored);
        await loadDeviceSessions();
      }
    } catch (e) {
      debugPrint('Error removing device session: $e');
    }
  }

  // ✅ Clears all sessions and always navigates to LoginPage (never defaultHome)
  logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    await prefs.setBool('entrypoint',
        false); // ✅ reset entrypoint so main.dart doesn't go to MainScreen
    await prefs.remove('token');
    await prefs.remove('profile');
    await prefs.remove('userId');
    await prefs.remove(
        'device_sessions'); // ✅ clear all device sessions on full logout

    _deviceSessions = [];
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    // ✅ Always go to LoginPage directly, never defaultHome
    Get.offAll(() => LoginPage(drawer: true));
  }
}
