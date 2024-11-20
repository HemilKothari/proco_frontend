import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:proco/constants/app_constants.dart';
import 'package:proco/controllers/exports.dart';
import 'package:proco/views/common/drawer/drawerScreen.dart';
import 'package:proco/views/common/exports.dart';
import 'package:proco/views/ui/auth/login.dart';
import 'package:proco/views/ui/auth/profile.dart';
import 'package:proco/views/ui/bookmarks/bookmarks.dart';
import 'package:proco/views/ui/chat/chat_list.dart';
import 'package:proco/views/ui/device_mgt/devices_info.dart';
import 'package:proco/views/ui/homepage.dart';
import 'package:proco/views/ui/jobs/add_job.dart';
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
            ? const AddJobPage()
            : const LoginPage(
                drawer: false,
              );
      case 5:
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
