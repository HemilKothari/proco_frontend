import 'package:flutter/material.dart';
import 'package:jobhub_v1/views/ui/onboarding/firsttimeuser/input_email.dart';
import 'package:jobhub_v1/views/ui/onboarding/firsttimeuser/input_gender.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NamePage extends StatefulWidget {
  const NamePage({super.key});

  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Clean white background
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Text
            Text(
              "What should other\nProfessionals call you?",
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 50.h),

            // Custom Text Field
            TextField(
              controller: nameController,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 18.sp),
              decoration: InputDecoration(
                hintText: "Full Name",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
              ),
            ),
            SizedBox(height: 50.h),

            // Arrow Button
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  if (nameController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmailPage(),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
