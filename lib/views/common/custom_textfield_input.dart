import 'package:flutter/material.dart';
import 'package:jobhub_v1/constants/app_constants.dart';
import 'package:jobhub_v1/views/common/app_style.dart';

class CustomTextFieldInput extends StatelessWidget {
  const CustomTextFieldInput({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    super.key,
    this.validator,
    this.suffixIcon,
    this.obscureText,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
          hintStyle: const TextStyle(color: Colors.white70, fontSize: 16),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Colors.red, width: 0.5),
          ),
          focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Colors.red, width: 0.5),
          ),
          border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
        ),
        controller: controller,
        cursorHeight: 25,
        style: const TextStyle(color: Colors.white70, fontSize: 16),
        validator: validator,
      ),
    );
  }
}
