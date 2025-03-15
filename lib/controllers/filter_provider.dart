import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/models/request/filters/create_filter.dart';
import 'package:jobhub_v1/models/response/filters/filter_response.dart';
import 'package:jobhub_v1/models/response/filters/get_filter.dart';
import 'package:jobhub_v1/services/helpers/filter_helper.dart';
import 'package:jobhub_v1/views/ui/filters/filter_page.dart';

class FilterNotifier extends ChangeNotifier {
  Future<List<FilterResponse>>? filterList;
  Future<FilterResponse>? recentFilter;
  Future<GetFilterRes>? filter;
  Future<List<FilterResponse>>? userFilters;

  // Method to get filters
  void getFilters() {
    filterList = FilterHelper.getFilters();
    notifyListeners();
  }

  // Method to get recent filters
  void getRecentFilters() {
    recentFilter = FilterHelper.getRecentFilters();
    notifyListeners();
  }

  // Method to get a specific filter
  void getFilter(String filterId) {
    filter = FilterHelper.getFilter(filterId);
    notifyListeners();
  }

  // Method to create a new filter
  Future<void> createFilter(String agentId, CreateFilterRequest model) async {
    try {
      await FilterHelper.createFilter(model).then((_) async {
        // Show success message
        Get.snackbar(
          'Filter Added Successfully',
          '',
          colorText: Color(kLight.value),
          backgroundColor: Color(kLightBlue.value),
          icon: const Icon(Icons.check_circle),
        );
        // await Future.delayed(const Duration(seconds: 1)).then((value) {
        //   Get.offAll(() => const FilterPage());
        // });
        // Refresh the filter list after successful creation
        getUserFilters(agentId);
      });
    } catch (e) {
      // Handle errors
      Get.snackbar(
        'Error Creating Filter',
        e.toString(),
        colorText: Color(kLight.value),
        backgroundColor: Color(kOrange.value),
        icon: const Icon(Icons.error),
      );
    }
  }

  // Method to update a filter
  Future<void> updateFilter(
      String filterId, Map<String, dynamic> filterData) async {
    await FilterHelper.updateFilter(filterId, filterData);
    // getFilters(); // Refresh the filter list after update
  }

  // Method to delete a filter
  Future<void> deleteFilter(String filterId) async {
    await FilterHelper.deleteFilter(filterId);
    // getFilters(); // Refresh the filter list after deletion
  }

  // Method to get filters for a specific user
  void getUserFilters(String agentId) {
    userFilters = FilterHelper.getUserFilters(agentId);
    notifyListeners();
  }
}


/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/models/request/jobs/create_job.dart';
import 'package:jobhub_v1/models/response/jobs/get_job.dart';
import 'package:jobhub_v1/models/response/jobs/jobs_response.dart';
import 'package:jobhub_v1/services/helpers/jobs_helper.dart';
import 'package:jobhub_v1/views/ui/jobs/user_job_page.dart';

class FilterNotifier extends ChangeNotifier {
  // Options for filters
  final List<String> _options = [
    'Web Development',
    'App Development',
    'Graphic Designer',
    'Finance',
    'Consulting',
    'Marketing',
    'Competitive Programming',
    'Cyber Security',
    'Blockchain',
    'Research',
    'UI/UX',
    'Animator',
  ];

  // Selected options
  final List<String> _selectedOptions = [];

  // Opportunity types with toggle states
  final Map<String, bool> _opportunityTypes = {
    'Internship': false,
    'Research': false,
    'Freelance': false,
    'Competition': false,
  };

  // Location-related variables
  String _selectedLocationOption = "";
  double _locationDistance = 10.0; // Distance for City filter
  String _selectedState = ""; // Selected state for State filter
  String _enteredCountry = ""; // Entered country for Country filter

  // For custom input
  bool _showCustomInput = false;
  String _customInputValue = "";

  // Getters
  List<String> get options => List.unmodifiable(_options);
  List<String> get selectedOptions => List.unmodifiable(_selectedOptions);
  Map<String, bool> get opportunityTypes => Map.unmodifiable(_opportunityTypes);
  String get selectedLocationOption => _selectedLocationOption;
  double get locationDistance => _locationDistance;
  String get selectedState => _selectedState;
  String get enteredCountry => _enteredCountry;
  bool get showCustomInput => _showCustomInput;
  String get customInputValue => _customInputValue;

  // Setters
  void toggleOption(String option) {
    if (_selectedOptions.contains(option)) {
      _selectedOptions.remove(option);
    } else {
      _selectedOptions.add(option);
    }
    notifyListeners();
  }

  void toggleCustomInput(bool value) {
    _showCustomInput = value;
    notifyListeners();
  }

  void updateCustomInputValue(String value) {
    _customInputValue = value;
    notifyListeners();
  }

  void addCustomOption(String option) {
    if (option.isNotEmpty) {
      _options.add(option);
      _selectedOptions.add(option);
      _customInputValue = "";
      _showCustomInput = false;
      notifyListeners();
    }
  }

  void toggleOpportunityType(String type, bool value) {
    if (_opportunityTypes.containsKey(type)) {
      _opportunityTypes[type] = value;
      notifyListeners();
    }
  }

  void updateLocationOption(String option) {
    _selectedLocationOption = option;
    notifyListeners();
  }

  void updateLocationDistance(double distance) {
    _locationDistance = distance;
    notifyListeners();
  }

  void updateSelectedState(String state) {
    _selectedState = state;
    notifyListeners();
  }

  void updateEnteredCountry(String country) {
    _enteredCountry = country;
    notifyListeners();
  }

  // Logic to get filtered data
  Map<String, dynamic> getFilterCriteria() {
    return {
      'selectedOptions': _selectedOptions,
      'opportunityTypes': _opportunityTypes.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList(),
      'selectedLocationOption': _selectedLocationOption,
      'locationDistance':
          _selectedLocationOption == "City" ? _locationDistance : null,
      'selectedState':
          _selectedLocationOption == "State" ? _selectedState : null,
      'enteredCountry':
          _selectedLocationOption == "Country" ? _enteredCountry : null,
    };
  }

  Future<void> applyFilters() async {
    try {
      // Mock logic to demonstrate filter application
      final filterCriteria = getFilterCriteria();
      Get.snackbar(
        'Filters Applied',
        'Filters: ${filterCriteria.toString()}',
        colorText: Colors.white,
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.filter_alt),
      );
    } catch (e) {
      Get.snackbar(
        'Error Applying Filters',
        e.toString(),
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error),
      );
    }
  }

  void clearFilters() {
    _selectedOptions.clear();
    _opportunityTypes.updateAll((key, value) => false);
    _selectedLocationOption = "";
    _locationDistance = 10.0;
    _selectedState = "";
    _enteredCountry = "";
    _customInputValue = "";
    _showCustomInput = false;
    notifyListeners();
  }
}
*/