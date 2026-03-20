import 'dart:convert';

GetJobRes getJobResFromJson(String str) {
  final decoded = json.decode(str);

  if (decoded['success'] != true) {
    throw Exception(decoded['message'] ?? "Failed to fetch job");
  }

  return GetJobRes.fromJson(decoded['data'] ?? {});
}

String getJobResToJson(GetJobRes data) => json.encode(data.toJson());

class GetJobRes {
  final String jobId;
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
  final DateTime updatedAt;

  GetJobRes({
    required this.jobId,
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
    required this.updatedAt,
  });

  factory GetJobRes.fromJson(Map<String, dynamic> json) {
    return GetJobRes(
      jobId: json['_id'] ?? "",
      title: json['title'] ?? "",
      location: json['location'] ?? "",
      company: json['company'] ?? "",
      hiring: json['hiring'] ?? false,
      description: json['description'] ?? "",
      salary: json['salary'] ?? "",
      period: json['period'] ?? "",
      contract: json['contract'] ?? "",
      requirements: json['requirements'] != null
          ? List<String>.from(json['requirements'])
          : [],
      imageUrl: json['imageUrl'] ?? "",
      agentId: json['agentId'] ?? "",
      swipedUsers: json['swipedUsers'] != null
          ? List<String>.from(json['swipedUsers'])
          : [],
      matchedUsers: json['matchedUsers'] != null
          ? List<String>.from(json['matchedUsers'])
          : [],
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': jobId,
        'title': title,
        'location': location,
        'company': company,
        'hiring': hiring,
        'description': description,
        'salary': salary,
        'period': period,
        'contract': contract,
        'requirements': requirements,
        'imageUrl': imageUrl,
        'agentId': agentId,
        'swipedUsers': swipedUsers,
        'matchedUsers': matchedUsers,
        'updatedAt': updatedAt.toIso8601String(),
      };
}
