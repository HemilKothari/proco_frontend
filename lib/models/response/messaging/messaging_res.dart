import 'dart:convert';

// FIX: Error Occurred: -------------- type '(Map<String, dynamic>) => ReceivedMessge' is not a subtype of type '(dynamic) => dynamic' of 'f' ---------------
List<ReceivedMessge> receivedMessgeFromJson(String str) =>
    List<ReceivedMessge>.from(
      (json.decode(str) as List)
          .cast<Map<String, dynamic>>()
          .map(ReceivedMessge.fromJson),
    );

class ReceivedMessge {
  ReceivedMessge({
    required this.id,
    required this.sender,
    required this.content,
    required this.chat,
    required this.readBy,
    required this.updatedAt,
    required this.v,
  });

  factory ReceivedMessge.fromJson(Map<String, dynamic> json) => ReceivedMessge(
        id: json['_id'],
        sender: Sender.fromJson(json['sender']),
        content: json['content'],
        updatedAt: DateTime.parse(json['updatedAt']),
        chat: Chat.fromJson(json['chat']),
        readBy: List<dynamic>.from(json['readBy'].map((x) => x)),
        v: json['__v'],
      );
  final String id;
  final Sender sender;
  final String content;
  final Chat chat;
  final DateTime updatedAt;
  final List<dynamic> readBy;
  final int v;
}

class Chat {
  Chat({
    required this.id,
    required this.chatName,
    required this.isGroupChat,
    required this.users,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.latestMessage,
  });

  // FIX: Error Occurred: -------------- type '(Map<String, dynamic>) => Sender' is not a subtype of type '(dynamic) => dynamic' of 'f' ---------------
  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json['_id'],
        chatName: json['chatName'],
        isGroupChat: json['isGroupChat'],
        users: List<Sender>.from((json['users'] as List)
            .cast<Map<String, dynamic>>()
            .map(Sender.fromJson)),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
        latestMessage: json['latestMessage'] ?? '',
      );
  final String id;
  final String chatName;
  final bool isGroupChat;
  final List<Sender> users;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String latestMessage;
}

class Sender {
  Sender({
    required this.id,
    required this.username,
    required this.email,
    required this.profile,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json['_id'],
        username: json['username'],
        email: json['email'],
        profile: json['profile'],
      );
  final String id;
  final String username;
  final String email;
  final String profile;
}
