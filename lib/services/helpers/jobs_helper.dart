import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;
import 'package:jobhub_v1/models/response/jobs/get_job.dart';
import 'package:jobhub_v1/models/response/jobs/jobs_response.dart';
import 'package:jobhub_v1/services/config.dart';

// FIX: ADDED TRY CATCHES EVERYWHERE
class JobsHelper {
  static https.Client client = https.Client();

  static Future<List<JobsResponse>> getJobs() async {
    try {
      final requestHeaders = <String, String>{
        'Content-Type': 'application/json',
      };

      final url = Uri.http(Config.apiUrl, Config.jobs);
      print(url);
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
    } catch (e, s) {
      debugPrint('Error Occurred: -------------- $e ---------------');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

// get job
  static Future<GetJobRes> getJob(String jobId) async {
    try {
      final requestHeaders = <String, String>{
        'Content-Type': 'application/json',
      };

      final url = Uri.http(Config.apiUrl, '${Config.jobs}/$jobId');
      final response = await client.get(
        url,
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        final job = getJobResFromJson(response.body);
        return job;
      } else {
        throw Exception('Failed to get a job');
      }
    } catch (e, s) {
      debugPrint('Error Occurred: -------------- $e ---------------');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
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
}
