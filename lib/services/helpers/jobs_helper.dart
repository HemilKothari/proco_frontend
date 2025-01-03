import 'dart:convert'; // For encoding data to JSON
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;
import 'package:jobhub_v1/models/request/jobs/create_job.dart';
import 'package:jobhub_v1/models/response/jobs/get_job.dart';
import 'package:jobhub_v1/models/response/jobs/jobs_response.dart';
import 'package:jobhub_v1/services/config.dart';

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
      final requestHeaders = {'Content-Type': 'application/json'};
      final url = Uri.https(Config.apiUrl, Config.jobs);
      final response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(model),
      );

      if (response.statusCode == 201) {
        return jobsResponseFromJson(response.body).first;
      } else {
        throw Exception('Failed to create a job');
      }
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  static Future<void> updateJob(String jobId, Map<String, dynamic> jobData) async {
    try {
      final requestHeaders = {'Content-Type': 'application/json'};
      final url = Uri.https(Config.apiUrl, '${Config.jobs}/$jobId');
      final response = await client.put(
        url,
        headers: requestHeaders,
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
}
