import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

/*class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ZoomDrawer.of(context)!.toggle();
      },
      child: Image.asset(
        'assets/images/Vector.png',
        width: 200.w, // Increase width
        height: 60.h,
      ),
    );
  }
}
*/
/*class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero, // Remove padding
      width: 80, // Explicit container size
      height: 80,
      child: GestureDetector(
        onTap: () {
          ZoomDrawer.of(context)!.toggle();
        },
        child: Image.asset(
          'assets/images/Vector.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}*/

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.zero,
          width: 140, // Much larger container
          height: 140, // Much larger container
          child: GestureDetector(
            behavior: HitTestBehavior.translucent, // Ensures tap works properly
            onTap: () {
              ZoomDrawer.of(context)!.toggle();
            },
            child: Center(
              child: Image.asset(
                'assets/images/Vector.png',
                width: 140, // Slightly smaller than container
                height: 140,
                fit: BoxFit.contain, // Ensures full image is visible
              ),
            ),
          ),
        );
      },
    );
  }
}
