import 'dart:convert';

String createFilterRequestToJson(CreateFilterRequest data) => json.encode(data.toJson());

class CreateFilterRequest {
  CreateFilterRequest({
    required this.agentId,
    this.selectedOptions,
    this.opportunityTypes,
    this.selectedLocationOption,
    this.selectedCity,
    this.selectedState,
    this.selectedCountry,
    this.customOptions,
    this.skills,
    this.sortByTime,
    this.postedWithin,
  });

  final String agentId;
  final List<String>? selectedOptions;
  final Map<String, bool>? opportunityTypes;
  final String? selectedLocationOption;
  final String? selectedCity;
  final String? selectedState;
  final String? selectedCountry;
  final List<String>? customOptions;
  final List<String>? skills;
  final bool? sortByTime;
  final String? postedWithin;

  Map<String, dynamic> toJson() => {
        'agentId': agentId,
        'selectedOptions': selectedOptions?.map((x) => x).toList(),
        'opportunityTypes': opportunityTypes?.map((k, v) => MapEntry(k, v)),
        'selectedLocationOption': selectedLocationOption,
        'selectedCity': selectedCity,
        'selectedState': selectedState,
        'selectedCountry': selectedCountry,
        'customOptions': customOptions?.map((x) => x).toList(),
        'skills': skills?.map((x) => x).toList(),
        'sortByTime': sortByTime,
        'postedWithin': postedWithin,
      };
}
