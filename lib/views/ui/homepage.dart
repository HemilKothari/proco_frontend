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
              padding: EdgeInsets.all(12.h),
              child: const CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage('assets/images/user.png'),
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
                      clipBehavior: Clip.none, // Allows the icon to extend outside the SizedBox
                      children: [
                        // The SizedBox for the cards
                        SizedBox(
                          height: 0.8.sh, // Increase height to include more top space
                          child: FutureBuilder<List<JobsResponse>>(
                            future: jobNotifier.jobList,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No jobs available.',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              } else {
                                final jobList = snapshot.data!;
                                return CardSwiper(
                                  controller: controller,
                                  cardsCount: jobList.length,
                                  cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                                    final job = jobList[index];
                                    return Container(
                                      padding: EdgeInsets.all(16.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15.w),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            blurRadius: 5,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Spacer(),
                                          job.imageUrl != null
                                              ? Image.network(
                                                  job.imageUrl!,
                                                  height: 200.h,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                )
                                              : Icon(
                                                  Icons.business,
                                                  size: 100.h,
                                                  color: Colors.grey.shade400,
                                                ),
                                          const Spacer(),
                                          Text(
                                            job.company ?? 'Unknown Company',
                                            style: TextStyle(
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            job.title ?? 'No Title',
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade700,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            job.location ?? 'Location Not Available',
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey.shade600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
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
                          top: 36.h, // Move the icon above the SizedBox
                          right: 20.0.w, // Adjust right alignment
                          child: Icon(
                            FontAwesome.sliders,
                            color: const Color(0xFF040326),
                            size: 32.h, // Slightly larger size for emphasis
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Other widgets below the cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton(
                          onPressed: controller.undo,
                          child: const Icon(Icons.rotate_left),
                          backgroundColor: const Color(0xFF040326),
                          foregroundColor: Colors.white,
                        ),
                        FloatingActionButton(
                          onPressed: () => controller.swipe(CardSwiperDirection.left),
                          child: const Icon(Icons.keyboard_arrow_left),
                          backgroundColor: const Color(0xFF040326),
                          foregroundColor: Colors.white,
                        ),
                        FloatingActionButton(
                          onPressed: () => controller.swipe(CardSwiperDirection.right),
                          child: const Icon(Icons.keyboard_arrow_right),
                          backgroundColor: const Color(0xFF040326),
                          foregroundColor: Colors.white,
                        ),
                        FloatingActionButton(
                          onPressed: () => controller.swipe(CardSwiperDirection.top),
                          child: const Icon(Icons.keyboard_arrow_up),
                          backgroundColor: const Color(0xFF040326),
                          foregroundColor: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
