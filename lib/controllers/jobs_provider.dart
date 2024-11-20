import 'package:flutter/foundation.dart';
import 'package:jobhub_v1/models/response/jobs/get_job.dart';
import 'package:jobhub_v1/models/response/jobs/jobs_response.dart';
import 'package:jobhub_v1/services/helpers/jobs_helper.dart';

class JobsNotifier extends ChangeNotifier {
  Future<List<JobsResponse>>? jobList;  // Nullable Future for jobList
  Future<JobsResponse>? recent;         // Nullable Future for recent
  Future<GetJobRes>? job;               // Nullable Future for job

  void getJobs() {
    jobList = JobsHelper.getJobs(); // Fetch the list of jobs
    notifyListeners(); // Notify listeners that the data has changed
  }

  void getRecent() {
    recent = JobsHelper.getRecent(); // Fetch the recent job
    notifyListeners(); // Notify listeners about the new data
  }

  void getJob(String jobId) {
    job = JobsHelper.getJob(jobId); // Fetch a specific job by its ID
    notifyListeners(); // Notify listeners about the new data
  }
}

