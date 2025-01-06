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
import 'package:jobhub_v1/views/ui/jobs/job_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: CustomAppBar(
          actions: [
            Padding(
              padding: EdgeInsets.all(12.h),
              child: Icon(
                FontAwesome.filter,
                color: const Color(0xFF08959D),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 1.0.h),
              child: Icon(
                FontAwesome.bell,
                color: const Color(0xFF08959D),
              ),
            ),
          ],
          child: Padding(
            padding: EdgeInsets.all(1.0.h),
            child: const DrawerWidget(),
          ),
        ),
      ),
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
                        height: 0.78.sh,
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
                                  cardBuilder: (context, index,
                                      percentThresholdX, percentThresholdY) {
                                    final job = jobList[index];
                                    return Container(
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF040326),
                                        borderRadius:
                                            BorderRadius.circular(15.w),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
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
                                          SizedBox(height: 18),
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
                                          SizedBox(height: 22),
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
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildFAB(
                                icon: Icons.rotate_left,
                                color: const Color(0xFF08979F),
                                onPressed: controller.undo),
                            _buildFAB(
                                icon: Icons.heart_broken,
                                color: const Color(0xFFD23838),
                                onPressed: () =>
                                    controller.swipe(CardSwiperDirection.left)),
                            _buildFAB(
                                icon: Icons.star,
                                color: const Color(0xFF089F20),
                                onPressed: () => controller
                                    .swipe(CardSwiperDirection.right)),
                            _buildFAB(
                                icon: Icons.bookmark,
                                color: const Color(0xFF08979F),
                                onPressed: () =>
                                    controller.swipe(CardSwiperDirection.top)),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF08959D),
        unselectedItemColor: Colors.white,
        backgroundColor: const Color(0xFF040326),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
