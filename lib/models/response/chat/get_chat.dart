import 'dart:convert';

//  FIX: ERROR: type '(Map<String, dynamic>) => Sender' is not a subtype of type '(dynamic) => dynamic' of 'f'
List<GetChats> getChatsFromJson(String str) => (json.decode(str) as List)
    .cast<Map<String, dynamic>>()
    .map(GetChats.fromJson)
    .toList();

String getChatsToJson(List<GetChats> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetChats {
  GetChats({
    required this.id,
    required this.chatName,
    required this.isGroupChat,
    required this.users,
    required this.createdAt,
    required this.updatedAt,
    required this.latestMessage,
  });

  // FIX: ERROR: type '(Map<String, dynamic>) => Sender' is not a subtype of type '(dynamic) => dynamic' of 'f'
  factory GetChats.fromJson(Map<String, dynamic> json) => GetChats(
        id: json['_id'],
        chatName: json['chatName'],
        isGroupChat: json['isGroupChat'],
        users: List<Sender>.from(
          (json['users'] as List)
              .cast<Map<String, dynamic>>()
              .map(Sender.fromJson),
        ),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        latestMessage: LatestMessage.fromJson(json['latestMessage']),
      );
  final String id;
  final String chatName;
  final bool isGroupChat;
  final List<Sender> users;
  final DateTime createdAt;
  final DateTime updatedAt;
  final LatestMessage latestMessage;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'chatName': chatName,
        'isGroupChat': isGroupChat,
        'users': List<dynamic>.from(users.map((x) => x.toJson())),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'latestMessage': latestMessage.toJson(),
      };
}

class LatestMessage {
  LatestMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.receiver,
    required this.chat,
  });

  factory LatestMessage.fromJson(Map<String, dynamic> json) => LatestMessage(
        id: json['_id'],
        sender: Sender.fromJson(json['sender']),
        content: json['content'],
        receiver: json['receiver'],
        chat: json['chat'],
      );
  final String id;
  final Sender sender;
  final String content;
  final String receiver;
  final String chat;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'sender': sender.toJson(),
        'content': content,
        'receiver': receiver,
        'chat': chat,
      };
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

  Map<String, dynamic> toJson() => {
        '_id': id,
        'username': username,
        'email': email,
        'profile': profile,
      };
}
