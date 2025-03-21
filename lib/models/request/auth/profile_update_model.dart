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
    this.profile, // Make profile optional by removing 'required' and making it nullable
    required this.skills,
    this.college = "", // Add college field as optional
    this.branch = "", // Add branch field as optional
  });

  factory ProfileUpdateReq.fromJson(Map<String, dynamic> json) =>
      ProfileUpdateReq(
        city: json['city'], // Parsing city
        state: json['state'], // Parsing state
        country: json['country'], // Parsing country
        phone: json['phone'],
        profile: json['profile'], // If profile is missing, it will be null
        skills: List<String>.from(json['skills'].map((x) => x)),
        college: json['college'] ??
            "", // If college is missing, default to empty string
        branch: json['branch'] ??
            "", // If branch is missing, default to empty string
      );

  final String city; // City field
  final String state; // State field
  final String country; // Country field
  final String phone;
  final String? profile; // Make profile nullable (can be null)
  final List<String> skills;
  final String college; // Add college field
  final String branch; // Add branch field

  Map<String, dynamic> toJson() => {
        'city': city, // Add city to the JSON
        'state': state, // Add state to the JSON
        'country': country, // Add country to the JSON
        'phone': phone,
        'profile': profile, // Will be null if not provided
        'skills': List<dynamic>.from(skills.map((x) => x)),
        'college': college, // Add college to the JSON
        'branch': branch, // Add branch to the JSON
      };
}
