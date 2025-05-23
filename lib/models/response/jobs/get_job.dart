import 'dart:convert';

GetJobRes getJobResFromJson(String str) => GetJobRes.fromJson(json.decode(str));

String getJobResToJson(GetJobRes data) => json.encode(data.toJson());

class GetJobRes {
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
    this.swipedUsers,
    this.matchedUsers,
    required this.updatedAt,
  });

  factory GetJobRes.fromJson(Map<String, dynamic> json) => GetJobRes(
        jobId: json['_id'],
        title: json['title'],
        location: json['location'],
        company: json['company'],
        hiring: json['hiring'],
        description: json['description'],
        salary: json['salary'],
        period: json['period'],
        contract: json['contract'],
        requirements: List<String>.from(json['requirements'].map((x) => x)),
        imageUrl: json['imageUrl'],
        // Fix: added this to fix 'Null' Type error
        agentId: json['agentId'] ?? '',
        swipedUsers: json['swipedUsers'] ?? [],
        matchedUsers: json['matchedUsers'] ?? [],
        updatedAt: DateTime.parse(json['updatedAt']),
      );

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
  final List<String>? swipedUsers;
  final List<String>? matchedUsers;
  final DateTime updatedAt;

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
        'requirements': List<dynamic>.from(requirements.map((x) => x)),
        'imageUrl': imageUrl,
        'agentId': agentId,
        'swipedUsers': swipedUsers,
        'matchedUsers': matchedUsers,
        'updatedAt': updatedAt.toIso8601String(),
      };
}
