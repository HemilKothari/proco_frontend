import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub_v1/controllers/jobs_provider.dart';
import 'package:jobhub_v1/models/response/jobs/jobs_response.dart';
import 'package:jobhub_v1/services/helpers/jobs_helper.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/drawer/drawer_widget.dart';
import 'package:jobhub_v1/views/ui/jobs/add_job.dart';
import 'package:jobhub_v1/views/ui/jobs/matched_users.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobListingPage extends StatefulWidget {
  const JobListingPage({super.key});

  @override
  State<JobListingPage> createState() => _JobListingPageState();
}

class _JobListingPageState extends State<JobListingPage> {
  late List<JobsResponse> jobs; // Holds the list of jobs
  late List<JobsResponse> filteredJobs; // Holds the filtered list of jobs
  String selectedStatus = 'all'; // Default is showing all jobs

  @override
  void initState() {
    super.initState();
    loadJobs();
  }

  // Function to filter jobs based on selection
  void filterJobs() {
    if (selectedStatus == 'all') {
      filteredJobs = jobs; // Show all jobs
    } else if (selectedStatus == 'hiring') {
      filteredJobs =
          jobs.where((job) => job.hiring).toList(); // Show hiring jobs
    } else if (selectedStatus == 'closed') {
      filteredJobs =
          jobs.where((job) => !job.hiring).toList(); // Show closed jobs
    }
  }

  void loadJobs() async {
    final prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId') ?? '';
    debugPrint('Agent ID: $userId');

    if (userId.isNotEmpty && mounted) {
      // Load jobs from the API or database
      context.read<JobsNotifier>().getUserJobs(userId);
    } else {
      debugPrint('User ID is empty or widget is not mounted.');
    }
  }

  void setCurrentJobId(String jobId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentJobId', jobId);
    print("Current job set to: $jobId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.065.sh),
        child: CustomAppBar(
          text: 'My Queries',
          actions: [
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Color(0xFF08959D),
              ),
              onPressed: () {
                debugPrint('Add button tapped');

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddJobPage()),
                );
              },
            ),
          ],
          child: Padding(
            padding: EdgeInsets.only(left: 0.010.sh),
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
                // Once data is loaded, assign jobs and apply filtering
                jobs = snapshot.data!;
                filteredJobs = List.from(jobs); // Make a copy of the jobs

                // Call filterJobs to ensure the filtered list is initialized
                filterJobs();

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 0.9.sw,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF040326),
                              border: Border.all(
                                  color: const Color(0xFF08959D), width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButton<String>(
                              value: selectedStatus,
                              hint: const Text("Select Hiring Status"),
                              iconSize: 30,
                              iconEnabledColor: const Color(0xFF08959D),
                              isExpanded: true,
                              underline: Container(
                                color: const Color(
                                    0xFF040326), // Color of the underline
                              ),
                              style: const TextStyle(
                                  color: Color(0xFF08959D),
                                  fontWeight: FontWeight
                                      .bold), // Text color for selected item
                              dropdownColor: Colors
                                  .white, // Background color of the dropdown
                              items: const [
                                DropdownMenuItem(
                                  value: 'all',
                                  child: Text("All Jobs"),
                                ),
                                DropdownMenuItem(
                                  value: 'hiring',
                                  child: Text("Hiring Jobs"),
                                ),
                                DropdownMenuItem(
                                  value: 'closed',
                                  child: Text("Closed Jobs"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedStatus = value!;
                                  filterJobs(); // Trigger filtering based on dropdown selection
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount:
                            (filteredJobs.length / 2).ceil(), // Number of rows
                        itemBuilder: (context, rowIndex) {
                          // Fetch jobs for the current row
                          final job1 = filteredJobs[rowIndex * 2];
                          final job2 = (rowIndex * 2 + 1 < filteredJobs.length)
                              ? filteredJobs[rowIndex * 2 + 1]
                              : null;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: JobCard(job: job1),
                                  ),
                                ),
                                if (job2 != null)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: JobCard(job: job2),
                                    ),
                                  ),
                                if (job2 == null)
                                  const SizedBox(
                                      width: 185), // Keeps space between cards
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
      color: const Color(0xFF040326),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16.0, right: 16.0, top: 16, bottom: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    job.title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF08959D)),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Color(0xFF08959D),
                  ),
                  onPressed: () {
                    debugPrint('Edit button tapped');

                    // Navigate to another screen or perform some action here
                    // For example:
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddJobPage()),
                    );*/
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            GestureDetector(
              child: Image.network(job.imageUrl),
              onTap: () async => {
                await setCurrentJobId(job.id),
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MatchedUsers()),
                )
              },
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    job.hiring ? 'Hiring' : 'Closed',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: job.hiring ? Colors.green : Colors.red,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    context.read<JobsNotifier>().deleteJob(job.id);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  setCurrentJobId(String jobId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentJobId', jobId);
    print("Current job set to: $jobId");
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
