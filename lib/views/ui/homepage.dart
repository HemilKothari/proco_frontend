import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jobhub_v1/controllers/jobs_provider.dart';
import 'package:jobhub_v1/models/response/jobs/jobs_response.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/drawer/drawer_widget.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:jobhub_v1/views/ui/filters/filter_page.dart';
import 'package:jobhub_v1/views/ui/notification/notification_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<String> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? "";
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
        preferredSize: Size.fromHeight(0.065.sh),
        child: CustomAppBar(
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 0.01.sh),

              /*child: Icon(
                FontAwesome.filter,
                color: const Color(0xFF08959D),
              ),
              */

              child: IconButton(
                icon: const Icon(
                  FontAwesome.filter,
                  color: Color(0xFF08959D),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FilterPage()),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 0.01.sh),
              child: IconButton(
                icon: const Icon(
                  FontAwesome.bell,
                  color: Color(0xFF08959D),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationPage()),
                  );
                },
              ),

              /*child: Icon(
                FontAwesome.bell,
                color: const Color(0xFF08959D),
              ),*/
            ),
          ],
          child: Padding(
            padding: EdgeInsets.only(left: 0.010.sh),
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
                        height: 0.87.sh,
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          child: FutureBuilder<String>(
                            future:
                                getCurrentUserId(), // Fetch logged-in user's agentId
                            builder: (context, userSnapshot) {
                              if (!userSnapshot.hasData) {
                                return const Center(
                                    child:
                                        CircularProgressIndicator()); // Show loading until agentId is fetched
                              }

                              final String currentUserId = userSnapshot.data!;
                              return FutureBuilder<List<JobsResponse>>(
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
                                    final jobList = snapshot.data!
                                        .where((job) =>
                                            job.agentId != currentUserId &&
                                            job.hiring ==
                                                true) // Filter out user's jobs
                                        .toList();
                                    return CardSwiper(
                                      controller: controller,
                                      scale: 0.5,
                                      cardsCount: jobList.length,
                                      allowedSwipeDirection:
                                          AllowedSwipeDirection.only(
                                              left: true, right: true),
                                      cardBuilder: (context,
                                          index,
                                          percentThresholdX,
                                          percentThresholdY) {
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
                                                job.company ??
                                                    'Unknown Company',
                                                style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      const Color(0xFF08979F),
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
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
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
                              );
                            },
                          ),
                        ),
                      ),
                      /*Positioned(
                        bottom: 40,
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
                      ),*/
                      Positioned(
                        bottom: 0, // Adjust to move the icons up
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
      /*bottomNavigationBar: Container(
        height:
            kBottomNavigationBarHeight, // Standard height for navigation bars
        width:
            double.infinity, // Ensures it occupies the full width of the screen
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Optional shadow for effect
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        /* child: BottomAppBar(
          color: Colors.transparent, // Set transparent to use container's color
          elevation:
              0, // Remove BottomAppBar's elevation to avoid duplicate shadows
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => setState(() => _currentIndex = index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*Icon(
                      _getIconForIndex(index),
                      size: 36, // Get the appropriate icon
                      color: _currentIndex == index
                          ? const Color(0xFF08959D) // Selected icon color
                          : const Color(0xFF040326), // Unselected icon color
                    ),*/
                    /* AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.only(
                          top: 4), // Space between icon and line
                      height: 3, // Height of the blue line
                      width: _currentIndex == index
                          ? 48
                          : 0, // Line width for selected item
                      color: _currentIndex == index
                          ? const Color(
                              0xFF08959D) // Blue line for selected item
                          : Colors.transparent, // No line for unselected items
                    ),*/
                  ],
                ),
              );
            }),
          ),
        ),*/
      ),*/
    );
  }
}
