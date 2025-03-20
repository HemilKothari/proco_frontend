import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/controllers/login_provider.dart';
import 'package:jobhub_v1/models/request/auth/login_model.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/custom_btn.dart';
import 'package:jobhub_v1/views/common/custom_textfield.dart';
import 'package:jobhub_v1/views/common/custom_textfield_input.dart';
import 'package:jobhub_v1/views/common/drawer/drawer_widget.dart';
import 'package:jobhub_v1/views/common/exports.dart';
import 'package:jobhub_v1/views/common/height_spacer.dart';
import 'package:jobhub_v1/views/ui/auth/signup.dart';
import 'package:jobhub_v1/views/ui/auth/signup_new.dart';
import 'package:jobhub_v1/views/ui/homepage.dart';
import 'package:jobhub_v1/views/ui/onboarding/firsttimeuser/input_name.dart';
import 'package:jobhub_v1/views/ui/onboarding/firsttimeuser/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

/*class LoginPage extends StatefulWidget {
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
// Add this import

/*class LoginPage extends StatefulWidget {
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

  Future<void> _handleLogin(LoginNotifier loginNotifier) async {
    if (loginNotifier.validateAndSave()) {
      final model = LoginModel(
        email: email.text,
        password: password.text,
      );

      loginNotifier.userLogin(model);

      // Check if the user is logging in for the first time
      final prefs = await SharedPreferences.getInstance();
      bool isFirstLogin = prefs.getBool('isFirstLogin') ?? true;

      if (isFirstLogin) {
        // Mark the first login as completed
        await prefs.setBool('isFirstLogin', false);

        // Navigate to NameInputPage
        //Get.offAll(() => NameInputPage());
      } else {
        // Navigate to the main app or desired screen for returning users
        Get.offAll(() => HomePage()); // Replace with your main app page
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
                    onTap: () => _handleLogin(loginNotifier),
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
*/
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

  Future<void> _handleLogin(LoginNotifier loginNotifier) async {
    if (loginNotifier.validateAndSave()) {
      final model = LoginModel(
        email: email.text,
        password: password.text,
      );

      // Call login function without expecting a return value
      await loginNotifier.userLogin(model);

      final prefs = await SharedPreferences.getInstance();
    }
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
              child: widget.drawer
                  ? Padding(
                      padding: EdgeInsets.all(8.0.h),
                      child: const DrawerWidget(),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          backgroundColor: const Color(0xFF040326),
          body: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF08979F), const Color(0xFF040326)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: loginNotifier.loginFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: 'Welcome Back!',
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    ReusableText(
                      text: 'Fill the details to \nlogin to your account',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const HeightSpacer(size: 20),
                    CustomTextFieldInput(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'Email',
                      validator: (email) {
                        if (email!.isEmpty || !email.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const HeightSpacer(size: 20),
                    CustomTextFieldInput(
                      controller: password,
                      keyboardType: TextInputType.text,
                      hintText: 'Password',
                      obscureText: loginNotifier.obscureText,
                      validator: (password) {
                        if (password!.isEmpty) {
                          return 'Please enter a valid password';
                        }
                        return null;
                      },
                      suffixIcon: GestureDetector(
                        onTap: () {
                          loginNotifier.obscureText =
                              !loginNotifier.obscureText;
                        },
                        child: Icon(
                          loginNotifier.obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const HeightSpacer(size: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.offAll(() => WelcomePage());
                        },
                        child: ReusableText(
                          text: 'Register',
                          style: appstyle(14, Colors.white, FontWeight.w500),
                        ),
                      ),
                    ),
                    const HeightSpacer(size: 20),
                    Center(
                      child: GestureDetector(
                          onTap: () {
                            _handleLogin(loginNotifier);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width *
                                0.4, // 60% of screen width
                            height: MediaQuery.of(context).size.height *
                                0.06, // 6% of screen height
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(
                                    0xFF040326), // 👈 Black text for contrast
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
