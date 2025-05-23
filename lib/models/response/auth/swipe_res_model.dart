import 'dart:convert';

SwipedRes swipedResFromJson(String str) => SwipedRes.fromJson(json.decode(str));

String swipedResToJson(SwipedRes data) => json.encode(data.toJson());

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
      skills: List<String>.from(json['skills'] ?? []),
      profile: json['profile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'skills': List<dynamic>.from(skills.map((x) => x)),
        'location': location,
        'profile': profile,
      };
}
