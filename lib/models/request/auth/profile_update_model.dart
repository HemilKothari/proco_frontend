import 'dart:convert';

ProfileUpdateReq profileUpdateReqFromJson(String str) =>
    ProfileUpdateReq.fromJson(json.decode(str));

String profileUpdateReqToJson(ProfileUpdateReq data) =>
    json.encode(data.toJson());

class ProfileUpdateReq {
  ProfileUpdateReq({
    required this.city,
    required this.state,
    required this.country,
    required this.phone,
    this.profile,
    required this.skills,
    this.college = "",
    this.branch = "",
    this.gender,
  });

  factory ProfileUpdateReq.fromJson(Map<String, dynamic> json) =>
      ProfileUpdateReq(
        city: json['city'],
        state: json['state'],
        country: json['country'],
        phone: json['phone'],
        profile: json['profile'],
        skills: List<String>.from(json['skills'].map((x) => x)),
        college: json['college'] ?? "",
        branch: json['branch'] ?? "",
        gender: json['gender'],
      );

  final String city;
  final String state;
  final String country;
  final String phone;
  final String? profile;
  final List<String> skills;
  final String college;
  final String branch;
  final String? gender;

  Map<String, dynamic> toJson() => {
        'city': city,
        'state': state,
        'country': country,
        'phone': phone,
        'profile': profile,
        'skills': List<dynamic>.from(skills.map((x) => x)),
        'college': college,
        'branch': branch,
        if (gender != null) 'gender': gender,
      };
}
