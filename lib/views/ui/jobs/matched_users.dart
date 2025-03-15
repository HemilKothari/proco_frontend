import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/controllers/jobs_provider.dart';
import 'package:jobhub_v1/models/response/jobs/jobs_response.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/app_style.dart';
import 'package:jobhub_v1/views/common/drawer/drawer_widget.dart';
import 'package:jobhub_v1/views/common/heading_widget.dart';
import 'package:jobhub_v1/views/common/height_spacer.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:jobhub_v1/views/ui/filters/filter_page.dart';
import 'package:jobhub_v1/views/ui/jobs/job_page.dart';
import 'package:jobhub_v1/views/ui/notification/notification_page.dart';
import 'package:provider/provider.dart';

class MatchedUsers extends StatefulWidget {
  const MatchedUsers({super.key});

  @override
  State<MatchedUsers> createState() => _MatchedUsersState();
}

class _MatchedUsersState extends State<MatchedUsers> {
  int _currentIndex = 0;
  final CardSwiperController controller = CardSwiperController();

  @override
  void initState() {
    super.initState();
    final jobNotifier = Provider.of<JobsNotifier>(context, listen: false);
    jobNotifier.getJobs();
  }

  // Helper widgets
  Widget _buildInfoBox(String? text, double fontSize) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF08979F),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(
          text ?? '',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
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
      body: Consumer<JobsNotifier>(
        builder: (context, jobNotifier, child) {
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
                        height: 0.97.sh,
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          child: FutureBuilder<List<JobsResponse>>(
                            future: jobNotifier.jobList,
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
                                    'No jobs available.',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: const Color(0xFF040326),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              } else {
                                final jobList = snapshot.data!;
                                return CardSwiper(
                                  controller: controller,
                                  scale: 0.5,
                                  cardsCount: jobList.length,
                                  allowedSwipeDirection: AllowedSwipeDirection.only(left: true, right:true),
                                  cardBuilder: (context, index,
                                      percentThresholdX, percentThresholdY) {
                                    final job = jobList[index];
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
                                            job.company ?? 'Unknown Company',
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
                                              job.imageUrl,
                                              height: 0.45.sh,
                                              width: double.infinity,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/images/default-placeholder.png',
                                                  height: 0.45.sh,
                                                  width: double.infinity,
                                                  fit: BoxFit.contain,
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          _buildInfoBox(job.title, 12.sp),
                                          SizedBox(height: 10),
                                          _buildInfoBox(
                                              job.location ??
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
                                onPressed: () => controller
                                    .swipe(CardSwiperDirection.left)),
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