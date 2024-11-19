import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub_v1/views/common/exports.dart';

class SearchLoading extends StatelessWidget {
  const SearchLoading({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/optimized_search.png'),
          ReusableText(
            text: text,
            style: appstyle(24, Color(kDark.value), FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
