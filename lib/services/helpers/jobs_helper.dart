import 'dart:convert'; // For encoding data to JSON
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;
import 'package:jobhub_v1/models/request/jobs/create_job.dart';
import 'package:jobhub_v1/models/response/auth/swipe_res_model.dart';
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
        return [];
      }

      List<JobsResponse> jobs =
          data.map((job) => JobsResponse.fromJson(job)).toList();

      // Extract job IDs and store in SharedPreferences
      List<String> jobIds =
          jobs.map((job) => job.id).toList(); // Assuming `id` is a string
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
    print("Saved job IDs: $jobIds");
  }

  static Future<void> setCurrentJobId(String jobId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentJobId', jobId);
    print("Current job set to: $jobId");
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

  // static Future<List<SwipedRes>> getSwipededUsersId(String jobId) async {
  //   final requestHeaders = {'Content-Type': 'application/json'};
  //   final url = Uri.https(Config.apiUrl, '${Config.jobs}/user/swipe/$jobId');
  //   final response = await client.get(url, headers: requestHeaders);
  //   print("Response Received $response");

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);

  //     if (data.isEmpty || !data.containsKey('swipedUsers')) {
  //       debugPrint('No swiped users found for this job: $jobId');
  //       print("No swiped users");
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
      final url = Uri.https(Config.apiUrl, '${Config.jobs}/user/swipe/$jobId');

      final response = await client.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        print("Response Received: ${response.body}");

        final List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          debugPrint('No swiped users found for this job: $jobId');
          print("No swiped users found");
          return [];
        }

        //Convert the List<dynamic> into List<SwipedRes>
        List<SwipedRes> swipedUsers =
            data.map((user) => SwipedRes.fromJson(user)).toList();

        return swipedUsers;
      } else {
        debugPrint('Failed to load swiped users: ${response.statusCode}');
        throw Exception('Failed to load swiped users');
      }
    } catch (e) {
      debugPrint('Error fetching swiped users: $e');
      print("Exception: $e");
      return []; // Return an empty list in case of an error
    }
  }

  static Future<void> addSwipedUsers(String jobId, String userId) async {
    final requestHeaders = {'Content-Type': 'application/json'};
    final url = Uri.https(Config.apiUrl, '${Config.jobs}/user/swipe/');

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

  static Future<List<SwipedRes>> getMatchedUsersId(String jobId) async {
    try {
      final requestHeaders = {'Content-Type': 'application/json'};
      final url = Uri.https(Config.apiUrl, '${Config.jobs}/user/match/$jobId');

      final response = await client.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        print("Response Received: ${response.body}");

        final List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          debugPrint('No matched users found for this job: $jobId');
          print("No matched users found");
          return [];
        }

        //Convert the List<dynamic> into List<SwipedRes>
        List<SwipedRes> matchedUsers =
            data.map((user) => SwipedRes.fromJson(user)).toList();

        return matchedUsers;
      } else {
        debugPrint('Failed to load matched users: ${response.statusCode}');
        throw Exception('Failed to load matched users');
      }
    } catch (e) {
      debugPrint('Error fetching matched users: $e');
      print("Exception: $e");
      return []; // Return an empty list in case of an error
    }
  }

  static Future<void> addMatchedUsers(String jobId, String userId) async {
    final requestHeaders = {'Content-Type': 'application/json'};
    final url = Uri.https(Config.apiUrl, '${Config.jobs}/user/match/');
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
