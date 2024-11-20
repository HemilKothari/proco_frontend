import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub_v1/views/common/exports.dart';

class MessaginTextField extends StatelessWidget {
  const MessaginTextField({
    required this.messageController,
    required this.sufixIcon,
    super.key,
    this.onChanged,
    this.onEditingComplete,
    this.onTapOutside,
    this.onSubmitted,
  });

  final TextEditingController messageController;
  final Widget sufixIcon;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Color(kDarkGrey.value),
      controller: messageController,
      keyboardType: TextInputType.multiline,
      style: appstyle(16, Color(kDark.value), FontWeight.w500),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(6.h),
        filled: true,
        fillColor: Color(kLight.value),
        suffixIcon: sufixIcon,
        hintText: 'Type your message here',
        hintStyle: appstyle(14, Color(kDarkGrey.value), FontWeight.normal),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.h),
          ),
          borderSide: BorderSide(color: Color(kDarkGrey.value)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.h),
          ),
          borderSide: BorderSide(color: Color(kDarkGrey.value)),
        ),
      ),
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onTapOutside: onTapOutside,
      onSubmitted: onSubmitted,
    );
  }
}
