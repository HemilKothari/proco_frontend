import 'dart:convert';

List<JobsResponse> jobsResponseFromJson(String str) {
  final decoded = json.decode(str);

  if (decoded['success'] != true) {
    throw Exception(decoded['message'] ?? "Failed to fetch jobs");
  }

  final List dataList = decoded['data'] ?? [];

  return dataList
      .map((e) => JobsResponse.fromJson(e as Map<String, dynamic>))
      .toList();
}

class JobsResponse {
  final String id;
  final String title;
  final String location;
  final String company;
  final bool hiring;
  final String description;
  final String salary;
  final String period;
  final String contract;
  final List<String> requirements;
  final String imageUrl;
  final String agentId;
  final List<String> swipedUsers;
  final List<String> matchedUsers;
  final DateTime createdAt;
  final DateTime updatedAt;

  JobsResponse({
    required this.id,
    required this.title,
    required this.location,
    required this.company,
    required this.hiring,
    required this.description,
    required this.salary,
    required this.period,
    required this.contract,
    required this.requirements,
    required this.imageUrl,
    required this.agentId,
    required this.swipedUsers,
    required this.matchedUsers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobsResponse.fromJson(Map<String, dynamic> json) {
    return JobsResponse(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      company: json['company'] ?? '',
      hiring: json['hiring'] ?? false,
      description: json['description'] ?? '',
      salary: json['salary'] ?? '',
      period: json['period'] ?? '',
      contract: json['contract'] ?? '',
      requirements: json['requirements'] != null
          ? List<String>.from(json['requirements'].map((x) => x.toString()))
          : [],
      imageUrl: json['imageUrl'] ?? '',
      agentId: json['agentId'] ?? '',
      swipedUsers: json['swipedUsers'] != null
          ? List<String>.from(json['swipedUsers'].map((x) => x.toString()))
          : [],
      matchedUsers: json['matchedUsers'] != null
          ? List<String>.from(json['matchedUsers'].map((x) => x.toString()))
          : [],
      createdAt: json['createdAt'] != null && json['createdAt'] != ''
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null && json['updatedAt'] != ''
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}
