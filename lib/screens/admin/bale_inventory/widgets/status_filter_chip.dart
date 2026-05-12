import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/resources/colors/app_colors.dart';

class StatusFilterChip extends StatelessWidget {
  const StatusFilterChip({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chipBuild("All Bales", true),
          _chipBuild("Pending Lab Test", false),
          _chipBuild("Ready for Yarn", true),
        ],
      ),
    );
  }
}

Widget _chipBuild(String label, bool isSelected) {
  return Container(
    margin: EdgeInsets.only(right: 8),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: isSelected ? AppColors.primaryDarkTeal : AppColors.cardOffWhite,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isSelected ? AppColors.primaryDarkTeal : Colors.grey.shade200,
      ),
    ),
    child: Text(
      label,
      style: GoogleFonts.poppins(
        color: isSelected ? Colors.white : AppColors.primaryDarkTeal,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
