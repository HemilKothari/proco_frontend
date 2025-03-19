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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Small Back Arrow at the Top Left
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Go back to previous page
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),

              // Title Text
              Text(
                "What should other\nProfessionals call you?",
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),

              // Custom Text Field
              TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 18.sp, color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Full Name",
                  hintStyle: TextStyle(color: Colors.white70, fontSize: 16),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Arrow Button
              Center(
                child: GestureDetector(
                    onTap: () {
                      if (nameController.text.isNotEmpty) {
                        Navigator.of(context)
                            .push(_createPageRoute(EmailPage()));
                      }
                    },
                    child: Container(
                      width: 50, // Adjust size as per design
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/Sign_in_circle.png', // Replace with your image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Page transition function
  Route _createPageRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 400), // Animation speed
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
