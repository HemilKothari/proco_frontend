import 'dart:convert';

String createJobsRequestToJson(CreateJobsRequest data) =>
    json.encode(data.toJson());

class CreateJobsRequest {
  CreateJobsRequest({
    required this.agentId,
    required this.domain,
    required this.opportunityType,
    this.title = '',
    this.location = '',
    this.company = '',
    this.description = '',
    this.salary = '',
    this.period = '',
    this.hiring = true,
    this.contract = '',
    this.requirements = const [],
    this.imageUrl = '',
    this.matchedUsers = const [],
    this.swipedUsers = const [],
  });

  final String agentId;
  final String domain;
  final String opportunityType;
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
  final List<String> matchedUsers;
  final List<String> swipedUsers;

  Map<String, dynamic> toJson() => {
        'agentId': agentId,
        'domain': domain,
        'opportunityType': opportunityType,
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
        'matchedUsers': matchedUsers.map((x) => x).toList(),
        'swipedUsers': swipedUsers.map((x) => x).toList(),
      };
}
