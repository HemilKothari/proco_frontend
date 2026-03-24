import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/controllers/exports.dart';
import 'package:jobhub_v1/models/request/bookmarks/bookmarks_model.dart';
import 'package:jobhub_v1/models/request/chat/create_chat.dart';
import 'package:jobhub_v1/views/common/exports.dart';
import 'package:provider/provider.dart';

class JobPage extends StatefulWidget {
  const JobPage({required this.title, required this.id, super.key});

  final String title;
  final String id;

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  // ─── Theme ───────────────────────────────────────────────────────────────
  static const Color _navy = Color(0xFF040326);
  static const Color _teal = Color(0xFF08979F);
  static const Color _tealLt = Color(0xFF0BBFCA);
  static const Color _orange = Color(0xFFf55631);
  static const Color _bg = Color(0xFFF4F6FA); // light body bg
  static const Color _white = Colors.white; // ✅ renamed from _card

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsNotifier>(
      builder: (context, jobsNotifier, child) {
        jobsNotifier.getJob(widget.id);
        return Scaffold(
          backgroundColor: _bg,
          body: FutureBuilder(
            future: jobsNotifier.job,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: _teal),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error ${snapshot.error}',
                      style: appstyle(14, Colors.red, FontWeight.normal)),
                );
              } else {
                final job = snapshot.data!;
                return Stack(
                  children: [
                    // ── Scrollable body ───────────────────────────────────
                    CustomScrollView(
                      slivers: [
                        // ── Hero header (dark navy) ───────────────────────
                        SliverToBoxAdapter(
                          child: _buildHeader(context, job),
                        ),

                        // ── Pill badges row ───────────────────────────────
                        SliverToBoxAdapter(
                          child: Transform.translate(
                            offset: const Offset(0, -20),
                            child: _buildBadgeRow(job),
                          ),
                        ),

                        // ── Body cards ────────────────────────────────────
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 120.h),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              _buildDescriptionCard(job),
                              SizedBox(height: 16.h),
                              _buildRequirementsCard(job),
                              SizedBox(height: 16.h),
                            ]),
                          ),
                        ),
                      ],
                    ),

                    // ── Floating Apply button ─────────────────────────────
                    Positioned(
                      bottom: 24.h,
                      left: 20.w,
                      right: 20.w,
                      child: _buildApplyButton(job),
                    ),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }

  // ─── Dark navy hero header ────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, dynamic job) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _navy,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Top bar: back + title + bookmark ─────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: Get.back,
                    child: Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(CupertinoIcons.arrow_left,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: appstyle(16, Colors.white, FontWeight.w600),
                    ),
                  ),
                  // Bookmark
                  Consumer<BookMarkNotifier>(
                    builder: (context, bookMarkNotifier, _) {
                      bookMarkNotifier.loadJobs();
                      final isBookmarked =
                          bookMarkNotifier.jobs.contains(widget.id);
                      return GestureDetector(
                        onTap: () {
                          if (isBookmarked) {
                            bookMarkNotifier.deleteBookMark(widget.id);
                          } else {
                            final model = BookmarkReqResModel(job: widget.id);
                            bookMarkNotifier.addBookMark(model, widget.id);
                          }
                        },
                        child: Container(
                          width: 38.w,
                          height: 38.w,
                          decoration: BoxDecoration(
                            color: isBookmarked
                                ? _orange.withOpacity(0.2)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isBookmarked
                                ? Fontisto.bookmark_alt
                                : Fontisto.bookmark,
                            color: isBookmarked ? _orange : Colors.white,
                            size: 16,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 8.h),

            // ── Company avatar ────────────────────────────────────────────
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: _teal, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: _teal.withOpacity(0.35),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  job.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.business_rounded,
                    color: _teal,
                    size: 36,
                  ),
                ),
              ),
            ),

            SizedBox(height: 14.h),

            // ── Job title ─────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                job.title,
                textAlign: TextAlign.center,
                style: appstyle(22, Colors.white, FontWeight.w700),
              ),
            ),
            SizedBox(height: 6.h),

            // ── Company name (if available) ───────────────────────────────
            if (job.company != null && job.company!.isNotEmpty)
              Text(
                job.company!,
                style: appstyle(14, _tealLt, FontWeight.w500),
              ),
            SizedBox(height: 6.h),

            // ── Location ──────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_rounded, color: _orange, size: 14),
                SizedBox(width: 4.w),
                Text(
                  job.location,
                  style: appstyle(13, Colors.white70, FontWeight.w400),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // ── Salary chip ───────────────────────────────────────────────
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: _teal.withOpacity(0.18),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _teal.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.payments_outlined, color: _tealLt, size: 16),
                  SizedBox(width: 8.w),
                  Text(
                    '${job.salary}  ·  ${job.period}',
                    style: appstyle(15, Colors.white, FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(height: 36.h), // space for the overlapping badges
          ],
        ),
      ),
    );
  }

  // ─── Pill badges: contract · hiring status ────────────────────────────────
  Widget _buildBadgeRow(dynamic job) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (job.contract != null && job.contract!.isNotEmpty)
            _badge(Icons.article_outlined, job.contract!),
          if (job.contract != null && job.contract!.isNotEmpty && job.hiring)
            SizedBox(width: 10.w),
          if (job.hiring)
            _badge(Icons.check_circle_outline_rounded, 'Actively Hiring',
                highlight: true),
        ],
      ),
    );
  }

  Widget _badge(IconData icon, String label, {bool highlight = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: highlight ? _teal : _white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: highlight ? Colors.white : _teal),
          SizedBox(width: 6.w),
          Text(
            label,
            style: appstyle(
                12,
                highlight ? Colors.white : const Color(0xFF333333),
                FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ─── Description card ─────────────────────────────────────────────────────
  Widget _buildDescriptionCard(dynamic job) {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('About the Role'),
          SizedBox(height: 12.h),
          Text(
            job.description ?? desc,
            textAlign: TextAlign.justify,
            style: appstyle(14, const Color(0xFF555555), FontWeight.normal),
          ),
        ],
      ),
    );
  }

  // ─── Requirements card ────────────────────────────────────────────────────
  Widget _buildRequirementsCard(dynamic job) {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle('Requirements'),
          SizedBox(height: 14.h),
          ...List.generate(job.requirements.length, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Teal bullet dot
                  Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: _teal,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      job.requirements[index],
                      style: appstyle(
                          14, const Color(0xFF444444), FontWeight.normal),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── Apply button ─────────────────────────────────────────────────────────
  Widget _buildApplyButton(dynamic job) {
    return GestureDetector(
      onTap: () {
        final model = CreateChat(userId: job.agentId);
        print(model.userId);
      },
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_teal, _tealLt],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: _teal.withOpacity(0.45),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Apply Now',
            style: appstyle(16, Colors.white, FontWeight.w700),
          ),
        ),
      ),
    );
  }

  // ─── Shared helpers ───────────────────────────────────────────────────────
  Widget _cardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _cardTitle(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20.h,
          decoration: BoxDecoration(
            color: _teal,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 10.w),
        Text(text,
            style: appstyle(17, const Color(0xFF111111), FontWeight.w700)),
      ],
    );
  }
}
