import 'package:flutter/material.dart';

class SizedBoxName extends StatelessWidget {
  const SizedBoxName({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple], // Gradient colors
          begin: Alignment.topCenter, // Start from the top
          end: Alignment.bottomCenter, // End at the bottom
        ),
      ),
      child: const Center(
        child: Text(
          'Vertical Gradient',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
