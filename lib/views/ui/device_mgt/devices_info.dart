import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub_v1/controllers/exports.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/drawer/drawer_widget.dart';
import 'package:jobhub_v1/views/common/exports.dart';
import 'package:jobhub_v1/views/common/height_spacer.dart';
import 'package:jobhub_v1/views/ui/device_mgt/widgets/device_info.dart';
import 'package:provider/provider.dart';

class DeviceManagement extends StatefulWidget {
  const DeviceManagement({super.key});

  @override
  State<DeviceManagement> createState() => _DeviceManagementState();
}

class _DeviceManagementState extends State<DeviceManagement> {
  @override
  void initState() {
    super.initState();
    // ✅ Load sessions when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginNotifier>().loadDeviceSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final zoomNotifier = Provider.of<ZoomNotifier>(context);
    final onBoarding = Provider.of<OnBoardNotifier>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.065.sh),
        child: CustomAppBar(
          text: 'Device Management',
          child: Padding(
            padding: EdgeInsets.only(left: 0.010.sh),
            child: const DrawerWidget(),
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<LoginNotifier>(
          builder: (context, loginNotifier, child) {
            final sessions = loginNotifier.deviceSessions;

            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeightSpacer(size: 50),
                      Text(
                        'You are logged in into your account on these devices',
                        style:
                            appstyle(16, Color(kDark.value), FontWeight.normal),
                      ),
                      const HeightSpacer(size: 30),
                      if (sessions.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40.h),
                            child: Text(
                              'No device sessions found',
                              style: appstyle(
                                  16, Color(kDarkGrey.value), FontWeight.w400),
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.separated(
                            itemCount: sessions.length,
                            separatorBuilder: (_, __) =>
                                const HeightSpacer(size: 30),
                            itemBuilder: (context, index) {
                              final session = sessions[index];
                              return DevicesInfo(
                                date: session.date,
                                device: session.device,
                                platform: session.platform,
                                onSignOut: () async {
                                  await loginNotifier
                                      .removeDeviceSession(index);
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),

                // ✅ Sign out from ALL devices
                Padding(
                  padding: EdgeInsets.all(8.0.h),
                  child: GestureDetector(
                    onTap: () {
                      zoomNotifier.currentIndex = 0;
                      onBoarding.isLastPage = false;
                      loginNotifier.logout(); // ✅ always goes to LoginPage now
                    },
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ReusableText(
                        text: 'Sign out from all devices',
                        style: appstyle(
                          16,
                          Color(kOrange.value),
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
