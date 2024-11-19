import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/controllers/exports.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/drawer/drawer_widget.dart';
import 'package:jobhub_v1/views/common/exports.dart';
import 'package:jobhub_v1/views/common/heading_widget.dart';
import 'package:jobhub_v1/views/common/height_spacer.dart';
import 'package:jobhub_v1/views/common/search.dart';
import 'package:jobhub_v1/views/common/vertical_shimmer.dart';
import 'package:jobhub_v1/views/common/vertical_tile.dart';
import 'package:jobhub_v1/views/ui/jobs/job_page.dart';
import 'package:jobhub_v1/views/ui/jobs/jobs_list.dart';
import 'package:jobhub_v1/views/ui/jobs/widgets/horizontal_shimmer.dart';
import 'package:jobhub_v1/views/ui/jobs/widgets/horizontal_tile.dart';
import 'package:jobhub_v1/views/ui/search/searchpage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          jobNotifier.getJobs();
          jobNotifier.getRecent();
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeightSpacer(size: 10),
                    Text(
                      'Search \nFind & Apply',
                      style: appstyle(40, Color(kDark.value), FontWeight.bold),
                    ),
                    const HeightSpacer(size: 40),
                    SearchWidget(
                      onTap: () {
                        Get.to(() => const SearchPage());
                      },
                    ),
                    const HeightSpacer(size: 30),
                    HeadingWidget(
                      text: 'Popular Jobs',
                      onTap: () {
                        Get.to(() => const JobListPage());
                      },
                    ),
                    const HeightSpacer(size: 15),
                    SizedBox(
                      height: hieght * 0.28,
                      child: FutureBuilder(
                        future: jobNotifier.jobList,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const HorizontalShimmer();
                          } else if (snapshot.hasError) {
                            return Text('Error ${snapshot.error}');
                          } else {
                            final jobs = snapshot.data;
                            return ListView.builder(
                              itemCount: jobs!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final job = jobs[index];
                                return JobHorizontalTile(
                                  onTap: () {
                                    Get.to(
                                      () => JobPage(
                                        title: job.company,
                                        id: job.id,
                                      ),
                                    );
                                  },
                                  job: job,
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                    const HeightSpacer(size: 20),
                    HeadingWidget(
                      text: 'Recently Posted',
                      onTap: () {},
                    ),
                    const HeightSpacer(size: 20),
                    FutureBuilder(
                      future: jobNotifier.recent,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const VerticalShimmer();
                        } else if (snapshot.hasError) {
                          return Text('Error ${snapshot.error}');
                        } else {
                          final jobs = snapshot.data;
                          return VerticalTile(
                            onTap: () {
                              Get.to(
                                () =>
                                    JobPage(title: jobs!.company, id: jobs.id),
                              );
                            },
                            job: jobs,
                          );
                        }
                      },
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
