import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub_v1/controllers/exports.dart';
import 'package:jobhub_v1/models/response/bookmarks/all_bookmarks.dart';
import 'package:jobhub_v1/views/common/app_bar.dart';
import 'package:jobhub_v1/views/common/drawer/drawer_widget.dart';
import 'package:jobhub_v1/views/common/app_style.dart';
import 'package:jobhub_v1/views/ui/bookmarks/widgets/bookmark_widget.dart';
import 'package:provider/provider.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({super.key});

  @override
  State<BookMarkPage> createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  static const Color _teal = Color(0xFF08979F);
  static const Color _navy = Color(0xFF040326);

  @override
  void initState() {
    super.initState();
    // ✅ Load once in initState instead of on every build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookMarkNotifier>().getBookMarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.065.sh),
        child: CustomAppBar(
          text: 'Saved Jobs',
          child: Padding(
            padding: EdgeInsets.only(left: 0.010.sh),
            child: const DrawerWidget(),
          ),
        ),
      ),
      body: Consumer<BookMarkNotifier>(
        builder: (context, bookMarkNotifier, child) {
          return FutureBuilder<List<AllBookmark>>(
            future: bookMarkNotifier.bookmarks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: _teal));
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error ${snapshot.error}',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontFamily: 'Poppins',
                          fontSize: 14.sp)),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmpty();
              }

              final bookmarks = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Count header
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
                    child: Text(
                      '${bookmarks.length} saved job${bookmarks.length == 1 ? '' : 's'}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                      itemCount: bookmarks.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        return BookMarkTileWidget(job: bookmarks[index]);
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

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bookmark_outline_rounded,
              size: 64, color: _teal.withOpacity(0.25)),
          SizedBox(height: 16.h),
          Text('No saved jobs',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: _navy)),
          SizedBox(height: 6.h),
          Text('Swipe up on a job card to save it',
              style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 13.sp, color: Colors.grey)),
        ],
      ),
    );
  }
}
