import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/models/request/jobs/create_job.dart';
import 'package:jobhub_v1/models/response/jobs/get_job.dart';
import 'package:jobhub_v1/models/response/jobs/jobs_response.dart';
import 'package:jobhub_v1/services/helpers/jobs_helper.dart';

class JobsNotifier extends ChangeNotifier {
  Future<List<JobsResponse>>? jobList;
  Future<JobsResponse>? recent;
  Future<GetJobRes>? job;

  void getJobs() {
    jobList = JobsHelper.getJobs();
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

Future<void> createJob(CreateJobsRequest model) async {
  try {
    await JobsHelper.createJob(model).then((_) {
      // Show success message
      Get.snackbar(
        'Query Created Successfully',
        'Your job listing has been added.',
        colorText: Color(kLight.value),
        backgroundColor: Color(kLightBlue.value),
        icon: const Icon(Icons.check_circle),
      );

      // Refresh the job list after successful creation
      getJobs();
    });
  } catch (e) {
    // Handle errors
    Get.snackbar(
      'Error Creating Query',
      e.toString(),
      colorText: Color(kLight.value),
      backgroundColor: Color(kOrange.value),
      icon: const Icon(Icons.error),
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
}
