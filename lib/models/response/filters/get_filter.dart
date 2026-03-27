import 'dart:convert';

GetFilterRes getFilterResFromJson(String str) {
  final decoded = json.decode(str);
  // Backend wraps response as {message, data} — unwrap data key
  final map = (decoded is Map && decoded.containsKey('data'))
      ? decoded['data'] as Map<String, dynamic>
      : decoded as Map<String, dynamic>;
  return GetFilterRes.fromJson(map);
}

String getFilterResToJson(GetFilterRes data) => json.encode(data.toJson());

class GetFilterRes {
  GetFilterRes({
    required this.id,
    required this.selectedOptions,
    required this.opportunityTypes,
    required this.selectedLocationOption,
    required this.selectedCity,
    required this.selectedState,
    required this.selectedCountry,
    required this.customOptions,
    required this.skills,
    required this.sortByTime,
    required this.postedWithin,
  });

  factory GetFilterRes.fromJson(Map<String, dynamic> json) => GetFilterRes(
        id: json['_id'] ?? '',
        selectedOptions: json['selectedOptions'] != null
            ? List<String>.from(json['selectedOptions'].map((x) => x))
            : [],
        opportunityTypes: json['opportunityTypes'] != null
            ? Map<String, bool>.from(
                (json['opportunityTypes'] as Map).map(
                    (k, v) => MapEntry(k.toString(), v == true)))
            : {},
        selectedLocationOption: json['selectedLocationOption'] ?? '',
        selectedCity: json['selectedCity'] ?? '',
        selectedState: json['selectedState'] ?? '',
        selectedCountry: json['selectedCountry'] ?? '',
        customOptions: json['customOptions'] != null
            ? List<String>.from(json['customOptions'].map((x) => x))
            : [],
        skills: json['skills'] != null
            ? List<String>.from(json['skills'].map((x) => x))
            : [],
        sortByTime: json['sortByTime'] == true,
        postedWithin: json['postedWithin'] as String? ?? '',
      );

  final String id;
  final List<String> selectedOptions;
  final Map<String, bool> opportunityTypes;
  final String selectedLocationOption;
  final String selectedCity;
  final String selectedState;
  final String selectedCountry;
  final List<String> customOptions;
  final List<String> skills;
  final bool sortByTime;
  final String postedWithin;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'selectedOptions': List<dynamic>.from(selectedOptions.map((x) => x)),
        'opportunityTypes': Map<String, dynamic>.from(
            opportunityTypes.map((k, v) => MapEntry(k, v))),
        'selectedLocationOption': selectedLocationOption,
        'selectedCity': selectedCity,
        'selectedState': selectedState,
        'selectedCountry': selectedCountry,
        'customOptions': List<dynamic>.from(customOptions.map((x) => x)),
        'skills': List<dynamic>.from(skills.map((x) => x)),
        'sortByTime': sortByTime,
        'postedWithin': postedWithin,
      };
}
