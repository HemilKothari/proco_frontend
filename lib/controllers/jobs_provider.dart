import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/models/request/jobs/create_job.dart';
import 'package:jobhub_v1/models/response/jobs/swipe_res_model.dart';
import 'package:jobhub_v1/models/response/jobs/get_job.dart';
import 'package:jobhub_v1/models/response/jobs/jobs_response.dart';
import 'package:jobhub_v1/services/helpers/jobs_helper.dart';

import '../models/response/jobs/match_res_model.dart';

class JobsNotifier extends ChangeNotifier {
  Future<List<JobsResponse>>? jobList;
  Future<JobsResponse>? recent;
  Future<GetJobRes>? job;
  Future<List<JobsResponse>>? userJobs;
  Future<List<SwipedRes>>? swipedUsers;
  Future<List<MatchedRes>>? matchedUsers;

  void getJobs() {
    jobList = JobsHelper.getJobs();
    notifyListeners();
  }

  void getFilteredJobs(String agentId) {
    jobList = JobsHelper.getFilteredJobs(agentId);
    notifyListeners();
  }

  void getRecent() {
    recent = JobsHelper.getRecent();
    notifyListeners();
  }

  void getJob(String jobId) {
    job = JobsHelper.getJob(jobId);
    notifyListeners();
  }

  Future<void> createJob(CreateJobsRequest model, context) async {
    try {
      await JobsHelper.createJob(model).then((_) async {
        // Show success message
        Get.snackbar(
          'Query Created Successfully',
          'Your job listing has been added.',
          colorText: Color(kLight.value),
          backgroundColor: Color(kLightBlue.value),
          icon: const Icon(Icons.check_circle),
        );
        await Future.delayed(const Duration(seconds: 1)).then((value) {
          Get.back();
        });
        // Refresh both the global job list and the user's own job list
        getJobs();
        getUserJobs(model.agentId);
      });
    } catch (e) {
      debugPrint('createJob error: $e');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Failed to List Query'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> updateJob(String jobId, Map<String, dynamic> jobData) async {
    await JobsHelper.updateJob(jobId, jobData);
    getJobs(); // Refresh the job list after update
  }

  Future<void> deleteJob(String jobId) async {
    await JobsHelper.deleteJob(jobId);
    getJobs(); // Refresh the job list after deletion
  }

  // Add the new function to fetch jobs for a specific user
  void getUserJobs(String agentId) {
    userJobs = JobsHelper.getUserJobs(agentId);
    notifyListeners();
  }

  void getSwipedUsersId(String jobId) {
    swipedUsers = JobsHelper.getSwipededUsersId(jobId);
    notifyListeners();
  }

  void addSwipedUsers(String jobId, String userId) {
    JobsHelper.addSwipedUsers(jobId, userId);
    notifyListeners();
  }

  void getMatchedUsersId(String jobId) {
    matchedUsers = JobsHelper.getMatchedUsersId(jobId);
    notifyListeners();
  }

  void addMatchedUsers(String jobId, String userId) {
    JobsHelper.addMatchedUsers(jobId, userId);
    notifyListeners();
  }
}
