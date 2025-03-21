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

/*class ProfilePage extends StatefulWidget {
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
      backgroundColor: const Color(0xFF040326),
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
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: width,
                            height: height * 0.12,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ReusableText(
                                          text: userData.username,
                                          style: appstyle(
                                            20,
                                            Colors.white,
                                            FontWeight.w600,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            ReusableText(
                                              text: userData.city,
                                              style: appstyle(
                                                16,
                                                Colors.white70,
                                                FontWeight.w600,
                                              ),
                                            ),
                                            const WidthSpacer(width: 5),
                                            ReusableText(
                                              text: userData.state,
                                              style: appstyle(
                                                16,
                                                Colors.white70,
                                                FontWeight.w600,
                                              ),
                                            ),
                                            const WidthSpacer(width: 5),
                                            ReusableText(
                                              text: userData.country,
                                              style: appstyle(
                                                16,
                                                Colors.white70,
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
                                    color: Colors.white,
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
                            height: height * 0.06,
                            decoration: BoxDecoration(
                                color: const Color(0xFF08979F),
                                borderRadius: BorderRadius.circular(16)),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  const Icon(
                                    MaterialIcons.email,
                                    color: Colors.white,
                                  ),
                                  const WidthSpacer(width: 5),
                                  ReusableText(
                                    text: userData.email,
                                    style: appstyle(
                                      16,
                                      Colors.white,
                                      FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const HeightSpacer(size: 20),
                          Container(
                            padding: EdgeInsets.only(left: 8.w),
                            width: width,
                            height: height * 0.06,
                            decoration: BoxDecoration(
                                color: const Color(0xFF08979F),
                                borderRadius: BorderRadius.circular(16)),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  const Icon(
                                    MaterialIcons.phone,
                                    color: Colors.white,
                                  ),
                                  const WidthSpacer(width: 5),
                                  ReusableText(
                                    text: userData.phone,
                                    style: appstyle(
                                      16,
                                      Colors.white,
                                      FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const HeightSpacer(size: 20),
                          Container(
                            padding: EdgeInsets.only(left: 8.w),
                            width: width,
                            height: height * 0.06,
                            decoration: BoxDecoration(
                                color: const Color(0xFF08979F),
                                borderRadius: BorderRadius.circular(16)),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  const Icon(
                                    MaterialIcons.wc,
                                    color: Colors.white,
                                  ),
                                  const WidthSpacer(width: 5),
                                  ReusableText(
                                    text: userData.gender,
                                    style: appstyle(
                                      16,
                                      Colors.white,
                                      FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const HeightSpacer(size: 20),
                          Container(
                            padding: EdgeInsets.only(left: 8.w),
                            width: width,
                            height: height * 0.06,
                            decoration: BoxDecoration(
                                color: const Color(0xFF08979F),
                                borderRadius: BorderRadius.circular(16)),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  const Icon(
                                    MaterialIcons.apartment,
                                    color: Colors.white,
                                  ),
                                  const WidthSpacer(width: 5),
                                  ReusableText(
                                    text: userData.college,
                                    style: appstyle(
                                      16,
                                      Colors.white,
                                      FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const HeightSpacer(size: 20),
                          Container(
                            padding: EdgeInsets.only(left: 8.w),
                            width: width,
                            height: height * 0.06,
                            decoration: BoxDecoration(
                                color: const Color(0xFF08979F),
                                borderRadius: BorderRadius.circular(16)),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  const Icon(
                                    MaterialIcons.school,
                                    color: Colors.white,
                                  ),
                                  const WidthSpacer(width: 5),
                                  ReusableText(
                                    text: userData.branch,
                                    style: appstyle(
                                      16,
                                      Colors.white,
                                      FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const HeightSpacer(size: 20),
                          Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFF08979F),
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.h),
                                  child: Center(
                                    child: ReusableText(
                                      text: 'Skills',
                                      style: appstyle(
                                        16,
                                        Colors.white,
                                        FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const HeightSpacer(size: 3),
                                SizedBox(
                                  height: height * 0.45,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 8.h,
                                    ),
                                    child: ListView.builder(
                                      itemCount: userData.skills.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final skill = userData.skills[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                            ),
                                            width: width,
                                            height: height * 0.06,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Color(0xFF040326),
                                                  width: 2.0,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                ReusableText(
                                                  text: skill,
                                                  style: appstyle(
                                                    16,
                                                    Color(0xFF040326),
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
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}*/
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
      backgroundColor: const Color(0xFF040326),
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
          return FutureBuilder<ProfileRes?>(
            future: profileNotifier.profile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('No profile data available'));
              }

              final userData = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildProfileHeader(userData),
                      const HeightSpacer(size: 20),
                      _buildInfoTile(Icons.email, userData.email),
                      const HeightSpacer(size: 20),
                      _buildInfoTile(Icons.phone, userData.phone),
                      const HeightSpacer(size: 20),
                      _buildInfoTile(Icons.wc, userData.gender),
                      const HeightSpacer(size: 20),
                      _buildInfoTile(Icons.apartment, userData.college),
                      const HeightSpacer(size: 20),
                      _buildInfoTile(Icons.school, userData.branch),
                      const HeightSpacer(size: 20),
                      _buildSkillsSection(userData.skills),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(ProfileRes userData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: userData.profile == 'null' || userData.profile.isEmpty
                  ? Image.asset('assets/images/user.png',
                      width: 80.w, height: 100.h)
                  : CachedNetworkImage(
                      imageUrl: userData.profile,
                      width: 80.w,
                      height: 100.h,
                      errorWidget: (context, url, error) => Image.asset(
                          'assets/images/user.png',
                          width: 80.w,
                          height: 100.h),
                    ),
            ),
            const WidthSpacer(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusableText(
                  text: userData.username,
                  style: appstyle(20, Colors.white, FontWeight.w600),
                ),
                Row(
                  children: [
                    ReusableText(
                      text: '${userData.city}, ',
                      style: appstyle(16, Colors.white70, FontWeight.w600),
                    ),
                    ReusableText(
                      text: '${userData.state}, ',
                      style: appstyle(16, Colors.white70, FontWeight.w600),
                    ),
                    ReusableText(
                      text: userData.country,
                      style: appstyle(16, Colors.white70, FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Get.to(() => const UpdateProfilePage()),
          child: const Icon(Feather.edit, color: Colors.white, size: 18),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.only(left: 8.w),
      width: double.infinity,
      height: 60.h,
      decoration: BoxDecoration(
        color: const Color(0xFF08979F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const WidthSpacer(width: 5),
          ReusableText(
            text: text,
            style: appstyle(16, Colors.white, FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(List<String> skills) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF08979F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.h),
            child: Center(
              child: ReusableText(
                text: 'Skills',
                style: appstyle(16, Colors.white, FontWeight.w600),
              ),
            ),
          ),
          ...skills.map((skill) => Padding(
                padding: const EdgeInsets.all(8),
                child: Text(skill,
                    style: appstyle(16, Colors.white, FontWeight.normal)),
              )),
        ],
      ),
    );
  }
}
