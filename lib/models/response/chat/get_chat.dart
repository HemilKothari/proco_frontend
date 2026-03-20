import 'dart:convert';

List<GetChats> getChatsFromJson(String str) {
  final decoded = json.decode(str);

  if (decoded['success'] != true) {
    throw Exception(decoded['message'] ?? "Failed to fetch chats");
  }

  final List data = decoded['data'] ?? [];

  return data.map((e) => GetChats.fromJson(e as Map<String, dynamic>)).toList();
}

String getChatsToJson(List<GetChats> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetChats {
  final String id;
  final String chatName;
  final bool isGroupChat;
  final List<Sender> users;
  final DateTime createdAt;
  final DateTime updatedAt;
  final LatestMessage? latestMessage;

  GetChats({
    required this.id,
    required this.chatName,
    required this.isGroupChat,
    required this.users,
    required this.createdAt,
    required this.updatedAt,
    this.latestMessage,
  });

  factory GetChats.fromJson(Map<String, dynamic> json) {
    return GetChats(
      id: json['_id'] ?? '',
      chatName: json['chatName'] ?? '',
      isGroupChat: json['isGroupChat'] ?? false,
      users: (json['users'] as List?)
              ?.map((e) => Sender.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
      latestMessage: json['latestMessage'] != null
          ? LatestMessage.fromJson(
              json['latestMessage'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'chatName': chatName,
        'isGroupChat': isGroupChat,
        'users': users.map((x) => x.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'latestMessage': latestMessage?.toJson(),
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
      sender: json['sender'] is Map<String, dynamic>
          ? Sender.fromJson(json['sender'])
          : Sender.empty(),
      content: json['content'] ?? '',
      receiver: json['receiver']?.toString() ?? '',
      chat: json['chat']?.toString() ?? '',
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
