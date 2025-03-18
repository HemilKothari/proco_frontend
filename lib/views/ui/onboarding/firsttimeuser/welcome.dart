import 'package:flutter/material.dart';
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
      backgroundColor: const Color(0xFF001F3F),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NamePage()),
                    );
                  },
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
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
                Icons.arrow_forward_ios, // Small right arrow
                color: Colors.white,
                size: 20, // Small size for a subtle look
              ),
            ),
          ),
        ],
      ),
    );
  }
}
