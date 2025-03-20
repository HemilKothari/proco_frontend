import 'package:flutter/material.dart';
import 'package:jobhub_v1/views/ui/auth/signup_new.dart';
import 'package:jobhub_v1/views/ui/onboarding/firsttimeuser/input_name.dart';
import 'package:jobhub_v1/views/ui/onboarding/widgets/page_three.dart'; // Import PageThree

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040326),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "Welcome",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF08979F),
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              //SizedBox(height: 20),
              // Arrow Button
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(_createPageRoute(SignUpScreen()));
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

          // Small White Arrow at the Top-Right for Navigation to PageThree
          Positioned(
            top: 40, // Adjust vertical position
            left: 20, // Adjust horizontal position
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PageThree()), // Go to PageThree
                );
              },
              child: Icon(
                Icons.arrow_back_ios, // Small right arrow
                color: const Color(0xFF08979F),
                size: 20, // Small size for a subtle look
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Page transition function
  Route _createPageRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 400), // Animation speed
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Start from right
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
