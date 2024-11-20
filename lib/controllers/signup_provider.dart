import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proco/constants/app_constants.dart';
import 'package:proco/models/request/auth/signup_model.dart';
import 'package:proco/services/helpers/auth_helper.dart';
import 'package:proco/views/common/exports.dart';
import 'package:proco/views/ui/auth/login.dart';

class SignUpNotifier extends ChangeNotifier {
  bool _obscureText = true;

  bool get obscureText => _obscureText;

  set obscureText(bool newState) {
    _obscureText = newState;
    notifyListeners();
  }

  bool passwordValidator(String password) {
    if (password.isEmpty) return false;
    const pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  final signupFormKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = signupFormKey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  upSignup(SignupModel model) {
    AuthHelper.signup(model).then((response) {
      if (response[0]) {
        Get.offAll(
          () => const LoginPage(drawer: true),
          transition: Transition.fade,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Sign up Failed',
          response[1],
          colorText: Color(kLight.value),
          backgroundColor: Colors.red,
          icon: const Icon(Icons.add_alert),
        );
      }
    });
  }
}
