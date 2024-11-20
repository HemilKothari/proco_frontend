import 'package:flutter/material.dart';
import 'package:jobhub_v1/views/common/exports.dart';

class HeadingWidget extends StatelessWidget {
  const HeadingWidget({required this.text, super.key, this.onTap});

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReusableText(
          text: text,
          style: appstyle(20, Color(kDark.value), FontWeight.w600),
        ),
        GestureDetector(
          onTap: onTap,
          child: ReusableText(
            text: 'View all',
            style: appstyle(18, Color(kOrange.value), FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
