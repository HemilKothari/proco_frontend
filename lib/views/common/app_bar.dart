import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/views/common/app_style.dart';
import 'package:jobhub_v1/views/common/reusable_text.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    required this.child,
    super.key,
    this.text,
    this.actions,
    this.drawer,
  });

  final String? text;
  final Widget child;
  final List<Widget>? actions;
  final bool? drawer;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(),
      backgroundColor: Color(kLight.value),
      elevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: 70.w,
      leading: child,
      actions: actions,
      centerTitle: true,
      title: ReusableText(
        text: text ?? '',
        style: appstyle(16, Color(kDark.value), FontWeight.w600),
      ),
    );
  }
}
