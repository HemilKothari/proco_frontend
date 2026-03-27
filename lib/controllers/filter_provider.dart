import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/models/request/filters/create_filter.dart';
import 'package:jobhub_v1/models/response/filters/filter_response.dart';
import 'package:jobhub_v1/models/response/filters/get_filter.dart';
import 'package:jobhub_v1/services/helpers/filter_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterNotifier extends ChangeNotifier {
  Future<List<FilterResponse>>? filterList;
  Future<FilterResponse>? recentFilter;
  Future<GetFilterRes>? filter;
  Future<List<FilterResponse>>? userFilters;

  // ── Active filter (shown as chips on homepage) ──────────────────────────
  GetFilterRes? activeFilter;

  FilterNotifier() {
    _loadActiveFilterFromPrefs();
  }

  Future<void> _loadActiveFilterFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('activeFilter');
    if (jsonStr != null) {
      try {
        activeFilter = getFilterResFromJson(jsonStr);
        notifyListeners();
      } catch (_) {}
    }
  }

  void setActiveFilter(GetFilterRes f) async {
    activeFilter = f;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('activeFilter', getFilterResToJson(f));
    notifyListeners();
  }

  Future<void> clearFilter(String agentId) async {
    try {
      await FilterHelper.createFilter(CreateFilterRequest(
        agentId: agentId,
        selectedOptions: [],
        opportunityTypes: {for (final t in kOpportunityTypes) t: false},
        selectedLocationOption: '',
        selectedCity: '',
        selectedState: '',
        selectedCountry: '',
        customOptions: [],
      ));
    } catch (_) {}
    activeFilter = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('activeFilter');
    notifyListeners();
  }

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
        Get.snackbar(
          'Filter Added Successfully',
          '',
          colorText: Color(kLight.value),
          backgroundColor: Color(kLightBlue.value),
          icon: const Icon(Icons.check_circle),
        );
        getUserFilters(agentId);
      });
    } catch (e) {
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
