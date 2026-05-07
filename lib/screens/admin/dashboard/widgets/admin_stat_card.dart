import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/resources/colors/app_colors.dart';

class AdminStatCard extends StatelessWidget {
  final Color backgroundColor;
  final String headingText;
  final IconData icon;
  final String bodyText;
  final String subtitleText;

  const AdminStatCard({
    super.key,
    required this.backgroundColor,
    required this.headingText,
    required this.icon,
    required this.bodyText,
    required this.subtitleText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Touched")));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    headingText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: AppColors.cardOffWhite,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white, size: 18),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              bodyText,
              style: GoogleFonts.poppins(
                color: AppColors.cardOffWhite,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 0.01,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.arrow_right_alt,
                  size: 14,
                  color: AppColors.cardOffWhite,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    subtitleText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: AppColors.cardOffWhite,
                      fontWeight: FontWeight.w400,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
