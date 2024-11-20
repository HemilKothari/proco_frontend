import 'dart:convert';

ProfileUpdateReq profileUpdateReqFromJson(String str) =>
    ProfileUpdateReq.fromJson(json.decode(str));

String profileUpdateReqToJson(ProfileUpdateReq data) =>
    json.encode(data.toJson());

class ProfileUpdateReq {
  ProfileUpdateReq({
    required this.location,
    required this.phone,
    this.profile,  // Make profile optional by removing 'required' and making it nullable
    required this.skills,
  });

  factory ProfileUpdateReq.fromJson(Map<String, dynamic> json) =>
      ProfileUpdateReq(
        location: json['location'],
        phone: json['phone'],
        profile: json['profile'],  // If profile is missing, it will be null
        skills: List<String>.from(json['skills'].map((x) => x)),
      );

  final String location;
  final String phone;
  final String? profile;  // Make profile nullable (can be null)
  final List<String> skills;

  Map<String, dynamic> toJson() => {
        'location': location,
        'phone': phone,
        'profile': profile,  // Will be null if not provided
        'skills': List<dynamic>.from(skills.map((x) => x)),
      };
}
