import 'dart:convert';

List<FilterResponse> filterResponseFromJson(String str) =>
    (json.decode(str) as List)
        .map((e) => FilterResponse.fromJson(e as Map<String, dynamic>))
        .toList();

class FilterResponse {
  FilterResponse({
    required this.id,
    required this.selectedOptions,
    required this.opportunityTypes,
    required this.selectedLocationOption,
    required this.locationDistance,
    required this.selectedState,
    required this.enteredCountry,
    required this.customOptions,
    required this.updatedAt,
  });

  factory FilterResponse.fromJson(Map<String, dynamic> json) => FilterResponse(
        id: json['_id'] ?? '',
        selectedOptions: json['selectedOptions'] != null
            ? List<String>.from(json['selectedOptions'].map((x) => x))
            : [],
        opportunityTypes: json['opportunityTypes'] != null
            ? Map<String, bool>.from(json['opportunityTypes'])
            : {},
        selectedLocationOption: json['selectedLocationOption'] ?? '',
        locationDistance: json['locationDistance'] ?? 10.0,
        selectedState: json['selectedState'] ?? '',
        enteredCountry: json['enteredCountry'] ?? '',
        customOptions: json['customOptions'] != null
            ? List<String>.from(json['customOptions'].map((x) => x))
            : [],
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  final String id;
  final List<String> selectedOptions;
  final Map<String, bool> opportunityTypes;
  final String selectedLocationOption;
  final double locationDistance;
  final String selectedState;
  final String enteredCountry;
  final List<String> customOptions;
  final DateTime updatedAt;
}
