import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/views/common/custom_outline_btn.dart';
import 'package:jobhub_v1/views/common/exports.dart';
import 'package:jobhub_v1/views/common/height_spacer.dart';
import 'package:jobhub_v1/views/ui/auth/login.dart';
import 'package:jobhub_v1/views/ui/auth/signup.dart';
import 'package:jobhub_v1/views/ui/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: width,
        height: hieght,
        color: const Color(0xFF040326),
        child: Stack(
          children: [
            // Existing layout (background image placement remains unchanged)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const HeightSpacer(size: 120),
                Image.asset(
                  'assets/images/grouped.png',
                  height: 500,
                ),
              ],
            ),
            // Overlay the buttons on top of the image
            Positioned(
              top:
                  340, // Adjust the top value to position the buttons over the image
              left: 0,
              right: 0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('entrypoint', true);
                      await Get.to(
                        () => const LoginPage(
                          drawer: true,
                        ),
                      );
                    },
                    child: Container(
                      width: width * 0.67, // Increased width for a longer box
                      height: hieght * 0.06, // Slightly taller height
                      decoration: BoxDecoration(
                        color: Color(kLight.value),
                        borderRadius:
                            BorderRadius.circular(28), // More curved edges
                      ),
                      child: Center(
                        child: ReusableText(
                          text: 'Login',
                          style: appstyle(
                            18, // Slightly larger text size
                            Color(0xFF040326),
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const RegistrationPage());
                    },
                    child: Container(
                      width: width * 0.67, // Increased width for a longer box
                      height: hieght * 0.06, // Slightly taller height
                      decoration: BoxDecoration(
                        color: Color(kLight.value),
                        borderRadius:
                            BorderRadius.circular(28), // More curved edges
                      ),
                      child: Center(
                        child: ReusableText(
                          text: 'Sign Up',
                          style: appstyle(
                            18, // Slightly larger text size
                            Color(0xFF040326),
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}