import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/controllers/chat_provider.dart';
import 'package:jobhub_v1/models/request/messaging/send_message.dart';
import 'package:jobhub_v1/models/response/messaging/messaging_res.dart';
import 'package:jobhub_v1/services/helpers/messaging_helper.dart';
import 'package:jobhub_v1/views/common/exports.dart';
import 'package:jobhub_v1/views/ui/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  const ChatPage({
    required this.title,
    required this.id,
    required this.profile,
    required this.user,
    super.key,
  });

  final String title;
  final String id;
  final String profile;
  final List<String> user;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // ─── Theme ────────────────────────────────────────────────────────────────
  static const Color _teal = Color(0xFF08979F);
  static const Color _navy = Color(0xFF040326);
  static const Color _bgChat = Color(0xFFF4F6FA);
  static const Color _sentBg = Color(0xFF08979F);
  static const Color _recvBg = Colors.white;

  // ─── State ────────────────────────────────────────────────────────────────
  int offset = 1;
  IO.Socket? socket;
  late Future<List<ReceivedMessge>> msgList;
  List<ReceivedMessge> messages = [];
  final Set<String> _loadedMessageIds = {};
  bool _initialLoadDone = false;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _socketNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _sendingNotifier = ValueNotifier(false);

  String receiver = '';

  @override
  void initState() {
    super.initState();
    getMessages(offset);
    connect();
    joinChat();
    _handlePagination();
  }

  @override
  void dispose() {
    if (socket != null) {
      socket!.emit('leave chat', widget.id);
      socket!.disconnect();
      socket!.dispose();
      socket = null;
    }
    _socketNotifier.value = false;
    _scrollController.dispose();
    _messageController.dispose();
    _sendingNotifier.dispose();
    super.dispose();
  }

  // ─── Data ─────────────────────────────────────────────────────────────────
  void getMessages(int offset) {
    msgList = MesssagingHelper.getMessages(widget.id, offset);
  }

  void _handlePagination() {
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          messages.length >= 12) {
        offset++;
        getMessages(offset);
        setState(() {});
      }
    });
  }

  void _mergeMessages(List<ReceivedMessge> fetched) {
    for (final msg in fetched) {
      if (!_loadedMessageIds.contains(msg.id)) {
        _loadedMessageIds.add(msg.id);
        messages.add(msg);
      }
    }
    messages.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
  }

  // ─── Socket ───────────────────────────────────────────────────────────────
  void connect() async {
    if (socket != null) {
      socket!.disconnect();
      socket!.dispose();
      socket = null;
    }

    final chatNotifier = context.read<ChatNotifier>();

    socket = IO.io(
      'http://10.0.2.2:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableForceNewConnection()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      _socketNotifier.value = true;
      socket!.emit('setup', chatNotifier.userId);
      socket!.on('online-users',
          (users) => chatNotifier.onlineUsers = List<String>.from(users));
      socket!.on('typing', (_) => chatNotifier.typingStatus = true);
      socket!.on('stop typing', (_) => chatNotifier.typingStatus = false);
      socket!.on('message received', (data) {
        final msg = ReceivedMessge.fromJson(data);
        if (msg.sender.id != chatNotifier.userId &&
            !_loadedMessageIds.contains(msg.id)) {
          _loadedMessageIds.add(msg.id);
          setState(() {
            messages.add(msg);
            messages.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
          });
          _scrollToBottom();
        }
      });
    });

    socket!.onDisconnect((_) => debugPrint('SOCKET DISCONNECTED'));
    socket!.onError((e) => debugPrint('SOCKET ERROR: $e'));
  }

  // ─── Messaging ────────────────────────────────────────────────────────────
  Future<void> _sendMessage(String content, String chatId, String recv) async {
    if (content.trim().isEmpty) return;
    _sendingNotifier.value = true;

    final result = await MesssagingHelper.sendMessage(
        SendMessage(content: content, chatId: chatId, receiver: recv));

    _sendingNotifier.value = false;

    if (result['success']) {
      final message = result['message'] as ReceivedMessge;
      if (!_loadedMessageIds.contains(message.id)) {
        _loadedMessageIds.add(message.id);
        setState(() {
          messages.add(message);
          messages.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
          _messageController.clear();
        });
      } else {
        setState(() => _messageController.clear());
      }
      _scrollToBottom();
      socket?.emit('new message', message.toJson());
      socket?.emit('stop typing', widget.id);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void _sendTyping() => socket?.emit('typing', widget.id);
  void _stopTyping() => socket?.emit('stop typing', widget.id);
  void joinChat() => socket?.emit('join chat', widget.id);

  // ─── Options menu ─────────────────────────────────────────────────────────
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
              child: Text('Chat Options',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500)),
            ),
            const Divider(height: 1),
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    color: Colors.redAccent, size: 20),
              ),
              title: const Text('Delete Chat',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent,
                      fontSize: 15)),
              subtitle: Text('Permanently remove this conversation',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.grey.shade400)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context);
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Chat',
            style:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700)),
        content: const Text(
            'Are you sure you want to delete this conversation? This cannot be undone.',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(
                    color: Colors.grey.shade500, fontFamily: 'Poppins')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // ✅ Wire up your delete API here:
              // await ChatHelper.deleteChat(widget.id);
              Get.offAll(() => const MainScreen());
            },
            child: const Text('Delete',
                style: TextStyle(
                    color: Colors.redAccent,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatNotifier>(
      builder: (context, chatNotifier, child) {
        if (widget.user.isNotEmpty) {
          receiver = widget.user.firstWhere(
            (id) => id != chatNotifier.userId,
            orElse: () => '651815ae14b96155c15c3c12',
          );
        }

        final isOnline = chatNotifier.online.contains(receiver);

        return Scaffold(
          backgroundColor: _bgChat,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(64.h),
            child: Container(
              color: Colors.white,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                  child: Row(
                    children: [
                      // Back
                      GestureDetector(
                        onTap: () => Get.to(() => const MainScreen()),
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: _teal.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: _teal, size: 16),
                        ),
                      ),
                      SizedBox(width: 10.w),

                      // Avatar + online dot
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 20.r,
                            backgroundImage: NetworkImage(widget.profile),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 11,
                              height: 11,
                              decoration: BoxDecoration(
                                color: isOnline
                                    ? Colors.green
                                    : Colors.grey.shade400,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10.w),

                      // Name + online status
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              chatNotifier.typing ? 'typing...' : widget.title,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: chatNotifier.typing ? _teal : _navy,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              isOnline ? 'Online' : 'Offline',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11.sp,
                                color: isOnline ? Colors.green : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Three-dot menu
                      IconButton(
                        icon: const Icon(Icons.more_vert_rounded, color: _navy),
                        onPressed: () => _showOptions(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // ── Messages ────────────────────────────────────────────
                Expanded(
                  child: FutureBuilder<List<ReceivedMessge>>(
                    future: msgList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(color: _teal));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error ${snapshot.error}',
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontFamily: 'Poppins',
                                  fontSize: 14.sp)),
                        );
                      } else {
                        if (!_initialLoadDone && snapshot.data != null) {
                          _initialLoadDone = true;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() => _mergeMessages(snapshot.data!));
                          });
                        } else if (snapshot.data != null) {
                          _mergeMessages(snapshot.data!);
                        }

                        if (messages.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.chat_bubble_outline_rounded,
                                    size: 52, color: _teal.withOpacity(0.25)),
                                SizedBox(height: 12.h),
                                Text('No messages yet',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15.sp,
                                        color: Colors.grey)),
                                Text('Say hello 👋',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13.sp,
                                        color: Colors.grey.shade400)),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 6.h),
                          itemCount: messages.length,
                          reverse: true,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            final data = messages[messages.length - 1 - index];
                            final isMine =
                                data.sender.id == chatNotifier.userId;

                            // Show time if first msg or > 5 min gap
                            bool showTime = index == messages.length - 1;
                            if (!showTime && index < messages.length - 1) {
                              final prev =
                                  messages[messages.length - 2 - index];
                              showTime = data.updatedAt
                                      .difference(prev.updatedAt)
                                      .inMinutes
                                      .abs() >
                                  5;
                            }

                            return _buildBubble(
                                data, isMine, chatNotifier, showTime);
                          },
                        );
                      }
                    },
                  ),
                ),

                // ── Input bar ──────────────────────────────────────────
                ValueListenableBuilder<bool>(
                  valueListenable: _socketNotifier,
                  builder: (_, connected, __) {
                    if (!connected) {
                      return const SizedBox(
                        height: 3,
                        child: LinearProgressIndicator(color: _teal),
                      );
                    }
                    return _buildInputBar();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Bubble ───────────────────────────────────────────────────────────────
  Widget _buildBubble(ReceivedMessge data, bool isMine,
      ChatNotifier chatNotifier, bool showTime) {
    return Column(
      children: [
        if (showTime)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                chatNotifier.msgTime(data.updatedAt.toString()),
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11.sp,
                    color: Colors.grey.shade600),
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(bottom: 4.h),
          child: Row(
            mainAxisAlignment:
                isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Avatar for received messages
              if (!isMine) ...[
                CircleAvatar(
                  radius: 13.r,
                  backgroundImage: NetworkImage(widget.profile),
                ),
                SizedBox(width: 6.w),
              ],

              // Bubble
              Container(
                constraints: BoxConstraints(maxWidth: width * 0.70),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isMine ? _sentBg : _recvBg,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isMine ? 18 : 4),
                    bottomRight: Radius.circular(isMine ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  data.content,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.sp,
                    color: isMine ? Colors.white : _navy,
                    height: 1.4,
                  ),
                ),
              ),

              if (isMine) SizedBox(width: 6.w),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Input bar ────────────────────────────────────────────────────────────
  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Input field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _bgChat,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _teal.withOpacity(0.2), width: 1),
              ),
              child: TextField(
                controller: _messageController,
                style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 14.sp, color: _navy),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) =>
                    _sendMessage(_messageController.text, widget.id, receiver),
                onChanged: (_) => _sendTyping(),
                onTapOutside: (_) => _stopTyping(),
                decoration: InputDecoration(
                  hintText: 'Type a message…',
                  hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.sp,
                      color: Colors.grey.shade400),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // Send button
          ValueListenableBuilder<bool>(
            valueListenable: _sendingNotifier,
            builder: (_, sending, __) => GestureDetector(
              onTap: sending
                  ? null
                  : () => _sendMessage(
                      _messageController.text, widget.id, receiver),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: sending ? _teal.withOpacity(0.5) : _teal,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _teal.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: sending
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
