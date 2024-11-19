import 'package:flutter/material.dart';

class ReusableText extends StatelessWidget {
  const ReusableText({required this.text, required this.style, super.key});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      softWrap: false,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }
}
