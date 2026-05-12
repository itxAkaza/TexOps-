import 'package:flutter/material.dart';

import 'package:texops/resources/colors/app_colors.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key, required this.onPressed , required this.text});

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDarkTeal, // Dark Teal
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: .bold,
                color: AppColors.cardWhite,
              ),
            ),

            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward,
              size: 20,
              color: AppColors.cardWhite,
            ),
          ],
        ),
      ),
    );
  }
}
