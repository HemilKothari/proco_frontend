import 'dart:convert';

List<SwipedRes> swipedResListFromJson(String str) {
  final decoded = json.decode(str);

  if (decoded['success'] != true) {
    throw Exception(decoded['message'] ?? "Failed to fetch swiped users");
  }

  final List data = decoded['data'] ?? [];

  return data.map((e) => SwipedRes.fromJson(e)).toList();
}

class SwipedRes {
  final String id;
  final String username;
  final String location;
  final List<String> skills;
  final String profile;

  SwipedRes({
    required this.id,
    required this.username,
    required this.location,
    required this.skills,
    required this.profile,
  });

  factory SwipedRes.fromJson(Map<String, dynamic> json) {
    return SwipedRes(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      location: json['location'] ?? '',
      skills: json['skills'] != null
          ? List<String>.from(json['skills'].map((x) => x.toString()))
          : [],
      profile: json['profile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'username': username,
        'skills': skills,
        'location': location,
        'profile': profile,
      };
}
