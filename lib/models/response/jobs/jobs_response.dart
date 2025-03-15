import 'dart:convert';

List<JobsResponse> jobsResponseFromJson(String str) =>
    (json.decode(str) as List)
        .map((e) => JobsResponse.fromJson(e as Map<String, dynamic>))
        .toList();

class JobsResponse {
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
    this.matchedUsers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobsResponse.fromJson(Map<String, dynamic> json) => JobsResponse(
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
            ? List<String>.from(json['requirements'].map((x) => x))
            : [],
        imageUrl: json['imageUrl'] ?? '',
        agentId: json['agentId'] ?? '',
        matchedUsers: json['matchedUsers'] ?? [],
        createdAt: json['createdAt'] != null && json['createdAt'] != ''
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null && json['updatedAt'] != ''
            ? DateTime.parse(json['updatedAt'])
            : DateTime.now(),
      );

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
  final List<String>? matchedUsers;
  final DateTime createdAt;
  final DateTime updatedAt;

  get isHiring => null;
}
