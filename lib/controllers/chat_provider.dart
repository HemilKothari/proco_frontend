import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobhub_v1/models/response/chat/get_chat.dart';
import 'package:jobhub_v1/services/helpers/chat_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatNotifier extends ChangeNotifier {
  Future<List<GetChats>>? chats;

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

  /// ================= LOAD CHATS =================
  Future<void> getChats() async {
    try {
      chats = ChatHelper.getConversations();
      notifyListeners(); // ✅ IMPORTANT
    } catch (e) {
      debugPrint("Chat Fetch Error: $e");
    }
  }

  /// ================= GET USER ID =================
  Future<void> getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
  }

  /// ================= FORMAT MESSAGE TIME =================
  String msgTime(String timestamp) {
    try {
      final messageTime = DateTime.parse(timestamp).toLocal();
      final now = DateTime.now();

      if (now.year == messageTime.year &&
          now.month == messageTime.month &&
          now.day == messageTime.day) {
        return DateFormat.jm().format(messageTime);
      } else if (now.difference(messageTime).inDays == 1) {
        return 'Yesterday';
      } else {
        return DateFormat.yMMMd().format(messageTime);
      }
    } catch (e) {
      return '';
    }
  }
}
