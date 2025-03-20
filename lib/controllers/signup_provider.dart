import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/models/request/auth/signup_model.dart';
import 'package:jobhub_v1/services/helpers/auth_helper.dart';
import 'package:jobhub_v1/views/ui/auth/login.dart';

class SignUpNotifier extends ChangeNotifier {
  final SignupModel signupModel = SignupModel();

  /// Step index (for multi-step navigation)
  int _activeIndex = 0;
  int get activeIndex => _activeIndex;

  set activeIndex(int index) {
    if (_activeIndex != index) {
      _activeIndex = index;
      notifyListeners(); // Notify UI only if index actually changes
    }
  }

  void changeStep(int index) {
    activeIndex = index; // Use the setter
  }

  /// Password visibility toggle
  bool _obscureText = true;
  bool get obscureText => _obscureText;

  set obscureText(bool newState) {
    if (_obscureText != newState) {
      _obscureText = newState;
      notifyListeners(); // Only notify if there's an actual change
    }
  }

  /// Password validation
  bool passwordValidator(String password) {
    if (password.isEmpty) return false;
    const pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  /// Form submission
  void submitSignup() {
    if (signupModel.username.isEmpty ||
        signupModel.email.isEmpty ||
        signupModel.password.isEmpty ||
        signupModel.college.isEmpty ||
        signupModel.branch.isEmpty ||
        signupModel.gender.isEmpty ||
        signupModel.city.isEmpty ||
        signupModel.state.isEmpty ||
        signupModel.country.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    AuthHelper.signup(signupModel).then((response) {
      if (response[0]) {
        Get.offAll(
          () => const LoginPage(drawer: true),
          transition: Transition.fade,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Sign Up Failed',
          response[1],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    });
  }
}
