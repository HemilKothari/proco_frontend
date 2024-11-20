import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/controllers/exports.dart';
import 'package:jobhub_v1/models/response/chat/get_chat.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/drawer/drawer_widget.dart';
import 'package:jobhub_v1/views/common/exports.dart';
import 'package:jobhub_v1/views/common/height_spacer.dart';
import 'package:jobhub_v1/views/common/loader.dart';
import 'package:jobhub_v1/views/ui/chat/chat_page.dart';
import 'package:provider/provider.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({super.key});

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {

  @override
  void initState() {
    super.initState();
    final chatNotifier = context.read<ChatNotifier>();
    chatNotifier.getChats();
    chatNotifier.getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
          text: 'Chats',
          child: Padding(
            padding: EdgeInsets.all(12.0.h),
            child: const DrawerWidget(),
          ),
        ),
      ),
      body: Consumer<ChatNotifier>(
        builder: (context, chatNotifier, child) {
          return FutureBuilder<List<GetChats>>(
            future: chatNotifier.chats,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return ReusableText(
                  text: 'Error ${snapshot.error}',
                  style: appstyle(20, Color(kOrange.value), FontWeight.bold),
                );
              } else if (snapshot.data!.isEmpty) {
                return const SearchLoading(text: 'No Chats Available');
              } else {
                final chats = snapshot.data;

                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
                  itemCount: chats!.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final user = chat.users
                        .where((user) => user.id != chatNotifier.userId);
                    // Fix: Bad state: No element for all the places [
                    // .first] was used when the list was empty
                    final noUser = user.isEmpty;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(
                            () => ChatPage(
                              id: chat.id,
                              title:
                                  noUser ? 'Unknown user' : user.first.username,
                              profile:
                                  noUser ? kDefaultImage : user.first.profile,
                              user: [chat.users[0].id, chat.users[1].id],
                            ),
                          );
                        },
                        child: Container(
                          height: 80,
                          width: width,
                          decoration: BoxDecoration(
                            color: Color(kLightGrey.value),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 4.w),
                            minLeadingWidth: 0,
                            minVerticalPadding: 0,
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                noUser ? kDefaultImage : user.first.profile,
                              ),
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ReusableText(
                                  text: noUser
                                      ? 'Unknown user'
                                      : user.first.username,
                                  style: appstyle(
                                    16,
                                    Color(kDark.value),
                                    FontWeight.w600,
                                  ),
                                ),
                                const HeightSpacer(size: 5),
                                ReusableText(
                                  text: chat.latestMessage.content,
                                  style: appstyle(
                                    16,
                                    Color(kDarkGrey.value),
                                    FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Padding(
                              padding: EdgeInsets.only(right: 4.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ReusableText(
                                    text: chatNotifier.msgTime(
                                      chat.updatedAt.toString(),
                                    ),
                                    style: appstyle(
                                      12,
                                      Color(kDark.value),
                                      FontWeight.normal,
                                    ),
                                  ),
                                  Icon(
                                    chat.chatName == chatNotifier.userId
                                        ? Ionicons.arrow_forward_circle_outline
                                        : Ionicons.arrow_back_circle_outline,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
