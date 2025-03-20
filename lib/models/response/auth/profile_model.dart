import 'dart:convert';

ProfileRes profileResFromJson(String str) =>
    ProfileRes.fromJson(json.decode(str));

String profileResToJson(ProfileRes data) => json.encode(data.toJson());

class ProfileRes {
  ProfileRes({
    required this.id,
    required this.username,
    required this.email,
    required this.isAdmin,
    required this.isAgent,
    required this.skills,
    required this.updatedAt,
    required this.profile,
    this.phone = "1234567890",
    this.location = "",
    this.college = "",
    this.gender = "",
    this.branch = "",
    this.city = "",
    this.state = "",
    this.country = "",
    this.isFirstTimeUser = true,
  });

  factory ProfileRes.fromJson(Map<String, dynamic> json) => ProfileRes(
        id: json['_id'] ?? "",
        username: json['username'] ?? "",
        email: json['email'] ?? "",
        isAdmin: json['isAdmin'] ?? false,
        isAgent: json['isAgent'] ?? false,
        skills: json['skills'] != null
            ? List<String>.from(json['skills'].map((x) => x))
            : [],
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : DateTime.now(),
        profile: json['profile'] ??
            "https://www.pngplay.com/wp-content/uploads/12/User-Avatar-Profile-Clip-Art-Transparent-PNG.png",
        phone: json['phone'] ?? "1234567890",
        location: json['location'] ?? "",
        college: json['college'] ?? "",
        gender: json['gender'] ?? "",
        branch: json['branch'] ?? "",
        city: json['city'] ?? "",
        state: json['state'] ?? "",
        country: json['country'] ?? "",
        isFirstTimeUser: json['isFirstTimeUser'] ?? true,
      );

  final String id;
  final String username;
  final String email;
  final bool isAdmin;
  final bool isAgent;
  final List<String> skills;
  final DateTime updatedAt;
  final String profile;
  final String phone;
  final String location;
  final String college;
  final String gender;
  final String branch;
  final String city;
  final String state;
  final String country;
  final bool isFirstTimeUser;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'username': username,
        'email': email,
        'isAdmin': isAdmin,
        'isAgent': isAgent,
        'skills': skills,
        'updatedAt': updatedAt.toIso8601String(),
        'profile': profile,
        'phone': phone,
        'location': location,
        'college': college,
        'gender': gender,
        'branch': branch,
        'city': city,
        'state': state,
        'country': country,
        'isFirstTimeUser': isFirstTimeUser,
      };
}
