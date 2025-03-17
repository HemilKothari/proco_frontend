import 'dart:convert'; // For encoding data to JSON
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;
import 'package:jobhub_v1/models/request/jobs/create_job.dart';
import 'package:jobhub_v1/models/response/jobs/get_job.dart';
import 'package:jobhub_v1/models/response/jobs/jobs_response.dart';
import 'package:jobhub_v1/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobsHelper {
  static https.Client client = https.Client();

  static Future<List<JobsResponse>> getJobs() async {
    try {
      final requestHeaders = {'Content-Type': 'application/json'};
      final url = Uri.https(Config.apiUrl, Config.jobs);
      final response = await client.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        return jobsResponseFromJson(response.body);
      } else {
        throw Exception('Failed to get the jobs');
      }
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  static Future<GetJobRes> getJob(String jobId) async {
    try {
      final requestHeaders = {'Content-Type': 'application/json'};
      final url = Uri.https(Config.apiUrl, '${Config.jobs}/$jobId');
      final response = await client.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        return getJobResFromJson(response.body);
      } else {
        throw Exception('Failed to get a job');
      }
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  static Future<List<JobsResponse>> getUserJobs(String agentId) async {
    final requestHeaders = {'Content-Type': 'application/json'};
    final url = Uri.https(Config.apiUrl, '${Config.jobs}/user/$agentId');
    final response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      if (data.isEmpty) {
        debugPrint('No jobs found for user: $agentId');
      }
      return data.map((job) => JobsResponse.fromJson(job)).toList();
    } else {
      debugPrint('Failed to load jobs: ${response.statusCode}');
      throw Exception('Failed to load user jobs');
    }
  }

  static Future<JobsResponse> getRecent() async {
    final requestHeaders = <String, String>{
      'Content-Type': 'application/json',
    };

    final url = Uri.https(Config.apiUrl, Config.jobs, {'new': 'true'});
    final response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final jobsList = jobsResponseFromJson(response.body);

      final recent = jobsList.first;
      return recent;
    } else {
      throw Exception('Failed to get the jobs');
    }
  }

  //SEARCH
  static Future<List<JobsResponse>> searchJobs(String searchQeury) async {
    final requestHeaders = <String, String>{
      'Content-Type': 'application/json',
    };

    final url = Uri.https(Config.apiUrl, '${Config.search}/$searchQeury');
    final response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final jobsList = jobsResponseFromJson(response.body);
      return jobsList;
    } else {
      throw Exception('Failed to get the jobs');
    }
  }

  static Future<JobsResponse> createJob(CreateJobsRequest model) async {
    try {
      // Fetch the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception('Token is null or empty');
      }

      final url = Uri.https(Config.apiUrl, Config.jobs);

      // API Request
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': 'Bearer $token', // Correct header for Bearer token
        },
        body: jsonEncode(model),
      );

      // Log the response for debugging
      debugPrint('Request URL: $url');
      debugPrint('Request Headers: ${{
        'Content-Type': 'application/json',
        'token': 'Bearer $token',
      }}');
      debugPrint('Request Body: ${jsonEncode(model)}');

      debugPrint('Response Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the single job object
        return JobsResponse.fromJson(json.decode(response.body));
      } else {
        // Throw exception with detailed error
        throw Exception('Failed to create a job: ${response.body}');
      }
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  static Future<void> updateJob(
      String jobId, Map<String, dynamic> jobData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      final url = Uri.https(Config.apiUrl, '${Config.jobs}/$jobId');
      final response = await client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': 'Bearer $token', // Include the token here
        },
        body: jsonEncode(jobData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update the job');
      }
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  static Future<void> deleteJob(String jobId) async {
    try {
      final requestHeaders = {'Content-Type': 'application/json'};
      final url = Uri.https(Config.apiUrl, '${Config.jobs}/$jobId');
      final response = await client.delete(url, headers: requestHeaders);

      if (response.statusCode != 204) {
        throw Exception('Failed to delete the job');
      }
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  static Future<List<String>> getSwipededUsers(String jobId) async {
    final requestHeaders = {'Content-Type': 'application/json'};
    final url = Uri.https(Config.apiUrl, '${Config.jobs}/$jobId');
    final response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.isEmpty || !data.containsKey('matchedUsers')) {
        debugPrint('No matched users found for this job: $jobId');
        return [];
      }
      List<String> matchedUsers = List<String>.from(data['matchedUsers']);
      return matchedUsers;
    } else {
      debugPrint('Failed to load matched users: ${response.statusCode}');
      throw Exception('Failed to load matched users');
    }
  }

  static Future<void> addSwipedUsers(String jobId, String userId) async {
    final requestHeaders = {'Content-Type': 'application/json'};

    // Construct API endpoint
    final url = Uri.https(Config.apiUrl, '${Config.jobs}/$jobId/match');

    try {
      // Fetch the existing job data first
      final getResponse = await client.get(url, headers: requestHeaders);

      if (getResponse.statusCode == 200) {
        final Map<String, dynamic> jobData = json.decode(getResponse.body);
        List<dynamic> matchedUsers = jobData['matchedUsers'] ?? [];

        // Check if user is already in the list
        if (!matchedUsers.contains(userId)) {
          matchedUsers.add(userId); // Append the new user ID
        } else {
          debugPrint('User already matched to this job.');
          return; // Exit if the user is already in the list
        }

        // Send an update request with the modified matchedUsers list
        final updateBody = json.encode({'matchedUsers': matchedUsers});

        final updateResponse =
            await client.put(url, headers: requestHeaders, body: updateBody);

        if (updateResponse.statusCode == 200) {
          debugPrint('User $userId added to matched users for job $jobId');
        } else {
          debugPrint(
              'Failed to update matched users: ${updateResponse.statusCode}');
        }
      } else {
        debugPrint('Failed to fetch job data: ${getResponse.statusCode}');
      }
    } catch (e) {
      debugPrint('Error adding matched user: $e');
    }
  }
}
