import 'dart:convert';

ErrorRes errorResFromJson(String str) => ErrorRes.fromJson(json.decode(str));

class ErrorRes {
  ErrorRes({
    required this.status,
    required this.message,
  });

  factory ErrorRes.fromJson(Map<String, dynamic> json) => ErrorRes(
        status: json['status'],
        message: json['message'],
      );
  final bool status;
  final String message;
}
