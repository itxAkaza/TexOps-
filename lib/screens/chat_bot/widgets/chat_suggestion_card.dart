import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/resources/colors/app_colors.dart'; // Adjust path if needed

class ChatSuggestionCard extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final VoidCallback onTap;

  const ChatSuggestionCard({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ), // Adjusted for precise proportions
          decoration: BoxDecoration(
            color: AppColors.cardOffWhite, // The card background
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Circular Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  // Automatically creates the perfect pale background matching your theme
                  color: AppColors.primaryDarkTeal.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  leadingIcon,
                  color: AppColors.primaryDarkTeal,
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              // Title Text
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarkTeal,
                  ),
                ),
              ),

              // Trailing Chevron
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primaryDarkTeal.withValues(
                  alpha: 0.6,
                ), // Slightly faded as per design
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
