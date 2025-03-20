import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final drawer = ZoomDrawer.of(context);
        if (drawer != null) {
          drawer.toggle();
        } else {
          debugPrint(
              "Error: ZoomDrawer is null. Ensure it's wrapped properly.");
        }
      },
      child: Image.asset(
        'assets/images/Vector.png',
        width: 200.w,
        height: 30.h,
      ),
    );
  }
}
