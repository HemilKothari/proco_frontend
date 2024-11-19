import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/controllers/exports.dart';
import 'package:jobhub_v1/models/request/bookmarks/bookmarks_model.dart';
import 'package:jobhub_v1/models/request/chat/create_chat.dart';
import 'package:jobhub_v1/models/request/messaging/send_message.dart';
import 'package:jobhub_v1/services/helpers/chat_helper.dart';
import 'package:jobhub_v1/services/helpers/messaging_helper.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/custom_outline_btn.dart';
import 'package:jobhub_v1/views/common/exports.dart';
import 'package:jobhub_v1/views/common/height_spacer.dart';
import 'package:jobhub_v1/views/ui/mainscreen.dart';
import 'package:provider/provider.dart';

class JobPage extends StatefulWidget {
  const JobPage({required this.title, required this.id, super.key});

  final String title;
  final String id;

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<JobsNotifier>(
      builder: (context, jobsNotifier, child) {
        jobsNotifier.getJob(widget.id);
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: CustomAppBar(
              text: widget.title,
              actions: [
                Consumer<BookMarkNotifier>(
                  builder: (context, bookMarkNotifier, child) {
                    bookMarkNotifier.loadJobs();
                    return GestureDetector(
                      onTap: () {
                        if (bookMarkNotifier.jobs.contains(widget.id)) {
                          bookMarkNotifier.deleteBookMark(widget.id);
                        } else {
                          final model = BookmarkReqResModel(job: widget.id);
                          bookMarkNotifier.addBookMark(model, widget.id);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 12.0.w),
                        child: !bookMarkNotifier.jobs.contains(widget.id)
                            ? const Icon(Fontisto.bookmark)
                            : const Icon(Fontisto.bookmark_alt),
                      ),
                    );
                  },
                ),
              ],
              child: GestureDetector(
                onTap: Get.back,
                child: const Icon(CupertinoIcons.arrow_left),
              ),
            ),
          ),
          body: FutureBuilder(
            future: jobsNotifier.job,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error ${snapshot.error}');
              } else {
                final job = snapshot.data;
                print(job?.agentId);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Stack(
                    children: [
                      ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          const HeightSpacer(size: 30),
                          Container(
                            width: width,
                            height: hieght * 0.27,
                            color: Color(kLightGrey.value),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(job!.imageUrl),
                                ),
                                const HeightSpacer(size: 10),
                                ReusableText(
                                  text: job.title,
                                  style: appstyle(
                                    22,
                                    Color(kDark.value),
                                    FontWeight.w600,
                                  ),
                                ),
                                const HeightSpacer(size: 5),
                                ReusableText(
                                  text: job.location,
                                  style: appstyle(
                                    16,
                                    Color(kDarkGrey.value),
                                    FontWeight.normal,
                                  ),
                                ),
                                const HeightSpacer(size: 15),
                                Padding(
                                  padding: EdgeInsets.only(left: 10.w),
                                  child: SizedBox(
                                    width: width * 0.6,
                                    child: ReusableText(
                                      text: '${job.salary} ${job.period} ',
                                      style: appstyle(
                                        18,
                                        Color(kDark.value),
                                        FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const HeightSpacer(size: 20),
                          ReusableText(
                            text: job.title,
                            style: appstyle(
                              18,
                              Color(kDark.value),
                              FontWeight.w600,
                            ),
                          ),
                          const HeightSpacer(size: 10),
                          Text(
                            desc,
                            textAlign: TextAlign.justify,
                            maxLines: 8,
                            style: appstyle(
                              14,
                              Color(kDarkGrey.value),
                              FontWeight.normal,
                            ),
                          ),
                          const HeightSpacer(size: 20),
                          ReusableText(
                            text: 'Requirements',
                            style: appstyle(
                              22,
                              Color(kDark.value),
                              FontWeight.w600,
                            ),
                          ),
                          const HeightSpacer(size: 10),
                          SizedBox(
                            height: hieght * 0.6,
                            child: ListView.builder(
                              itemCount: job.requirements.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final req = job.requirements[index];
                                const bullet = '\u2022';
                                return Text(
                                  '$bullet $req\n',
                                  maxLines: 4,
                                  textAlign: TextAlign.justify,
                                  style: appstyle(
                                    16,
                                    Color(kDarkGrey.value),
                                    FontWeight.normal,
                                  ),
                                );
                              },
                            ),
                          ),
                          const HeightSpacer(size: 20),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: CustomOutlineBtn(
                            onTap: () async {
                              // var data = await SharedPreferences.getInstance();

                              final model = CreateChat(userId: job.agentId);
                              print(model.userId);
                              await ChatHelper.apply(model).then((response) {
                                if (response[0]) {
                                  final model = SendMessage(
                                    content:
                                        "Hello, I'm interested in ${job.title}",
                                    chatId: response[1],
                                    receiver: job.agentId,
                                  );
                                  MesssagingHelper.sendMessage(model)
                                      .whenComplete(() {
                                    Get.to(() => const MainScreen());
                                  });
                                }
                              });
                            },
                            color2: Color(kOrange.value),
                            width: width,
                            hieght: hieght * 0.06,
                            text: 'Apply Now',
                            color: Color(kLight.value),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
