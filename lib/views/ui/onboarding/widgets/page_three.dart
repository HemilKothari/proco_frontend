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
        color: Color(kLightBlue.value),
        child: Column(
          children: [
            Image.asset(
              'assets/images/page3.png',
              height: 500,
            ),
            const HeightSpacer(size: 20),
            ReusableText(
              text: 'Welcome To JobHub',
              style: appstyle(30, Color(kLight.value), FontWeight.w600),
            ),
            const HeightSpacer(size: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Text(
                'We help you find your dream job to your skillset, location and preference to build your career',
                textAlign: TextAlign.center,
                style: appstyle(14, Color(kLight.value), FontWeight.normal),
              ),
            ),
            const HeightSpacer(size: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomOutlineBtn(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();

                    await prefs.setBool('entrypoint', true);

                    await Get.to(
                      () => const LoginPage(
                        drawer: true,
                      ),
                    );
                  },
                  text: 'Login',
                  width: width * 0.4,
                  hieght: hieght * 0.06,
                  color: Color(kLight.value),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const RegistrationPage());
                  },
                  child: Container(
                    width: width * 0.4,
                    height: hieght * 0.06,
                    color: Color(kLight.value),
                    child: Center(
                      child: ReusableText(
                        text: 'Sign Up',
                        style: appstyle(
                          16,
                          Color(kLightBlue.value),
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const HeightSpacer(size: 30),
            GestureDetector(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();

                await prefs.setBool('entrypoint', true);

                await Get.to(() => const MainScreen());
              },
              child: ReusableText(
                text: 'Continue as guest',
                style: appstyle(16, Color(kLight.value), FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
