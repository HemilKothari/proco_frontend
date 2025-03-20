import 'dart:convert';

List<FilterResponse> filterResponseFromJson(String str) =>
    (json.decode(str) as List)
        .map((e) => FilterResponse.fromJson(e as Map<String, dynamic>))
        .toList();

class FilterResponse {
  FilterResponse({
    required this.id,
    this.selectedOptions,
    this.opportunityTypes,
    this.selectedLocationOption,
    this.locationDistance,
    this.selectedState,
    this.enteredCountry,
    this.customOptions,
    this.updatedAt,
  });

  factory FilterResponse.fromJson(Map<String, dynamic> json) => FilterResponse(
        id: json['_id'] ?? '',
        selectedOptions: json['selectedOptions'] != null
            ? List<String>.from(json['selectedOptions'])
            : null,
        opportunityTypes: json['opportunityTypes'] != null
            ? Map<String, bool>.from(json['opportunityTypes'])
            : null,
        selectedLocationOption: json['selectedLocationOption'],
        locationDistance: (json['locationDistance'] is int
                ? (json['locationDistance'] as int).toDouble()
                : json['locationDistance'])
            as double?,
        selectedState: json['selectedState'],
        enteredCountry: json['enteredCountry'],
        customOptions: json['customOptions'] != null
            ? List<String>.from(json['customOptions'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'])
            : null,
      );

  final String id;
  final List<String>? selectedOptions;
  final Map<String, bool>? opportunityTypes;
  final String? selectedLocationOption;
  final double? locationDistance;
  final String? selectedState;
  final String? enteredCountry;
  final List<String>? customOptions;
  final DateTime? updatedAt;
}
