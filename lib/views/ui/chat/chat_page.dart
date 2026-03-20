import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/controllers/chat_provider.dart';
import 'package:jobhub_v1/models/request/messaging/send_message.dart';
import 'package:jobhub_v1/models/response/messaging/messaging_res.dart';
import 'package:jobhub_v1/services/helpers/messaging_helper.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/exports.dart';
import 'package:jobhub_v1/views/common/height_spacer.dart';
import 'package:jobhub_v1/views/common/loader.dart';
import 'package:jobhub_v1/views/ui/chat/widgets/textfield.dart';
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
  int offset = 1;
  IO.Socket? socket;
  late Future<List<ReceivedMessge>> msgList;

  List<ReceivedMessge> messages = [];

  final Set<String> _loadedMessageIds = {};

  bool _initialLoadDone = false;

  TextEditingController messageController = TextEditingController();
  String receiver = '';
  final ScrollController _scrollController = ScrollController();

  final socketNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    getMessages(offset);
    connect();
    joinChat();
    handleNext();
  }

  @override
  void dispose() {
    if (socket != null) {
      socket!.emit('leave chat', widget.id); // tell server you left
      socket!.disconnect();
      socket!.dispose();
      socket = null;
    }
    socketNotifier.value = false; // ✅ reset so next open starts fresh
    _scrollController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void getMessages(int offset) {
    msgList = MesssagingHelper.getMessages(widget.id, offset);
  }

  void handleNext() {
    _scrollController.addListener(() async {
      if (_scrollController.hasClients) {
        // In a reversed ListView, maxScrollExtent is the TOP (oldest messages)
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100) {
          if (messages.length >= 12) {
            offset++;
            getMessages(offset);
            setState(() {});
          }
        }
      }
    });
  }

  // ✅ FIX: Merge fetched messages without duplicates, then sort ascending
  void _mergeMessages(List<ReceivedMessge> fetched) {
    for (final msg in fetched) {
      if (!_loadedMessageIds.contains(msg.id)) {
        _loadedMessageIds.add(msg.id);
        messages.add(msg);
      }
    }

    // Sort ascending by time so reverse:true shows newest at the bottom
    messages.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
  }

  void connect() async {
    debugPrint('SOCKET CONNECTING');

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
      debugPrint('CONNECTED SOCKET');

      socketNotifier.value = true;

      socket!.emit('setup', chatNotifier.userId);

      socket!.on('online-users', (users) {
        chatNotifier.onlineUsers = List<String>.from(users);
      });

      socket!.on('typing', (_) {
        chatNotifier.typingStatus = true;
      });

      socket!.on('stop typing', (_) {
        chatNotifier.typingStatus = false;
      });

      socket!.on('message received', (data) {
        final msg = ReceivedMessge.fromJson(data);

        // Only add incoming messages from the other user and not duplicates
        if (msg.sender.id != chatNotifier.userId &&
            !_loadedMessageIds.contains(msg.id)) {
          _loadedMessageIds.add(msg.id);
          setState(() {
            messages.add(msg);
            // Keep sorted ascending after adding
            messages.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
          });
          _scrollToBottom();
        }
      });
    });

    socket!.onDisconnect((_) {
      debugPrint('SOCKET DISCONNECTED');
    });

    socket!.onError((error) {
      debugPrint('SOCKET ERROR: $error');
    });
  }

  void sendMessage(String content, String chatId, String receiver) async {
    if (content.trim().isEmpty) return;

    final model =
        SendMessage(content: content, chatId: chatId, receiver: receiver);

    final result = await MesssagingHelper.sendMessage(model);

    if (result['success']) {
      final message = result['message'] as ReceivedMessge;

      // ✅ Add to local list and ID set to prevent duplication if socket echoes it back
      if (!_loadedMessageIds.contains(message.id)) {
        _loadedMessageIds.add(message.id);
        setState(() {
          messages.add(message);
          // Keep sorted ascending so newest appears at bottom with reverse:true
          messages.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
          messageController.clear();
        });
      } else {
        setState(() {
          messageController.clear();
        });
      }

      // ✅ Scroll to bottom (index 0 in a reversed list)
      _scrollToBottom();

      // ✅ Emit via socket to notify the other user
      if (socket != null && socket!.connected) {
        socket!.emit('new message', message.toJson());
      }

      sendStopTypingEvent(widget.id);
    } else {
      debugPrint("Send failed: ${result['message']}");
    }
  }

  // ✅ Scroll to the newest message (index 0 in reverse:true list)
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendTypingEvent(String status) {
    socket?.emit('typing', status);
  }

  void sendStopTypingEvent(String status) {
    socket?.emit('stop typing', status);
  }

  void joinChat() {
    socket?.emit('join chat', widget.id);
  }

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

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.065.sh),
            child: CustomAppBar(
              text: !chatNotifier.typing ? widget.title : 'typing .....',
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.profile),
                      ),
                      Positioned(
                        right: 3,
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor:
                              chatNotifier.online.contains(receiver)
                                  ? Colors.green
                                  : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              child: Padding(
                padding: EdgeInsets.all(12.0.h),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => const MainScreen());
                  },
                  child: const Icon(MaterialCommunityIcons.arrow_left),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.h),
              child: Column(
                children: [
                  Expanded(
                    child: FutureBuilder<List<ReceivedMessge>>(
                      future: msgList,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return ReusableText(
                            text: 'Error ${snapshot.error}',
                            style: appstyle(
                              20,
                              Color(kOrange.value),
                              FontWeight.bold,
                            ),
                          );
                        } else {
                          // ✅ FIX: Merge only once per future result using a flag,
                          // preventing re-merging on every setState rebuild.
                          if (!_initialLoadDone && snapshot.data != null) {
                            _initialLoadDone = true;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                _mergeMessages(snapshot.data!);
                              });
                            });
                          } else if (snapshot.data != null) {
                            // For pagination (offset > 1), merge without flag check
                            _mergeMessages(snapshot.data!);
                          }

                          if (messages.isEmpty) {
                            return const SearchLoading(
                              text: 'You do not have any messages',
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
                            itemCount: messages.length,
                            // ✅ reverse:true — shows newest at bottom.
                            // Works correctly now that messages are sorted ascending.
                            reverse: true,
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              // ✅ FIX: With reverse:true, index 0 = last item visually (newest).
                              // We must reverse the index to display oldest → newest top → bottom.
                              final data =
                                  messages[messages.length - 1 - index];

                              return Padding(
                                padding: EdgeInsets.only(top: 8, bottom: 12.h),
                                child: Column(
                                  children: [
                                    ReusableText(
                                      text: chatNotifier.msgTime(
                                        data.updatedAt.toString(),
                                      ),
                                      style: appstyle(
                                        16,
                                        Color(kDark.value),
                                        FontWeight.normal,
                                      ),
                                    ),
                                    const HeightSpacer(size: 15),
                                    ChatBubble(
                                      alignment:
                                          data.sender.id == chatNotifier.userId
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                      backGroundColor:
                                          data.sender.id == chatNotifier.userId
                                              ? Color(kOrange.value)
                                              : Color(kLightBlue.value),
                                      elevation: 0,
                                      clipper: ChatBubbleClipper4(
                                        radius: 8,
                                        type: data.sender.id ==
                                                chatNotifier.userId
                                            ? BubbleType.sendBubble
                                            : BubbleType.receiverBubble,
                                      ),
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: width * 0.8,
                                        ),
                                        child: ReusableText(
                                          text: data.content,
                                          style: appstyle(
                                            14,
                                            Color(kLight.value),
                                            FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),

                  // ✅ Show text field only when socket is connected
                  ValueListenableBuilder(
                    valueListenable: socketNotifier,
                    builder: (_, value, __) {
                      if (value) {
                        return Container(
                          padding: EdgeInsets.all(12.h),
                          alignment: Alignment.bottomCenter,
                          child: MessaginTextField(
                            onSubmitted: (_) {
                              final msg = messageController.text;
                              sendMessage(msg, widget.id, receiver);
                            },
                            sufixIcon: GestureDetector(
                              onTap: () {
                                final msg = messageController.text;
                                sendMessage(msg, widget.id, receiver);
                              },
                              child: Icon(
                                Icons.send,
                                size: 24,
                                color: Color(kLightBlue.value),
                              ),
                            ),
                            onTapOutside: (_) {
                              sendStopTypingEvent(widget.id);
                            },
                            onChanged: (_) {
                              sendTypingEvent(widget.id);
                            },
                            onEditingComplete: () {
                              final msg = messageController.text;
                              sendMessage(msg, widget.id, receiver);
                            },
                            messageController: messageController,
                          ),
                        );
                      } else {
                        return const LinearProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
