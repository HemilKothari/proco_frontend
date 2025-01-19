import 'dart:convert';

String createFilterRequestToJson(CreateFilterRequest data) => json.encode(data.toJson());

class CreateFilterRequest {
  CreateFilterRequest({
    required this.selectedOptions,
    required this.opportunityTypes,
    required this.selectedLocationOption,
    required this.locationDistance,
    required this.selectedState,
    required this.enteredCountry,
    required this.customOptions,
  });

  final List<String> selectedOptions; // Array of strings for selected options like 'Web Development', etc.
  final Map<String, bool> opportunityTypes; // Map for storing boolean values of opportunity types
  final String selectedLocationOption; // Location type selected: 'City', 'State', or 'Country'
  final double locationDistance; // Distance in kilometers for 'City' filter
  final String selectedState; // State selected from the dropdown
  final String enteredCountry; // Country name entered manually
  final List<String> customOptions; // Array to store custom options added by the user

  Map<String, dynamic> toJson() => {
        'selectedOptions': selectedOptions.map((x) => x).toList(),
        'opportunityTypes': opportunityTypes.map((k, v) => MapEntry(k, v)),
        'selectedLocationOption': selectedLocationOption,
        'locationDistance': locationDistance,
        'selectedState': selectedState,
        'enteredCountry': enteredCountry,
        'customOptions': customOptions.map((x) => x).toList(),
      };
}