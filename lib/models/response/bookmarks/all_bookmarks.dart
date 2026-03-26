import 'dart:convert';

List<AllBookmark> allBookmarkFromJson(String str) => List<AllBookmark>.from(
      json.decode(str).map(AllBookmark.fromJson),
    );

class AllBookmark {
  AllBookmark({
    required this.id,
    required this.job,
    required this.userId,
  });

  factory AllBookmark.fromJson(Map<String, dynamic> json) => AllBookmark(
        id: json['_id'],
        job: Job.fromJson(json['job']),
        userId: json['userId'],
      );
  final String id;
  final Job job;
  final String userId;
}

class Job {
  Job({
    required this.id,
    required this.title,
    required this.location,
    required this.company,
    required this.salary,
    required this.period,
    required this.contract,
    required this.imageUrl,
    required this.hiring,
    required this.agentId,
  });

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        location: json['location'] ?? '',
        company: json['company'] ?? '',
        salary: json['salary'] ?? '',
        period: json['period'] ?? '',
        contract: json['contract'] ?? '',
        imageUrl: json['imageUrl'] ?? '',
        hiring: json['hiring'] ?? true,
        agentId: json['agentId'] ?? '',
      );
  final String id;
  final String title;
  final String location;
  final String company;
  final String salary;
  final String period;
  final String contract;
  final String imageUrl;
  final bool hiring;
  final String agentId;
}
