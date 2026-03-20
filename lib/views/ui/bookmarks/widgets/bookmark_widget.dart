import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub_v1/controllers/exports.dart';
import 'package:jobhub_v1/models/response/bookmarks/all_bookmarks.dart';
import 'package:jobhub_v1/views/ui/jobs/job_page.dart';
import 'package:provider/provider.dart';

class BookMarkTileWidget extends StatelessWidget {
  const BookMarkTileWidget({required this.job, super.key});
  final AllBookmark job;

  // ─── Theme ────────────────────────────────────────────────────────────────
  static const Color _teal = Color(0xFF08979F);
  static const Color _tealLt = Color(0xFF0BBFCA);
  static const Color _navy = Color(0xFF040326);
  static const Color _orange = Color(0xFFf55631);
  static const Color _green = Color(0xFF089F20);

  @override
  Widget build(BuildContext context) {
    final j = job.job;

    return GestureDetector(
      onTap: () => Get.to(() => JobPage(title: j.company, id: j.id)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // ── Company image sidebar ──────────────────────────────────────
            SizedBox(
              width: 90.w,
              height: 110.h,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    j.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: _teal.withOpacity(0.10),
                      child: const Icon(Icons.business_rounded,
                          color: _teal, size: 32),
                    ),
                  ),
                  // Dark gradient overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.15),
                        ],
                      ),
                    ),
                  ),
                  // Hiring badge
                  if (j.hiring)
                    Positioned(
                      top: 8,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: _green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Hiring',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 9.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Job info ───────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company name
                    Text(
                      j.company,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.sp,
                        color: _tealLt,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),

                    // Job title
                    Text(
                      j.title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15.sp,
                        color: _navy,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),

                    // Location
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            color: _orange, size: 12),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            j.location,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11.sp,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),

                    // Salary + contract
                    Row(
                      children: [
                        if (j.salary != null && j.salary!.isNotEmpty) ...[
                          const Icon(Icons.payments_outlined,
                              color: _teal, size: 12),
                          SizedBox(width: 3.w),
                          Text(
                            '${j.salary} · ${j.period ?? ''}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11.sp,
                              color: _teal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        if (j.contract != null && j.contract!.isNotEmpty) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: _teal.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              j.contract!,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10.sp,
                                color: _teal,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Remove bookmark button ─────────────────────────────────────
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: GestureDetector(
                onTap: () =>
                    context.read<BookMarkNotifier>().deleteBookMark(j.id),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.07),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bookmark_remove_outlined,
                      color: Colors.redAccent, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
