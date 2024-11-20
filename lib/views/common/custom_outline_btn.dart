import 'package:flutter/material.dart';
import 'package:jobhub_v1/views/common/app_style.dart';
import 'package:jobhub_v1/views/common/reusable_text.dart';

class CustomOutlineBtn extends StatelessWidget {
  const CustomOutlineBtn({
    required this.text,
    required this.color,
    super.key,
    this.width,
    this.hieght,
    this.onTap,
    this.color2,
  });

  final double? width;
  final double? hieght;
  final String text;
  final void Function()? onTap;
  final Color color;
  final Color? color2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: hieght,
        decoration: BoxDecoration(
          color: color2,
          border: Border.all(color: color),
        ),
        child: Center(
          child: ReusableText(
            text: text,
            style: appstyle(16, color, FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
