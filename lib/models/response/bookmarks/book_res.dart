import 'dart:convert';

BookMarkReqRes bookMarkReqResFromJson(String str) =>
    BookMarkReqRes.fromJson(json.decode(str));

class BookMarkReqRes {
  BookMarkReqRes({
    required this.id,
  });

  factory BookMarkReqRes.fromJson(Map<String, dynamic> json) => BookMarkReqRes(
        id: json['_id'],
      );
  final String id;
}
