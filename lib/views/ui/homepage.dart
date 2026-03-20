import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jobhub_v1/controllers/jobs_provider.dart';
import 'package:jobhub_v1/models/response/jobs/jobs_response.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/drawer/drawer_widget.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:jobhub_v1/views/ui/filters/filter_page.dart';
import 'package:jobhub_v1/views/ui/notification/notification_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/bookmark_provider.dart';
import '../../models/request/bookmarks/bookmarks_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ─── Theme ────────────────────────────────────────────────────────────────
  static const Color _navy = Color(0xFF040326);
  static const Color _teal = Color(0xFF08979F);
  static const Color _tealLt = Color(0xFF0BBFCA);
  static const Color _orange = Color(0xFFf55631);
  static const Color _red = Color(0xFFD23838);
  static const Color _green = Color(0xFF089F20);
  static const Color _bg = Color(0xFFF4F6FA);

  final CardSwiperController controller = CardSwiperController();

  @override
  void initState() {
    super.initState();
    Provider.of<JobsNotifier>(context, listen: false).getJobs();
  }

  Future<String> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.065.sh),
        child: CustomAppBar(
          actions: [
            IconButton(
              icon: const Icon(FontAwesome.filter, color: _teal, size: 18),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const FilterPage())),
            ),
            Padding(
              padding: EdgeInsets.only(right: 6.w),
              child: IconButton(
                icon: const Icon(FontAwesome.bell, color: _teal, size: 18),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationPage())),
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
        builder: (context, jobNotifier, child) {
          return FutureBuilder<String>(
            future: getCurrentUserId(),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator(color: _teal));
              }

              final currentUserId = userSnapshot.data!;

              return FutureBuilder<List<JobsResponse>>(
                future: jobNotifier.jobList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: _teal));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyState();
                  }

                  final jobList = snapshot.data!
                      .where((job) =>
                          job.agentId != currentUserId && job.hiring == true)
                      .toList();

                  if (jobList.isEmpty) return _buildEmptyState();

                  final bookmarkNotifier =
                      Provider.of<BookMarkNotifier>(context, listen: false);

                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // ── Card swiper fills all space above FABs ─────────────
                      Positioned.fill(
                        bottom: 100.h,
                        child: CardSwiper(
                          controller: controller,
                          scale: 0.92,
                          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                          cardsCount: jobList.length,
                          allowedSwipeDirection:
                              const AllowedSwipeDirection.only(
                            left: true,
                            right: true,
                            up: true,
                          ),
                          onSwipe: (previousIndex, currentIndex, direction) {
                            final job = jobList[previousIndex];
                            if (direction == CardSwiperDirection.right) {
                              jobNotifier.addSwipedUsers(job.id, currentUserId);
                            }
                            if (direction == CardSwiperDirection.top) {
                              bookmarkNotifier.addBookMark(
                                  BookmarkReqResModel(job: job.id), job.id);
                            }
                            return true;
                          },
                          cardBuilder: (context, index, pctX, pctY) {
                            final job = jobList[index];

                            // Derive live direction from drag %
                            CardSwiperDirection? liveDirection;
                            const threshold = 0.15;
                            if (index == 0) {
                              if (pctY < -threshold) {
                                liveDirection = CardSwiperDirection.top;
                              } else if (pctX > threshold) {
                                liveDirection = CardSwiperDirection.right;
                              } else if (pctX < -threshold) {
                                liveDirection = CardSwiperDirection.left;
                              }
                            }

                            return _buildCard(job, liveDirection);
                          },
                          isLoop: true,
                        ),
                      ),

                      // ── FABs — floating, no box ────────────────────────────
                      Positioned(
                        bottom: 14.h,
                        child: _buildFabRow(),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // ─── Card ─────────────────────────────────────────────────────────────────
  Widget _buildCard(JobsResponse job, CardSwiperDirection? liveDirection) {
    return Stack(
      children: [
        // Card body
        Container(
          decoration: BoxDecoration(
            color: _navy,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: _navy.withOpacity(0.4),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Image top 52% ──────────────────────────────────────────────
              Expanded(
                flex: 52,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      job.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: _teal.withOpacity(0.12),
                        child: const Icon(Icons.business_rounded,
                            color: _teal, size: 64),
                      ),
                    ),
                    // Bottom gradient
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              _navy.withOpacity(0.85),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Hiring badge
                    if (job.hiring)
                      Positioned(
                        top: 14.h,
                        right: 14.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: _green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Actively Hiring',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    // Company name overlaid at image bottom
                    Positioned(
                      bottom: 12.h,
                      left: 16.w,
                      right: 16.w,
                      child: Text(
                        job.company ?? 'Unknown Company',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: _tealLt,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Info bottom 48% ────────────────────────────────────────────
              Expanded(
                flex: 48,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Job title
                      Text(
                        job.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Location + contract type on same row
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded,
                              color: _orange, size: 13),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              job.location,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white60,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          if (job.contract != null &&
                              job.contract!.isNotEmpty) ...[
                            SizedBox(width: 8.w),
                            _chip(job.contract!, Colors.white12),
                          ],
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Salary row
                      if (job.salary != null && job.salary!.isNotEmpty)
                        Row(
                          children: [
                            const Icon(Icons.payments_outlined,
                                color: _tealLt, size: 13),
                            SizedBox(width: 4.w),
                            Text(
                              '${job.salary}  ·  ${job.period ?? ''}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: _tealLt,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      if (job.salary != null && job.salary!.isNotEmpty)
                        SizedBox(height: 8.h),

                      // Description preview — 2 lines
                      if (job.description != null &&
                          job.description!.isNotEmpty) ...[
                        Text(
                          job.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white54,
                            fontFamily: 'Poppins',
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 8.h),
                      ],

                      // Requirements preview — up to 2 bullet points
                      if (job.requirements.isNotEmpty)
                        ...job.requirements.take(2).map(
                              (req) => Padding(
                                padding: EdgeInsets.only(bottom: 4.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 5.h),
                                      child: Container(
                                        width: 5,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          color: _teal,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        req,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.white60,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Swipe overlay
        if (liveDirection != null) _buildSwipeOverlay(liveDirection),
      ],
    );
  }

  // ─── Swipe overlay ────────────────────────────────────────────────────────
  Widget _buildSwipeOverlay(CardSwiperDirection direction) {
    final isLeft = direction == CardSwiperDirection.left;
    final isRight = direction == CardSwiperDirection.right;

    final Color color = isLeft
        ? _red
        : isRight
            ? _green
            : _teal;
    final IconData icon = isLeft
        ? Icons.close_rounded
        : isRight
            ? Icons.star_rounded
            : Icons.bookmark_rounded;
    final String label = isLeft
        ? 'PASS'
        : isRight
            ? 'APPLY'
            : 'SAVE';

    final Alignment alignment = isLeft
        ? Alignment.topLeft
        : isRight
            ? Alignment.topRight
            : Alignment.topCenter;

    final EdgeInsets padding = isLeft
        ? EdgeInsets.only(top: 30.h, left: 22.w)
        : isRight
            ? EdgeInsets.only(top: 30.h, right: 22.w)
            : EdgeInsets.only(top: 22.h);

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(color: color, width: 3),
        ),
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: padding,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 18),
                  SizedBox(width: 6.w),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15.sp,
                      fontFamily: 'Poppins',
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── FAB row — no surrounding box ─────────────────────────────────────────
  Widget _buildFabRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _fab(
          icon: Icons.rotate_left_rounded,
          color: _teal,
          label: 'Undo',
          onTap: controller.undo,
          size: 50,
        ),
        SizedBox(width: 14.w),
        _fab(
          icon: Icons.close_rounded,
          color: _red,
          label: 'Pass',
          onTap: () => controller.swipe(CardSwiperDirection.left),
          size: 64,
        ),
        SizedBox(width: 14.w),
        _fab(
          icon: Icons.star_rounded,
          color: _green,
          label: 'Apply',
          onTap: () => controller.swipe(CardSwiperDirection.right),
          size: 64,
        ),
        SizedBox(width: 14.w),
        _fab(
          icon: Icons.bookmark_rounded,
          color: _teal,
          label: 'Save',
          onTap: () => controller.swipe(CardSwiperDirection.top),
          size: 50,
        ),
      ],
    );
  }

  Widget _fab({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
    required double size,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size.w,
            height: size.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.45),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(Icons.close_rounded == icon ? icon : icon,
                color: Colors.white, size: size * 0.44),
          ),
          SizedBox(height: 5.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: color,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // ─── Chip ─────────────────────────────────────────────────────────────────
  Widget _chip(String text, Color bg) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  // ─── Empty state ──────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_off_rounded, size: 64, color: _teal.withOpacity(0.4)),
          SizedBox(height: 16.h),
          Text(
            'No jobs available',
            style: TextStyle(
              fontSize: 18.sp,
              color: _navy,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Check back later for new opportunities',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
