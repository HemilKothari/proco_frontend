import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/controllers/exports.dart';
import 'package:jobhub_v1/models/response/chat/get_chat.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/drawer/drawer_widget.dart';
import 'package:jobhub_v1/views/common/exports.dart';
import 'package:jobhub_v1/views/common/loader.dart';
import 'package:jobhub_v1/views/ui/chat/chat_page.dart';
import 'package:provider/provider.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({super.key});

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  // ─── Theme ────────────────────────────────────────────────────────────────
  static const Color _teal = Color(0xFF08979F);
  static const Color _tealLt = Color(0xFF0BBFCA);
  static const Color _navy = Color(0xFF040326);
  static const Color _bg = Colors.white;

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
      backgroundColor: _bg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.065.sh),
        child: CustomAppBar(
          text: 'Chats',
          child: Padding(
            padding: EdgeInsets.only(left: 0.010.sh),
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
                    child: CircularProgressIndicator(color: _teal));
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error ${snapshot.error}',
                    style: appstyle(16, Colors.redAccent, FontWeight.w500),
                  ),
                );
              } else if (snapshot.data!.isEmpty) {
                return _buildEmpty();
              }

              final chats = snapshot.data!;

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: chats.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  indent: 76.w,
                  color: Colors.grey.shade100,
                ),
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final otherUsers =
                      chat.users.where((u) => u.id != chatNotifier.userId);
                  final noUser = otherUsers.isEmpty;
                  final other = noUser ? null : otherUsers.first;

                  final String name = other?.username ?? 'Unknown User';
                  final String profile = other?.profile ?? kDefaultImage;
                  final String preview =
                      (chat.latestMessage?.content?.isNotEmpty ?? false)
                          ? chat.latestMessage!.content
                          : 'No messages yet';
                  final String time =
                      chatNotifier.msgTime(chat.updatedAt.toString());
                  final bool isOutgoing = chat.chatName == chatNotifier.userId;

                  return InkWell(
                    onTap: () => Get.to(() => ChatPage(
                          id: chat.id,
                          title: name,
                          profile: profile,
                          user: [chat.users[0].id, chat.users[1].id],
                        )),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
                      child: Row(
                        children: [
                          // ── Avatar with online dot ───────────────────────
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 26.r,
                                backgroundColor: _teal.withOpacity(0.12),
                                backgroundImage: NetworkImage(profile),
                                onBackgroundImageError: (_, __) {},
                              ),
                              // Online dot — shown if user is in online list
                              if (chatNotifier.online.contains(other?.id))
                                Positioned(
                                  right: 1,
                                  bottom: 1,
                                  child: Container(
                                    width: 11,
                                    height: 11,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(width: 14.w),

                          // ── Name + preview ───────────────────────────────
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: appstyle(15, _navy, FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 3.h),
                                Row(
                                  children: [
                                    // Outgoing / incoming arrow indicator
                                    Icon(
                                      isOutgoing
                                          ? Icons.arrow_upward_rounded
                                          : Icons.arrow_downward_rounded,
                                      size: 12,
                                      color: isOutgoing
                                          ? _teal
                                          : Colors.grey.shade400,
                                    ),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        preview,
                                        style: appstyle(
                                          13,
                                          Colors.grey.shade500,
                                          FontWeight.w400,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),

                          // ── Timestamp ────────────────────────────────────
                          Text(
                            time,
                            style: appstyle(
                                11, Colors.grey.shade400, FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline_rounded,
              size: 60, color: _teal.withOpacity(0.25)),
          SizedBox(height: 16.h),
          Text('No chats yet', style: appstyle(18, _navy, FontWeight.w600)),
          SizedBox(height: 6.h),
          Text('Start a conversation by applying to a job',
              style: appstyle(13, Colors.grey, FontWeight.w400)),
        ],
      ),
    );
  }
}
