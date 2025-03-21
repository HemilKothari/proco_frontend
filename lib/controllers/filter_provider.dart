import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/models/request/filters/create_filter.dart';
import 'package:jobhub_v1/models/response/filters/filter_response.dart';
import 'package:jobhub_v1/models/response/filters/get_filter.dart';
import 'package:jobhub_v1/services/helpers/filter_helper.dart';

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
