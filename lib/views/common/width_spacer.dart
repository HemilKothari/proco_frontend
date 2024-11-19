import 'package:flutter/material.dart';

class WidthSpacer extends StatelessWidget {
  const WidthSpacer({required this.width, super.key});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
