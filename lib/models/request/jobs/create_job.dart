import 'dart:convert';

String createJobsRequestToJson(CreateJobsRequest data) => json.encode(data.toJson());

class CreateJobsRequest {
  CreateJobsRequest({
    required this.title,
    required this.location,
    required this.company,
    required this.description,
    required this.salary,
    required this.period,
    required this.hiring,
    required this.contract,
    required this.requirements,
    required this.imageUrl,
    required this.agentId,
  });

  final String title;
  final String location;
  final String company;
  final String description;
  final String salary;
  final String period;
  final bool hiring;
  final String contract;
  final List<String> requirements;
  final String imageUrl;
  final String agentId;

  Map<String, dynamic> toJson() => {
        'title': title,
        'location': location,
        'company': company,
        'description': description,
        'salary': salary,
        'period': period,
        'hiring': hiring,
        'contract': contract,
        'requirements': requirements.map((x) => x).toList(),
        'imageUrl': imageUrl,
        'agentId': agentId,
      };
}
