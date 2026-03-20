// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'package:get/get.dart';
// import 'package:jobhub_v1/controllers/profile_provider.dart';
// import 'package:jobhub_v1/models/response/auth/profile_model.dart';
// import 'package:jobhub_v1/views/common/app_bar.dart';
// import 'package:jobhub_v1/views/common/drawer/drawer_widget.dart';
// import 'package:jobhub_v1/views/common/exports.dart';
// import 'package:jobhub_v1/views/common/height_spacer.dart';
// import 'package:jobhub_v1/views/common/width_spacer.dart';
// import 'package:jobhub_v1/views/ui/auth/profile_update.dart';
// import 'package:provider/provider.dart';

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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                      const HeightSpacer(size: 20),
                      _buildProfileHeader(userData),
                      const HeightSpacer(size: 20),

                      // ✅ Personal Info Section
                      _buildSectionLabel('Personal Info'),
                      const HeightSpacer(size: 10),
                      _buildInfoTile(
                          Icons.email_outlined, 'Email', userData.email),
                      const HeightSpacer(size: 12),
                      _buildInfoTile(
                          Icons.phone_outlined, 'Phone', userData.phone),
                      const HeightSpacer(size: 12),
                      _buildInfoTile(Icons.wc_outlined, 'Gender',
                          userData.gender ?? 'Not set'),
                      const HeightSpacer(size: 20),

                      // ✅ Location Section
                      _buildSectionLabel('Location'),
                      const HeightSpacer(size: 10),
                      _buildInfoTile(Icons.location_city_outlined, 'City',
                          userData.city ?? 'Not set'),
                      const HeightSpacer(size: 12),
                      _buildInfoTile(Icons.map_outlined, 'State',
                          userData.state ?? 'Not set'),
                      const HeightSpacer(size: 12),
                      _buildInfoTile(Icons.flag_outlined, 'Country',
                          userData.country ?? 'Not set'),
                      const HeightSpacer(size: 20),

                      // ✅ Education Section
                      _buildSectionLabel('Education'),
                      const HeightSpacer(size: 10),
                      _buildInfoTile(Icons.apartment_outlined, 'College',
                          userData.college ?? 'Not set'),
                      const HeightSpacer(size: 12),
                      _buildInfoTile(Icons.school_outlined, 'Branch',
                          userData.branch ?? 'Not set'),
                      const HeightSpacer(size: 20),

                      // ✅ Skills Section
                      _buildSkillsSection(userData.skills),
                      const HeightSpacer(size: 30),
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

  // ✅ Section label helper
  Widget _buildSectionLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ReusableText(
        text: label,
        style: appstyle(13, Colors.white54, FontWeight.w500),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileRes userData) {
    // Build location string only from non-null/empty parts
    final locationParts = [
      userData.city,
      userData.state,
      userData.country,
    ].where((part) => part != null && part.isNotEmpty).toList();
    final locationString = locationParts.join(', ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ✅ Avatar — fixed size, never shrinks
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: userData.profile == 'null' || userData.profile.isEmpty
              ? Image.asset(
                  'assets/images/user.png',
                  width: 80.w,
                  height: 100.h,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  imageUrl: userData.profile,
                  width: 80.w,
                  height: 100.h,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/user.png',
                    width: 80.w,
                    height: 100.h,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        const WidthSpacer(width: 16),

        // ✅ Expanded so text never overflows — takes remaining width
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Username — wraps if very long
              Text(
                userData.username,
                style: appstyle(20, Colors.white, FontWeight.w600),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              // ✅ Location — single string, ellipsis if overflows
              if (locationString.isNotEmpty)
                Text(
                  locationString,
                  style: appstyle(14, Colors.white70, FontWeight.w400),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
            ],
          ),
        ),
        const WidthSpacer(width: 8),

        // Edit icon — fixed, never pushed off screen
        GestureDetector(
          onTap: () => Get.to(() => const UpdateProfilePage()),
          child: const Icon(Feather.edit, color: Colors.white, size: 18),
        ),
      ],
    );
  }

  // ✅ Flexible tile — height grows with content, never clips long text
  Widget _buildInfoTile(IconData icon, String label, String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF08979F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon aligned to first line of text
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const WidthSpacer(width: 10),
          // ✅ Expanded so text wraps instead of overflowing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Small label above the value
                Text(
                  label,
                  style: appstyle(11, Colors.white60, FontWeight.w400),
                ),
                const SizedBox(height: 2),
                Text(
                  text.isEmpty ? 'Not set' : text,
                  style: appstyle(15, Colors.white, FontWeight.w600),
                  softWrap: true, // ✅ wraps long text
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Skills shown as wrap chips — handles any number of skills
  Widget _buildSkillsSection(List<String> skills) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF08979F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ReusableText(
              text: 'Skills',
              style: appstyle(16, Colors.white, FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          skills.isEmpty
              ? Text(
                  'No skills added yet',
                  style: appstyle(14, Colors.white60, FontWeight.normal),
                )
              // ✅ Wrap — chips flow to next line instead of overflowing
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: skills
                      .map(
                        (skill) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            skill,
                            style: appstyle(13, Colors.white, FontWeight.w500),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }
}
