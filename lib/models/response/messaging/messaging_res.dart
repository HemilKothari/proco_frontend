import 'dart:convert';

List<ReceivedMessge> receivedMessgeFromJson(String str) {
  final decoded = json.decode(str);

  if (decoded['success'] != true) {
    throw Exception(decoded['message'] ?? "Failed to fetch messages");
  }

  final List data = decoded['data'] ?? [];

  return data
      .map((e) => ReceivedMessge.fromJson(e as Map<String, dynamic>))
      .toList();
}

class ReceivedMessge {
  final String id;
  final Sender sender;
  final String content;
  final String chat; // chatId
  final List<String> readBy;
  final DateTime updatedAt;

  ReceivedMessge({
    required this.id,
    required this.sender,
    required this.content,
    required this.chat,
    required this.readBy,
    required this.updatedAt,
  });

  factory ReceivedMessge.fromJson(Map<String, dynamic> json) {
    return ReceivedMessge(
      id: json['_id'] ?? '',

      sender: json['sender'] is Map<String, dynamic>
          ? Sender.fromJson(json['sender'])
          : Sender.empty(),

      content: json['content'] ?? '',

      /// ✅ chat can be string OR object
      chat: json['chat'] is String ? json['chat'] : json['chat']?['_id'] ?? '',

      readBy:
          (json['readBy'] as List?)?.map((e) => e.toString()).toList() ?? [],

      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "sender": sender.toJson(),
        "content": content,
        "chat": chat,
        "readBy": readBy,
        "updatedAt": updatedAt.toIso8601String(),
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
        "_id": id,
        "username": username,
        "email": email,
        "profile": profile,
      };
}
