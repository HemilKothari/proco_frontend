import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub_v1/controllers/jobs_provider.dart';
import 'package:jobhub_v1/models/response/jobs/jobs_response.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/drawer/drawer_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobListingPage extends StatefulWidget {
  const JobListingPage({super.key});

  @override
  State<JobListingPage> createState() => _JobListingPageState();
}

class _JobListingPageState extends State<JobListingPage> {
  @override
  void initState() {
    super.initState();
    loadJobs();
  }

void loadJobs() async {
  final prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString('userId') ?? '';
  debugPrint('Agent ID: $userId');

  if (userId.isNotEmpty && mounted) {
    context.read<JobsNotifier>().getUserJobs(userId);
  } else {
    debugPrint('User ID is empty or widget is not mounted.');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(
          text: 'My Queries',
          child: Padding(
            padding: EdgeInsets.all(12.0.h),
            child: const DrawerWidget(),
          ),
        ),
      ),
      body: Consumer<JobsNotifier>(
        builder: (context, jobsNotifier, child) {
          return FutureBuilder<List<JobsResponse>>(
            future: jobsNotifier.userJobs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No jobs found.'));
              } else {
                List<JobsResponse> jobs = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return JobCard(job: job);
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final JobsResponse job;

  const JobCard({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(job.company, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(job.location, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text('Salary: ${job.salary}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text('Contract: ${job.contract}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text('Description: ${job.description}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(job.hiring ? 'Hiring' : 'Closed',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: job.hiring ? Colors.green : Colors.red)),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    context.read<JobsNotifier>().deleteJob(job.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => JobsNotifier(),
      child: const MaterialApp(
        home: JobListingPage(),
      ),
    ),
  );
}
