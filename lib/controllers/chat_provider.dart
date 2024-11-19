import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobhub_v1/models/response/chat/get_chat.dart';
import 'package:jobhub_v1/services/helpers/chat_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatNotifier extends ChangeNotifier {
  late Future<List<GetChats>> chats;
  List<String> _online = [];
  bool _typing = false;

  bool get typing => _typing;

  set typingStatus(bool newState) {
    _typing = newState;
    notifyListeners();
  }

  List<String> get online => _online;

  set onlineUsers(List<String> newList) {
    _online = newList;
    notifyListeners();
  }

  String? userId;

  getChats() {
    chats = ChatHelper.getConversations();
  }

  getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
  }

  String msgTime(String timestamp) {
    final now = DateTime.now().toUtc();
    final messageTimeUtc = DateTime.parse(timestamp).toUtc();
    final messageTimeBeijing =
        messageTimeUtc.toLocal().add(const Duration(hours: 15));
    if (now.year == messageTimeBeijing.year &&
        now.month == messageTimeBeijing.month &&
        now.day == messageTimeBeijing.day) {
      return DateFormat.jm().format(messageTimeBeijing);
    } else if (now.year == messageTimeBeijing.year &&
        now.month == messageTimeBeijing.month &&
        now.day - messageTimeBeijing.day == 1) {
      return 'Yesterday';
    } else {
      return DateFormat.yMEd().format(messageTimeBeijing);
    }
  }
}
