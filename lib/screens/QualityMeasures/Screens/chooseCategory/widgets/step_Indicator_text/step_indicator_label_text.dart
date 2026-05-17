
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/resources/colors/app_colors.dart'; // Adjust path if needed
import 'package:texops/screens/QualityMeasures/Screens/Common/quality_responsive_text.dart';

class StepIndicatorLabelText extends StatelessWidget {
  final int currentStep; // The screen we are currently on
  final int stepIndex;   // The number of this specific text label
  final String text;

  const StepIndicatorLabelText({
    super.key,
    required this.currentStep,
    required this.stepIndex,
    required this.text, Object? isActive,
  });

  @override
  Widget build(BuildContext context) {
    // Only highlight the text if the screen strictly matches this step
    final bool isActive = currentStep == stepIndex;

    return QualityResponsiveText(
      text: text,
      textAlign: TextAlign.center,
      maxLines: 2,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: isActive ? AppColors.primaryDarkTeal : Colors.grey,
        ),
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}