import 'dart:convert'; // For encoding data to JSON
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;
import 'package:jobhub_v1/models/request/jobs/create_job.dart';
import 'package:jobhub_v1/models/response/jobs/swipe_res_model.dart';
import 'package:jobhub_v1/models/response/jobs/get_job.dart';
import 'package:jobhub_v1/models/response/jobs/jobs_response.dart';
import 'package:jobhub_v1/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/response/jobs/match_res_model.dart';

class JobsHelper {
  static https.Client client = https.Client();

  static Future<List<JobsResponse>> getFilteredJobs(String agentId) async {
    try {
      final requestHeaders = {'Content-Type': 'application/json'};
      final url = Uri.http(Config.apiUrl, '${Config.jobs}/filtered/$agentId');
      final response = await client.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        return jobsResponseFromJson(response.body);
      } else {
        throw Exception('Failed to get filtered jobs');
      }
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  static Future<List<JobsResponse>> getJobs() async {
    try {
      final requestHeaders = {'Content-Type': 'application/json'};
      final url = Uri.http(Config.apiUrl, Config.jobs);
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
      final url = Uri.http(Config.apiUrl, '${Config.jobs}/$jobId');
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
    final url = Uri.http(Config.apiUrl, '${Config.jobs}/user/$agentId');

    final response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      List data;
      if (decoded is List) {
        data = decoded;
      } else {
        if (decoded['success'] != true) {
          throw Exception(decoded['message'] ?? 'Failed to load user jobs');
        }
        data = decoded['data'] ?? [];
      }

      if (data.isEmpty) {
        debugPrint('No jobs found for user: $agentId');
        return [];
      }

      List<JobsResponse> jobs =
          data.map((job) => JobsResponse.fromJson(job)).toList();

      List<String> jobIds = jobs.map((job) => job.id).toList();
      await saveJobIdsToPrefs(jobIds);

      return jobs;
    } else {
      debugPrint('Failed to load jobs: ${response.statusCode}');
      throw Exception('Failed to load user jobs');
    }
  }

// Save all job IDs in SharedPreferences
  static Future<void> saveJobIdsToPrefs(List<String> jobIds) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('savedJobIds', jobIds);
    debugPrint("Saved job IDs: $jobIds");
  }

  static Future<void> setCurrentJobId(String jobId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentJobId', jobId);
    debugPrint("Current job set to: $jobId");
  }

  static Future<JobsResponse> getRecent() async {
    final requestHeaders = <String, String>{
      'Content-Type': 'application/json',
    };

    final url = Uri.http(Config.apiUrl, Config.jobs, {'new': 'true'});
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

    final url = Uri.http(Config.apiUrl, '${Config.search}/$searchQeury');
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
      final url = Uri.http(Config.apiUrl, Config.jobs);

      // API Request
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(model),
      );

      debugPrint('Request URL: $url');
      debugPrint('Request Body: ${jsonEncode(model)}');

      debugPrint('Response Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        final data = (body is Map && body.containsKey('data'))
            ? body['data']
            : body;
        return JobsResponse.fromJson(data as Map<String, dynamic>);
      } else {
        final body = json.decode(response.body);
        final message = (body is Map && body.containsKey('message'))
            ? body['message']
            : response.body;
        throw Exception(message);
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
      final url = Uri.http(Config.apiUrl, '${Config.jobs}/$jobId');
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
      final url = Uri.http(Config.apiUrl, '${Config.jobs}/$jobId');
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

  // static Future<List<SwipedRes>> getSwipededUsersId(String jobId) async {
  //   final requestHeaders = {'Content-Type': 'application/json'};
  //   final url = Uri.http(Config.apiUrl, '${Config.jobs}/user/swipe/$jobId');
  //   final response = await client.get(url, headers: requestHeaders);
  //   debugPrint("Response Received $response");

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);

  //     if (data.isEmpty || !data.containsKey('swipedUsers')) {
  //       debugPrint('No swiped users found for this job: $jobId');
  //       debugPrint("No swiped users");
  //       return [];
  //     }
  //     List<SwipedRes> swipedUsers = List<SwipedRes>.from(data['swipedUsers']);
  //     return swipedUsers;
  //   } else {
  //     debugPrint('Failed to load swiped users: ${response.statusCode}');
  //     throw Exception('Failed to load swiped users');
  //   }
  // }
  static Future<List<SwipedRes>> getSwipededUsersId(String jobId) async {
    try {
      final requestHeaders = {'Content-Type': 'application/json'};
      final url = Uri.http(Config.apiUrl, '${Config.swipe}/$jobId');

      final response = await client.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        debugPrint("Response Received: ${response.body}");

        final decoded = json.decode(response.body);

        // ✅ Handle wrapper
        if (decoded['success'] != true) {
          throw Exception(decoded['message'] ?? 'Failed to fetch swiped users');
        }

        final List data = decoded['data'] ?? [];

        if (data.isEmpty) {
          debugPrint('No swiped users found for this job: $jobId');
          return [];
        }

        // ✅ Convert properly
        List<SwipedRes> swipedUsers =
            data.map((user) => SwipedRes.fromJson(user)).toList();

        return swipedUsers;
      } else {
        debugPrint('Failed to load swiped users: ${response.statusCode}');
        throw Exception('Failed to load swiped users');
      }
    } catch (e) {
      debugPrint('Error fetching swiped users: $e');
      return [];
    }
  }

  static Future<void> addSwipedUsers(String jobId, String userId) async {
    final requestHeaders = {'Content-Type': 'application/json'};
    final url = Uri.http(Config.apiUrl, Config.swipe);

    try {
      final requestBody = json.encode({'jobId': jobId, 'userId': userId});
      final response =
          await client.post(url, headers: requestHeaders, body: requestBody);

      if (response.statusCode == 200) {
        debugPrint('User $userId added to swiped users for job $jobId');
      } else {
        debugPrint(
            'Failed to add swiped user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error adding swiped user: $e');
    }
  }

  static Future<List<MatchedRes>> getMatchedUsersId(String jobId) async {
    try {
      final requestHeaders = {'Content-Type': 'application/json'};
      final url = Uri.http(Config.apiUrl, '${Config.matches}/$jobId');

      final response = await client.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        debugPrint("Response Received: ${response.body}");

        final List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          debugPrint('No matched users found for this job: $jobId');
          debugPrint("No matched users found");
          return [];
        }

        //Convert the List<dynamic> into List<MatchedRes>
        List<MatchedRes> matchedUsers =
            data.map((user) => MatchedRes.fromJson(user)).toList();

        return matchedUsers;
      } else {
        debugPrint('Failed to load matched users: ${response.statusCode}');
        throw Exception('Failed to load matched users');
      }
    } catch (e) {
      debugPrint('Error fetching matched users: $e');
      debugPrint("Exception: $e");
      return []; // Return an empty list in case of an error
    }
  }

  static Future<void> addMatchedUsers(String jobId, String userId) async {
    final requestHeaders = {'Content-Type': 'application/json'};
    final url = Uri.http(Config.apiUrl, Config.matches);
    debugPrint("jobId: $jobId");
    debugPrint("userId: $userId");

    try {
      final requestBody = json.encode({'jobId': jobId, 'userId': userId});
      final response =
          await client.post(url, headers: requestHeaders, body: requestBody);

      debugPrint('Response: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('User $userId added to match users for job $jobId');
      } else {
        debugPrint(
            'Failed to add matched user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error adding matched user: $e');
    }
  }
}
