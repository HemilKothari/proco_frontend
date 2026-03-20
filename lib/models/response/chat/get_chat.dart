import 'dart:convert';

/// 🔹 Decode function (handles wrapper)
List<GetChats> getChatsFromJson(String str) {
  final decoded = json.decode(str);

  if (decoded['success'] != true) {
    throw Exception(decoded['message'] ?? "Failed to fetch chats");
  }

  final List data = decoded['data'] ?? [];

  return data.map((e) => GetChats.fromJson(e)).toList();
}

/// 🔹 Encode
String getChatsToJson(List<GetChats> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetChats {
  final String id;
  final String chatName;
  final bool isGroupChat;
  final List<Sender> users;
  final DateTime createdAt;
  final DateTime updatedAt;
  final LatestMessage latestMessage;

  GetChats({
    required this.id,
    required this.chatName,
    required this.isGroupChat,
    required this.users,
    required this.createdAt,
    required this.updatedAt,
    required this.latestMessage,
  });

  factory GetChats.fromJson(Map<String, dynamic> json) {
    return GetChats(
      id: json['_id'] ?? '',
      chatName: json['chatName'] ?? '',
      isGroupChat: json['isGroupChat'] ?? false,

      /// ✅ FIXED mapping
      users: json['users'] != null
          ? (json['users'] as List)
              .map((e) => Sender.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],

      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),

      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),

      latestMessage: json['latestMessage'] != null
          ? LatestMessage.fromJson(
              json['latestMessage'] as Map<String, dynamic>)
          : LatestMessage.empty(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'chatName': chatName,
        'isGroupChat': isGroupChat,
        'users': users.map((x) => x.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'latestMessage': latestMessage.toJson(),
      };
}

class LatestMessage {
  final String id;
  final Sender sender;
  final String content;
  final String receiver;
  final String chat;

  LatestMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.receiver,
    required this.chat,
  });

  factory LatestMessage.fromJson(Map<String, dynamic> json) {
    return LatestMessage(
      id: json['_id'] ?? '',
      sender: json['sender'] != null
          ? Sender.fromJson(json['sender'] as Map<String, dynamic>)
          : Sender.empty(),
      content: json['content'] ?? '',
      receiver: json['receiver'] ?? '',
      chat: json['chat'] ?? '',
    );
  }

  /// ✅ fallback to prevent crashes
  factory LatestMessage.empty() {
    return LatestMessage(
      id: '',
      sender: Sender.empty(),
      content: '',
      receiver: '',
      chat: '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'sender': sender.toJson(),
        'content': content,
        'receiver': receiver,
        'chat': chat,
      };
}

class Sender {
  final String id;
  final String username;
  final String email;
  final String profile;

  Sender({
    required this.id,
    required this.username,
    required this.email,
    required this.profile,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      profile: json['profile'] ?? '',
    );
  }

  /// ✅ fallback
  factory Sender.empty() {
    return Sender(
      id: '',
      username: '',
      email: '',
      profile: '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'username': username,
        'email': email,
        'profile': profile,
      };
}
