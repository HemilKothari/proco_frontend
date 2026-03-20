import 'dart:convert';

InitialChat initialChatFromJson(String str) {
  final decoded = json.decode(str);

  if (decoded['success'] != true) {
    throw Exception(decoded['message'] ?? "Failed to create/get chat");
  }

  return InitialChat.fromJson(decoded['data'] ?? {});
}

String initialChatToJson(InitialChat data) => json.encode(data.toJson());

class InitialChat {
  final String id;

  InitialChat({
    required this.id,
  });

  factory InitialChat.fromJson(Map<String, dynamic> json) {
    return InitialChat(
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
      };
}
