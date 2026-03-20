import 'dart:convert';

List<MatchedRes> matchedResListFromJson(String str) {
  final decoded = json.decode(str);

  if (decoded['success'] != true) {
    throw Exception(decoded['message'] ?? "Failed to fetch matched users");
  }

  final List data = decoded['data'] ?? [];

  return data.map((e) => MatchedRes.fromJson(e)).toList();
}

class MatchedRes {
  final String id;
  final String username;
  final String location;
  final List<String> skills;
  final String profile;

  MatchedRes({
    required this.id,
    required this.username,
    required this.location,
    required this.skills,
    required this.profile,
  });

  factory MatchedRes.fromJson(Map<String, dynamic> json) {
    return MatchedRes(
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
