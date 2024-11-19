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
  TextEditingController messageController = TextEditingController();
  String receiver = '';
  final ScrollController _scrollController = ScrollController();

  final socketNotifier = ValueNotifier(false);
  @override
  void initState() {
    getMessages(offset);
    connect();
    joinChat();
    handleNext();
    super.initState();
  }

  @override
  void dispose() {
    socket?.close();
    super.dispose();
  }

  void getMessages(int offset) {
    msgList = MesssagingHelper.getMessages(widget.id, offset);
  }

  void handleNext() {
    _scrollController.addListener(() async {
      if (_scrollController.hasClients) {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          if (messages.length >= 12) {
            getMessages(offset++);
            setState(() {});
          }
        }
      }
    });
  }



  void connect() async {
    debugPrint('SOCKET CONNECTING');
    final chatNotifier = Provider.of<ChatNotifier>(context, listen: false);
    socket =
        IO.io('https://f31d-101-44-82-234.ngrok-free.app', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.emit('setup', chatNotifier.userId);
    socket!.connect();
    socket!.onConnect((_) {
      debugPrint('CONNECTED SOCKET');
      socketNotifier.value = true;
      socket!.on('online-users', (userId) {
        chatNotifier.online
            .replaceRange(0, chatNotifier.online.length, [userId]);
      });

      socket!.on('typing', (status) {
        chatNotifier.typingStatus = true;
      });

      socket!.on('stop typing', (status) {
        chatNotifier.typingStatus = false;
      });

      socket!.on('message received', (newMessageReceived) {
        print(newMessageReceived);
        sendStopTypingEvent(widget.id);
        final receivedMessge = ReceivedMessge.fromJson(newMessageReceived);

        if (receivedMessge.sender.id != chatNotifier.userId) {
          setState(() {
            messages.insert(0, receivedMessge);
          });
        }
      });
    });
    socket!.onerror((error) {
      debugPrint('SOCKET ERROR: $error');
    });
  }

  void sendMessage(String content, String chatId, String receiver) {
    final model =
        SendMessage(content: content, chatId: chatId, receiver: receiver);

    MesssagingHelper.sendMessage(model).then((response) {
      final emmission = response[2];
      socket!.emit('new message', emmission);
      sendStopTypingEvent(widget.id);
      setState(() {
        messageController.clear();
      });
    });
  }

  void sendTypingEvent(String status) {
    socket!.emit('typing', status);
  }

  void sendStopTypingEvent(String status) {
    socket!.emit('stop typing', status);
  }

  void joinChat() {
    socket!.emit('join chat', widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatNotifier>(
      builder: (context, chatNotifier, child) {
        // Fix: Bad state: No element for all the places [
        // .first] was used when the list was empty
        if (widget.user.isNotEmpty) {
          receiver = widget.user.firstWhere(
            (id) => id != chatNotifier.userId,
            orElse: () => '651815ae14b96155c15c3c12',
          );
        }
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
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
                        } else if (snapshot.data!.isEmpty) {
                          return const SearchLoading(
                            text: 'You do not have message',
                          );
                        } else {
                          final msgList = snapshot.data;
                          // messages = (messages + msgList!).toSet().toList();
                          messages = messages + msgList!;

                          return ListView.builder(
                            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
                            itemCount: messages.length,
                            reverse: true,
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              final data = messages[index];

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
                    ValueListenableBuilder(
                        valueListenable: socketNotifier,
                        builder: (_, value, __){
                          if(value){
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
                          }else{
                            return LinearProgressIndicator();
                          }
                        }
                    )


                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
