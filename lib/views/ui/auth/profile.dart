import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/controllers/profile_provider.dart';
import 'package:jobhub_v1/models/response/auth/profile_model.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/drawer/drawer_widget.dart';
import 'package:jobhub_v1/views/common/exports.dart';
import 'package:jobhub_v1/views/common/height_spacer.dart';
import 'package:jobhub_v1/views/common/width_spacer.dart';
import 'package:jobhub_v1/views/ui/auth/profile_update.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProfileNotifier>().getProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.065.sh),
        child: CustomAppBar(
          text: 'Profile',
          child: Padding(
            padding: EdgeInsets.only(left: 0.010.sh),
            child: const DrawerWidget(),
          ),
        ),
      ),
      body: Consumer<ProfileNotifier>(
        builder: (context, profileNotifier, child) {
          // profileNotifier.getProfile();
          return FutureBuilder<ProfileRes?>(
            future: profileNotifier.profile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error ${snapshot.error}');
              } else {
                final userData = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        width: width,
                        height: hieght * 0.12,
                        color: Color(kLight.value),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  child: userData!.profile == "null"
                                      ? Image.asset(
                                          'assets/images/user.png',
                                        )
                                      : CachedNetworkImage(
                                          width: 80.w,
                                          height: 100.h,
                                          imageUrl: userData.profile,
                                        ),
                                ),
                                const WidthSpacer(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ReusableText(
                                      text: userData.username,
                                      style: appstyle(
                                        20,
                                        Color(kDark.value),
                                        FontWeight.w600,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          MaterialIcons.location_pin,
                                          color: Color(kDarkGrey.value),
                                        ),
                                        const WidthSpacer(width: 5),
                                        ReusableText(
                                          text: userData.location,
                                          style: appstyle(
                                            16,
                                            Color(kDarkGrey.value),
                                            FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                profile = userData.skills;
                                Get.to(() => const ProfileUpdate());
                              },
                              child: const Icon(
                                Feather.edit,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const HeightSpacer(size: 20),
                      Container(
                        padding: EdgeInsets.only(left: 8.w),
                        width: width,
                        height: hieght * 0.06,
                        color: Color(kLightGrey.value),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ReusableText(
                            text: userData.email,
                            style: appstyle(
                              16,
                              Color(kDark.value),
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const HeightSpacer(size: 20),
                      Container(
                        padding: EdgeInsets.only(left: 8.w),
                        width: width,
                        height: hieght * 0.06,
                        color: Color(kLightGrey.value),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/usa.svg',
                                width: 20.w,
                                height: 20.h,
                              ),
                              const WidthSpacer(width: 15),
                              ReusableText(
                                text: userData.phone,
                                style: appstyle(
                                  16,
                                  Color(kDark.value),
                                  FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const HeightSpacer(size: 20),
                      Container(
                        color: Color(kLightGrey.value),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.h),
                              child: ReusableText(
                                text: 'Skills',
                                style: appstyle(
                                  16,
                                  Color(kDark.value),
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                            const HeightSpacer(size: 3),
                            SizedBox(
                              height: hieght * 0.5,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 8.h,
                                ),
                                child: ListView.builder(
                                  itemCount: userData.skills.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final skill = userData.skills[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                        ),
                                        width: width,
                                        height: hieght * 0.06,
                                        color: Color(kLight.value),
                                        child: Row(
                                          children: [
                                            ReusableText(
                                              text: skill,
                                              style: appstyle(
                                                16,
                                                Color(
                                                  kDark.value,
                                                ),
                                                FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
