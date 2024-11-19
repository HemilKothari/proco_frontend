import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/controllers/exports.dart';
import 'package:jobhub_v1/views/common/drawer/drawerScreen.dart';
import 'package:jobhub_v1/views/common/exports.dart';
import 'package:jobhub_v1/views/ui/auth/login.dart';
import 'package:jobhub_v1/views/ui/auth/profile.dart';
import 'package:jobhub_v1/views/ui/bookmarks/bookmarks.dart';
import 'package:jobhub_v1/views/ui/chat/chat_list.dart';
import 'package:jobhub_v1/views/ui/device_mgt/devices_info.dart';
import 'package:jobhub_v1/views/ui/homepage.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ZoomNotifier>(
      builder: (context, zoomNotifier, child) {
        return ZoomDrawer(
          menuScreen: DrawerScreen(
            indexSetter: (index) {
              zoomNotifier.currentIndex = index;
            },
          ),
          mainScreen: currentSreen(),
          borderRadius: 30,
          showShadow: true,
          angle: 0,
          slideWidth: 250,
          menuBackgroundColor: Color(kLightBlue.value),
        );
      },
    );
  }

  Widget currentSreen() {
    final zoomNotifier = Provider.of<ZoomNotifier>(context);
    final loginNotifier = Provider.of<LoginNotifier>(context);
    loginNotifier.getPrefs();
    switch (zoomNotifier.currentIndex) {
      case 0:
        return const HomePage();
      case 1:
        return loginNotifier.loggedIn
            ? const ChatsList()
            : const LoginPage(
                drawer: false,
              );
      case 2:
        return loginNotifier.loggedIn
            ? const BookMarkPage()
            : const LoginPage(
                drawer: false,
              );
      case 3:
        return loginNotifier.loggedIn
            ? const DeviceManagement()
            : const LoginPage(
                drawer: false,
              );
      case 4:
        return loginNotifier.loggedIn
            ? const ProfilePage()
            : const LoginPage(
                drawer: false,
              );
      default:
        return const HomePage();
    }
  }
}
