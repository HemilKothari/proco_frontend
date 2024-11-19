import 'dart:convert';

BookmarkReqResModel bookmarkReqResModelFromJson(String str) =>
    BookmarkReqResModel.fromJson(json.decode(str));

String bookmarkReqResModelToJson(BookmarkReqResModel data) =>
    json.encode(data.toJson());

class BookmarkReqResModel {
  BookmarkReqResModel({
    required this.job,
  });

  factory BookmarkReqResModel.fromJson(Map<String, dynamic> json) =>
      BookmarkReqResModel(
        job: json['job'],
      );
  final String job;

  Map<String, dynamic> toJson() => {
        'job': job,
      };
}
