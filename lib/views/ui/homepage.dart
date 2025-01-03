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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
          actions: [
            Padding(
              padding: EdgeInsets.all(1.h),
              child: Icon(
                            FontAwesome.filter,
                            color: const Color(0xFF08959D),
                          ),
            ),
            Padding(
              padding: EdgeInsets.all(12.h),
              child: Icon(
                            FontAwesome.bell,
                            color: const Color(0xFF08959D),
                          ),
            ),
          ],
          child: Padding(
            padding: EdgeInsets.all(12.0.h),
            child: const DrawerWidget(),
          ),
        ),
      ),
      body: Consumer<JobsNotifier>(
        builder: (context, jobNotifier, child) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stack to overlay the icon
                    Stack(
                      clipBehavior: Clip
                          .none, // Allows the icon to extend outside the SizedBox
                      children: [
                        // The SizedBox for the cards
                        SizedBox(
                          height: 0.75
                              .sh, // Increase height to include more top space
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
                                  scale: .5,
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
                                          //const Spacer
                                          Text(
                                            job.company ?? 'Unknown Company',
                                            style: TextStyle(
                                                fontSize: 24.sp,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF08979F),
                                                fontFamily: 'Poppins'),
                                            textAlign: TextAlign.center,
                                          ),
                                          // const Spacer(),
                                          SizedBox(height: 18),
                                          Image.network(
                                            job.imageUrl!,
                                            //height: 200.h, // Adjust height as needed
                                            width: double.infinity,
                                            fit: BoxFit.fitWidth,
                                          ),

                                          // const Spacer(),
                                          //const SizedBox(height: 10),
                                          /* Text(
                                            job.title ?? 'No Title',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                  255, 247, 245, 245),
                                            ),
                                            textAlign: TextAlign.left,
                                          ),*/
                                          SizedBox(height: 22),
                                          /* Container(
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                  0xFF08979F), // Background color of the box
                                              borderRadius: BorderRadius.circular(
                                                  8.0), // Optional: Rounded corners
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                                vertical:
                                                    4.0), // Padding inside the box
                                            child: Text(
                                              job.title ?? 'No Title',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: const Color.fromARGB(
                                                    255,
                                                    247,
                                                    245,
                                                    245), // Text color
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),*/
                                          Align(
                                            alignment: Alignment
                                                .centerLeft, // Aligns the box to the left
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                    0xFF08979F), // Background color of the box
                                                borderRadius: BorderRadius.circular(
                                                    8.0), // Optional: Rounded corners
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical:
                                                      4.0), // Padding inside the box
                                              child: Text(
                                                job.title ?? 'No Title',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color.fromARGB(
                                                      255,
                                                      247,
                                                      245,
                                                      245), // Text color
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Align(
                                            alignment: Alignment
                                                .centerLeft, // Aligns the box to the left
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                    0xFF08979F), // Background color of the box
                                                borderRadius: BorderRadius.circular(
                                                    8.0), // Optional: Rounded corners
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical:
                                                      4.0), // Padding inside the box
                                              child: Text(
                                                job.location ??
                                                    'Location Not Available',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,

                                                  color: const Color.fromARGB(
                                                      255,
                                                      247,
                                                      245,
                                                      245), // Text color
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 10),
                                          /*Text(
                                            job.location ??
                                                'Location Not Available',
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey.shade600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          */
                                          const Spacer(),
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
                        // The Icon overlaid on the SizedBox
                         Positioned(
                          top: 570.h, // Move the icon above the SizedBox
                          right: 20.0.w,
                          left: 20.0.w, // Adjust right alignment
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FloatingActionButton(
                                onPressed: controller.undo,
                                child: const Icon(Icons.rotate_left),
                                backgroundColor: const Color(0xFF08979F),
                                foregroundColor: Colors.white,
                              ),
                              FloatingActionButton(
                                onPressed: () =>
                                    controller.swipe(CardSwiperDirection.left),
                                child: const Icon(Icons.heart_broken),
                                backgroundColor: const Color(0xFFD23838),
                                foregroundColor: Colors.white,
                              ),
                              FloatingActionButton(
                                onPressed: () =>
                                    controller.swipe(CardSwiperDirection.right),
                                child: const Icon(Icons.star),
                                backgroundColor: const Color(0xFF089F20),
                                foregroundColor: Colors.white,
                              ),
                              FloatingActionButton(
                                onPressed: () =>
                                    controller.swipe(CardSwiperDirection.top),
                                child: const Icon(Icons.bookmark),
                                backgroundColor: const Color(0xFF08979F),
                                foregroundColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    // Other widgets below the cards
                    
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF08959D), // Color for the selected item
        unselectedItemColor: Colors.white, // Color for unselected items
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
