/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/controllers/login_provider.dart';
import 'package:jobhub_v1/models/request/auth/login_model.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/custom_btn.dart';
import 'package:jobhub_v1/views/common/custom_textfield.dart';
import 'package:jobhub_v1/views/common/drawer/drawer_widget.dart';
import 'package:jobhub_v1/views/common/exports.dart';
import 'package:jobhub_v1/views/common/height_spacer.dart';
import 'package:jobhub_v1/views/ui/auth/signup.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required this.drawer, super.key});
  final bool drawer;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginNotifier>(
      builder: (context, loginNotifier, child) {
        loginNotifier.getPrefs();
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.065.sh),
            child: CustomAppBar(
              text: 'Login',
              child: widget.drawer == true
                  ? Padding(
                      padding: EdgeInsets.all(8.0.h),
                      child: const DrawerWidget(),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: loginNotifier.loginFormKey,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const HeightSpacer(size: 50),
                  ReusableText(
                    text: 'Welcome Back!',
                    style: appstyle(30, Color(kDark.value), FontWeight.w600),
                  ),
                  ReusableText(
                    text: 'Fill the details to login to your account',
                    style: appstyle(
                      16,
                      Color(kDarkGrey.value),
                      FontWeight.w600,
                    ),
                  ),
                  const HeightSpacer(size: 50),
                  CustomTextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Email',
                    validator: (email) {
                      if (email!.isEmpty || !email.contains('@')) {
                        return 'Please enter a valid email';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const HeightSpacer(size: 20),
                  CustomTextField(
                    controller: password,
                    keyboardType: TextInputType.text,
                    hintText: 'Password',
                    obscureText: loginNotifier.obscureText,
                    validator: (password) {
                      if (password!.isEmpty) {
                        return 'Please enter a valid password';
                      } else {
                        return null;
                      }
                    },
                    suffixIcon: GestureDetector(
                      onTap: () {
                        loginNotifier.obscureText = !loginNotifier.obscureText;
                      },
                      child: Icon(
                        loginNotifier.obscureText
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color(kDark.value),
                      ),
                    ),
                  ),
                  const HeightSpacer(size: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.offAll(() => const RegistrationPage());
                      },
                      child: ReusableText(
                        text: 'Register',
                        style: appstyle(
                          14,
                          Color(kDark.value),
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const HeightSpacer(size: 50),
                  CustomButton(
                    onTap: () {
                      if (loginNotifier.validateAndSave()) {
                        final model = LoginModel(
                          email: email.text,
                          password: password.text,
                        );

                        loginNotifier.userLogin(model);
                      } else {
                        Get.snackbar(
                          'Sign Failed',
                          'Please Check your credentials',
                          colorText: Color(kLight.value),
                          backgroundColor: const Color(0xFF040326),
                          icon: const Icon(Icons.add_alert),
                        );
                      }
                    },
                    text: 'Login',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/controllers/login_provider.dart';
import 'package:jobhub_v1/models/request/auth/login_model.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/custom_btn.dart';
import 'package:jobhub_v1/views/common/custom_textfield.dart';
import 'package:jobhub_v1/views/common/drawer/drawer_widget.dart';
import 'package:jobhub_v1/views/common/exports.dart';
import 'package:jobhub_v1/views/common/height_spacer.dart';
import 'package:jobhub_v1/views/ui/auth/signup.dart';
import 'package:jobhub_v1/views/ui/onboarding/firsttimeuser/input_name.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import the Input Name page

class LoginPage extends StatefulWidget {
  const LoginPage({required this.drawer, super.key});
  final bool drawer;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginNotifier>(
      builder: (context, loginNotifier, child) {
        loginNotifier.getPrefs();
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.065.sh),
            child: CustomAppBar(
              text: 'Login',
              child: widget.drawer == true
                  ? Padding(
                      padding: EdgeInsets.all(8.0.h),
                      child: const DrawerWidget(),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: loginNotifier.loginFormKey,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const HeightSpacer(size: 50),
                  ReusableText(
                    text: 'Welcome Back!',
                    style: appstyle(30, Color(kDark.value), FontWeight.w600),
                  ),
                  ReusableText(
                    text: 'Fill the details to login to your account',
                    style: appstyle(
                      16,
                      Color(kDarkGrey.value),
                      FontWeight.w600,
                    ),
                  ),
                  const HeightSpacer(size: 50),
                  CustomTextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Email',
                    validator: (email) {
                      if (email!.isEmpty || !email.contains('@')) {
                        return 'Please enter a valid email';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const HeightSpacer(size: 20),
                  CustomTextField(
                    controller: password,
                    keyboardType: TextInputType.text,
                    hintText: 'Password',
                    obscureText: loginNotifier.obscureText,
                    validator: (password) {
                      if (password!.isEmpty) {
                        return 'Please enter a valid password';
                      } else {
                        return null;
                      }
                    },
                    suffixIcon: GestureDetector(
                      onTap: () {
                        loginNotifier.obscureText = !loginNotifier.obscureText;
                      },
                      child: Icon(
                        loginNotifier.obscureText
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color(kDark.value),
                      ),
                    ),
                  ),
                  const HeightSpacer(size: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.offAll(() => const RegistrationPage());
                      },
                      child: ReusableText(
                        text: 'Register',
                        style: appstyle(
                          14,
                          Color(kDark.value),
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const HeightSpacer(size: 50),
                  CustomButton(
                    onTap: () async {
                      if (loginNotifier.validateAndSave()) {
                        final model = LoginModel(
                          email: email.text,
                          password: password.text,
                        );

                        await loginNotifier.userLogin(model);

                        // Check if the user is logging in for the first time
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        bool isFirstTimeUser =
                            prefs.getBool('isFirstTimeUser') ?? true;

                        if (isFirstTimeUser) {
                          // Update the flag to indicate the user is no longer a first-time user
                          await prefs.setBool('isFirstTimeUser', false);

                          // Redirect to the Input Name page (Page1)
                          Get.offAll(() => Page1());
                        } else {
                          // Show a login success notification
                          Get.snackbar(
                            'Login Successful',
                            'Welcome Back!',
                            colorText: Color(kLight.value),
                            backgroundColor: const Color(0xFF040326),
                            icon: const Icon(Icons.check_circle),
                          );
                        }
                      } else {
                        Get.snackbar(
                          'Sign Failed',
                          'Please Check your credentials',
                          colorText: Color(kLight.value),
                          backgroundColor: const Color(0xFF040326),
                          icon: const Icon(Icons.add_alert),
                        );
                      }
                    },
                    text: 'Login',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
