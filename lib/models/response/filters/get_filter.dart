import 'dart:convert';

GetFilterRes getFilterResFromJson(String str) =>
    GetFilterRes.fromJson(json.decode(str));

String getFilterResToJson(GetFilterRes data) => json.encode(data.toJson());

class GetFilterRes {
  GetFilterRes({
    required this.id,
    required this.selectedOptions,
    required this.opportunityTypes,
    required this.selectedLocationOption,
    required this.locationDistance,
    required this.selectedState,
    required this.enteredCountry,
    required this.customOptions,
  });

  factory GetFilterRes.fromJson(Map<String, dynamic> json) => GetFilterRes(
        id: json['_id'],
        selectedOptions:
            List<String>.from(json['selectedOptions'].map((x) => x)),
        opportunityTypes: Map<String, bool>.from(
            json['opportunityTypes'].map((k, v) => MapEntry(k, v))),
        selectedLocationOption: json['selectedLocationOption'],
        locationDistance: json['locationDistance'].toDouble(),
        selectedState: json['selectedState'],
        enteredCountry: json['enteredCountry'],
        customOptions: List<String>.from(json['customOptions'].map((x) => x)),
      );

  final String id;
  final List<String> selectedOptions;
  final Map<String, bool> opportunityTypes;
  final String selectedLocationOption;
  final double locationDistance;
  final String selectedState;
  final String enteredCountry;
  final List<String> customOptions;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'selectedOptions': List<dynamic>.from(selectedOptions.map((x) => x)),
        'opportunityTypes': Map<String, dynamic>.from(
            opportunityTypes.map((k, v) => MapEntry(k, v))),
        'selectedLocationOption': selectedLocationOption,
        'locationDistance': locationDistance,
        'selectedState': selectedState,
        'enteredCountry': enteredCountry,
        'customOptions': List<dynamic>.from(customOptions.map((x) => x)),
      };
}
