import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub_v1/controllers/jobs_provider.dart';
import 'package:jobhub_v1/models/response/jobs/jobs_response.dart';
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
  // ─── Theme ────────────────────────────────────────────────────────────────
  static const Color _navy = Color(0xFF040326);
  static const Color _teal = Color(0xFF08979F);
  static const Color _bg = Color(0xFFF4F6FA);

  late List<JobsResponse> jobs = [];
  late List<JobsResponse> filteredJobs = [];
  String selectedStatus = 'all';

  // Filter chip options
  final List<Map<String, String>> _filters = [
    {'value': 'all', 'label': 'All'},
    {'value': 'hiring', 'label': 'Hiring'},
    {'value': 'closed', 'label': 'Closed'},
  ];

  @override
  void initState() {
    super.initState();
    loadJobs();
  }

  void filterJobs() {
    if (selectedStatus == 'all') {
      filteredJobs = jobs;
    } else if (selectedStatus == 'hiring') {
      filteredJobs = jobs.where((job) => job.hiring).toList();
    } else {
      filteredJobs = jobs.where((job) => !job.hiring).toList();
    }
  }

  void loadJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    if (userId.isEmpty || !mounted) return;
    final notifier = context.read<JobsNotifier>();
    // Show cached jobs instantly so listings appear immediately after login
    await notifier.loadCachedUserJobs(userId);
    // Then silently refresh from network
    if (mounted) notifier.getUserJobs(userId);
  }

  Future<void> setCurrentJobId(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentJobId', jobId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.065.sh),
        child: CustomAppBar(
          text: 'My Job Listings',
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AddJobPage())),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _teal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.add_rounded,
                          color: Colors.white, size: 16),
                      SizedBox(width: 4.w),
                      Text(
                        'Add Job',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                return const Center(
                    child: CircularProgressIndicator(color: _teal));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState();
              }

              jobs = snapshot.data!;
              filterJobs();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Filter chips ─────────────────────────────────────────
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                    child: Row(
                      children: [
                        // Job count badge
                        Text(
                          '${filteredJobs.length} job${filteredJobs.length == 1 ? '' : 's'}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const Spacer(),
                        // Filter chips
                        Row(
                          children: _filters.map((f) {
                            final isSelected = selectedStatus == f['value'];
                            return Padding(
                              padding: EdgeInsets.only(left: 8.w),
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  selectedStatus = f['value']!;
                                  filterJobs();
                                }),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14.w, vertical: 7.h),
                                  decoration: BoxDecoration(
                                    color: isSelected ? _teal : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? _teal
                                          : Colors.grey.shade300,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: _teal.withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            )
                                          ]
                                        : [],
                                  ),
                                  child: Text(
                                    f['label']!,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  // ── Job grid ─────────────────────────────────────────────
                  Expanded(
                    child: filteredJobs.isEmpty
                        ? _buildEmptyFilter()
                        : GridView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 4.h),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12.w,
                              mainAxisSpacing: 12.h,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: filteredJobs.length,
                            itemBuilder: (context, index) {
                              return JobCard(
                                job: filteredJobs[index],
                                onViewMatches: () async {
                                  await setCurrentJobId(filteredJobs[index].id);
                                  if (context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const MatchedUsers()),
                                    );
                                  }
                                },
                                onDelete: () => context
                                    .read<JobsNotifier>()
                                    .deleteJob(filteredJobs[index].id),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_outline_rounded,
              size: 64, color: _teal.withOpacity(0.35)),
          SizedBox(height: 16.h),
          Text('No listings yet',
              style: TextStyle(
                  fontSize: 18.sp,
                  color: _navy,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins')),
          SizedBox(height: 6.h),
          Text('Tap "Add Job" to post your first listing',
              style: TextStyle(
                  fontSize: 13.sp, color: Colors.grey, fontFamily: 'Poppins')),
        ],
      ),
    );
  }

  Widget _buildEmptyFilter() {
    return Center(
      child: Text(
        'No jobs match this filter',
        style: TextStyle(
            fontSize: 14.sp, color: Colors.grey, fontFamily: 'Poppins'),
      ),
    );
  }
}

// ─── Job Card ─────────────────────────────────────────────────────────────────
class JobCard extends StatelessWidget {
  final JobsResponse job;
  final VoidCallback onViewMatches;
  final VoidCallback onDelete;

  static const Color _navy = Color(0xFF040326);
  static const Color _teal = Color(0xFF08979F);

  const JobCard({
    Key? key,
    required this.job,
    required this.onViewMatches,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isHiring = job.hiring;

    return GestureDetector(
      onTap: onViewMatches,
      child: Container(
        decoration: BoxDecoration(
          color: _navy,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _navy.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Image with status badge ──────────────────────────────────
            SizedBox(
              height: 130,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    job.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: _teal.withOpacity(0.12),
                      child: const Icon(Icons.business_rounded,
                          color: _teal, size: 36),
                    ),
                  ),
                  // Gradient
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            _navy.withOpacity(0.7),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Hiring status badge
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isHiring
                            ? Colors.green.shade600
                            : Colors.red.shade600,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isHiring ? 'Hiring' : 'Closed',
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  // Matched users count badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 4),
                      decoration: BoxDecoration(
                        color: _teal.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.people_outline_rounded,
                              color: Colors.white, size: 10),
                          const SizedBox(width: 3),
                          Text(
                            '${job.matchedUsers.length}',
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    job.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Hiring status + delete row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isHiring ? 'Hiring' : 'Closed',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: isHiring
                              ? Colors.green.shade400
                              : Colors.red.shade400,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      GestureDetector(
                        onTap: onDelete,
                        child: const Icon(Icons.delete_outline_rounded,
                            color: Colors.redAccent, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
