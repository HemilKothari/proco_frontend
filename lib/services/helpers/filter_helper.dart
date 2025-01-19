import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;
import 'package:jobhub_v1/models/request/filters/create_filter.dart';
import 'package:jobhub_v1/models/response/filters/filter_response.dart';
import 'package:jobhub_v1/models/response/filters/get_filter.dart';
import 'package:jobhub_v1/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterHelper {
  static https.Client client = https.Client();

  static Future<List<FilterResponse>> getFilters() async {
    try {
      final requestHeaders = {'Content-Type': 'application/json'};
      final url = Uri.https(Config.apiUrl, Config.filters);
      final response = await client.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        return filterResponseFromJson(response.body);
      } else {
        throw Exception('Failed to get filters');
      }
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  static Future<GetFilterRes> getFilter(String agentId) async {
    try {
      final requestHeaders = {'Content-Type': 'application/json'};
      final url = Uri.https(Config.apiUrl, '${Config.filters}/$agentId');
      final response = await client.get(url, headers: requestHeaders);

      debugPrint('Request Headers: ${{
        'Content-Type': 'application/json',
      }}');
      debugPrint('Request URL: $url');
      debugPrint('Response Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        return getFilterResFromJson(response.body);
      } else {
        throw Exception('Failed to get a filter');
      }
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  static Future<List<FilterResponse>> getUserFilters(String agentId) async {
    final requestHeaders = {'Content-Type': 'application/json'};
    final url = Uri.https(Config.apiUrl, '${Config.filters}/user/$agentId');
    final response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Log the response for debugging
      debugPrint('Request URL: $url');
      debugPrint('Request Headers: ${{
        'Content-Type': 'application/json',
      }}');

      debugPrint('Response Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      
      // Check if data['data'] is a Map or List
      if (data['data'] is List) {
        // If it's a List, parse as a list of FilterResponse
        return (data['data'] as List)
            .map((filter) => FilterResponse.fromJson(filter))
            .toList();
      } else if (data['data'] is Map) {
        // If it's a Map, wrap it in a list and parse the single item
        return [
          FilterResponse.fromJson(data['data'] as Map<String, dynamic>)
        ];
      } else {
        throw Exception('Unexpected response structure');
      }
    } else {
      debugPrint('Failed to load filters: ${response.statusCode}');
      throw Exception('Failed to load user filters');
    }
  }


  static Future<FilterResponse> getRecentFilters() async {
    final requestHeaders = <String, String>{
      'Content-Type': 'application/json',
    };

    final url = Uri.https(Config.apiUrl, Config.filters, {'new': 'true'});
    final response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final filtersList = filterResponseFromJson(response.body);

      final recent = filtersList.first;
      return recent;
    } else {
      throw Exception('Failed to get the filters');
    }
  }

  static Future<FilterResponse> createFilter(CreateFilterRequest model) async {
    try {
      final url = Uri.https(Config.apiUrl, Config.filters);

      // API Request
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(model),
      );

      // Log the response for debugging
      // debugPrint('Request URL: $url');
      // debugPrint('Request Headers: ${{
      //   'Content-Type': 'application/json',
      // }}');
      // debugPrint('Request Body: ${jsonEncode(model)}');

      // debugPrint('Response Code: ${response.statusCode}');
      // debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the single filter object
        return FilterResponse.fromJson(json.decode(response.body));
      } else {
        // Throw exception with detailed error
        throw Exception('Failed to create a filter: ${response.body}');
      }
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  static Future<void> updateFilter(
      String filterId, Map<String, dynamic> filterData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      final url = Uri.https(Config.apiUrl, '${Config.filters}/$filterId');
      final response = await client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': 'Bearer $token', // Include the token here
        },
        body: jsonEncode(filterData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update the filter');
      }
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  static Future<void> deleteFilter(String filterId) async {
    try {
      final requestHeaders = {'Content-Type': 'application/json'};
      final url = Uri.https(Config.apiUrl, '${Config.filters}/$filterId');
      final response = await client.delete(url, headers: requestHeaders);

      if (response.statusCode != 204) {
        throw Exception('Failed to delete the filter');
      }
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }
}
