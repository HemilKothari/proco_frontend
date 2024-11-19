import 'dart:convert';

CreateChat createChatFromJson(String str) =>
    CreateChat.fromJson(json.decode(str));

String createChatToJson(CreateChat data) => json.encode(data.toJson());

class CreateChat {
  CreateChat({
    required this.userId,
  });

  factory CreateChat.fromJson(Map<String, dynamic> json) => CreateChat(
        userId: json['userId'],
      );
  final String userId;

  Map<String, dynamic> toJson() => {
        'userId': userId,
      };
}
