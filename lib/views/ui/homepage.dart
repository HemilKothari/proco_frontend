import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
                    HeadingWidget(
                      text: 'Filter Jobs',
                      onTap: () {
                        // Add filter functionality
                      },
                    ),
                    const HeightSpacer(size: 15),
                    SizedBox(
                      height: 0.75.sh, // Set the height for the cards to occupy most of the page
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
                                style: appstyle(16, Colors.grey, FontWeight.w400),
                              ),
                            );
                          } else {
                            final jobList = snapshot.data!;
                            return CardSwiper(
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
                                        style: appstyle(22, Colors.black, FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        job.title ?? 'No Title',
                                        style: appstyle(20, Colors.grey.shade700, FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        job.location ?? 'Location Not Available',
                                        style: appstyle(18, Colors.grey.shade600, FontWeight.w400),
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
                    const HeightSpacer(size: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle No action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('No'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle Yes action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Yes'),
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
