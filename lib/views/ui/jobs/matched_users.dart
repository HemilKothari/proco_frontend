import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jobhub_v1/controllers/exports.dart';
import 'package:jobhub_v1/controllers/profile_provider.dart';
import 'package:jobhub_v1/models/response/auth/swipe_res_model.dart';
import 'package:jobhub_v1/models/response/bookmarks/all_bookmarks.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:jobhub_v1/views/ui/jobs/user_job_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchedUsers extends StatefulWidget {
  const MatchedUsers({super.key});

  @override
  State<MatchedUsers> createState() => _MatchedUsersState();
}

class _MatchedUsersState extends State<MatchedUsers> {
  int _currentIndex = 0;
  final CardSwiperController controller = CardSwiperController();

  getJobId() async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    print(keys);
    return prefs.getString('currentJobId') ?? "";
  }

  @override
  void initState() {
    super.initState();
    _initializeJobId();
  }

  void _initializeJobId() async {
    String jobId = await getJobId();
    print("JOB ID FOUND: $jobId");
    if (!mounted) return;
    final profileNotifier = Provider.of<JobsNotifier>(context, listen: false);
    profileNotifier.getSwipedUsersId(jobId);
  }

  // Helper widgets
  Widget _buildInfoBox(dynamic text, double fontSize) {
    if (text == null ||
        (text is String && text.isEmpty) ||
        (text is List && text.isEmpty)) {
      return SizedBox.shrink(); // Return empty widget if null or empty
    }

    if (text is String) {
      return _buildSingleBox(text, fontSize);
    } else if (text is List<String>) {
      return Wrap(
        spacing: 8.0, // Space between items
        runSpacing: 4.0, // Space between lines
        children: text.map((item) => _buildSingleBox(item, fontSize)).toList(),
      );
    }

    return SizedBox.shrink(); // Fallback in case of unexpected input
  }

  Widget _buildSingleBox(String text, double fontSize) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF08979F),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFAB({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(icon),
      backgroundColor: color,
      foregroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.065.sh),
        child: CustomAppBar(
          text: 'Interested Users',
          child: Padding(
            padding: EdgeInsets.only(right: 0.010.sh),
            child: IconButton(
              icon: const Icon(
                FontAwesome.arrow_left,
                color: Color(0xFF08959D),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Consumer<JobsNotifier>(
        builder: (context, profileNotifier, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        height: 0.87.sh,
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          child: FutureBuilder<List<SwipedRes>>(
                            future: profileNotifier.swipedUsers,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No users available.',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: const Color(0xFF040326),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              } else {
                                final userList = snapshot.data!;
                                return CardSwiper(
                                  controller: controller,
                                  scale: 0.5,
                                  cardsCount: userList.length,
                                  allowedSwipeDirection:
                                      const AllowedSwipeDirection.only(
                                          left: true, right: true),
                                  cardBuilder: (context, index,
                                      percentThresholdX, percentThresholdY) {
                                    final user = userList[index];
                                    return Container(
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF040326),
                                        borderRadius:
                                            BorderRadius.circular(20.w),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 8),
                                          Text(
                                            user.username ?? 'Unknown User',
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF08979F),
                                              fontFamily: 'Poppins',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          //SizedBox(height: 4),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              user.profile,
                                              height: 0.45.sh,
                                              width: double.infinity,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/images/user-placeholder.png',
                                                  height: 0.45.sh,
                                                  width: double.infinity,
                                                  fit: BoxFit.contain,
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          _buildInfoBox(user.skills, 12.sp),
                                          SizedBox(height: 10),
                                          _buildInfoBox(
                                              user.location ??
                                                  'Location Not Available',
                                              12.sp),
                                        ],
                                      ),
                                    );
                                  },
                                  isLoop: true,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0, // Adjust to move the icons up
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildFAB(
                                icon: Icons.heart_broken,
                                color: const Color(0xFFD23838),
                                onPressed: () =>
                                    controller.swipe(CardSwiperDirection.left)),
                            _buildFAB(
                                icon: Icons.rotate_left,
                                color: const Color(0xFF08979F),
                                onPressed: controller.undo),
                            _buildFAB(
                                icon: Icons.star,
                                color: const Color(0xFF089F20),
                                onPressed: () => controller
                                    .swipe(CardSwiperDirection.right)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
