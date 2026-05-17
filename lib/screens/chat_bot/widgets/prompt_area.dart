import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/resources/colors/app_colors.dart';

class PromptArea extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;

  const PromptArea({
    Key? key,
    required this.controller,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(28),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(color: AppColors.primaryDarkTeal),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Ask me anything about Textile',
          hintStyle: GoogleFonts.poppins(
            textStyle: const TextStyle(color: AppColors.textGrey),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          isCollapsed: true,
        ),
        maxLines: 1,
        textInputAction: TextInputAction.send,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
