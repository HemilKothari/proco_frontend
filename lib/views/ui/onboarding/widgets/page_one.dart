/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/views/common/app_style.dart';
import 'package:jobhub_v1/views/common/height_spacer.dart';
import 'package:jobhub_v1/views/common/reusable_text.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: width,
        height: hieght,
        color: Color(kDarkPurple.value),
        child: Column(
          children: [
            const HeightSpacer(
              size: 70,
            ),
            Image.asset('assets/images/page1.png'),
            const HeightSpacer(size: 40),
            Column(
              children: [
                ReusableText(
                  text: 'Find Your Dream Job',
                  style: appstyle(30, Color(kLight.value), FontWeight.w500),
                ),
                const HeightSpacer(size: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                  child: Text(
                    'We help you find your dream job according to your skillset, location and preference to build your career',
                    textAlign: TextAlign.center,
                    style: appstyle(14, Color(kLight.value), FontWeight.normal),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/views/common/app_style.dart';
import 'package:jobhub_v1/views/common/height_spacer.dart';
import 'package:jobhub_v1/views/common/reusable_text.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: width,
        height: hieght,
        color: const Color(0xFF040326), // Updated background color
        child: Column(
          children: [
            const HeightSpacer(
              size: 205,
            ),
            Image.asset('assets/images/Vector.png'),
            const HeightSpacer(
              size: 30,
            ),
            // Added Spacer to push the text to the bottom
            //const Spacer(flex: 1),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Connecting The Right People\nAt The Right Time',
                  textAlign: TextAlign.center, // Center aligns the text
                  style: TextStyle(
                    fontFamily: 'Poppins', // Custom font
                    fontSize: 18.sp, // Responsive font size
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF08959D), // Text color
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1),
            const HeightSpacer(size: 40), // Bottom padding
          ],
        ),
      ),
    );
  }
}
