
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/resources/colors/app_colors.dart';

class QualityCircularContainerText extends StatelessWidget {
  const QualityCircularContainerText({
    super.key,
    required this.isTransparent,
    required this.text,
  });

  final bool isTransparent;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          color: isTransparent ? Colors.grey : AppColors.cardWhite,
        ),
        fontSize: 20,
        fontWeight: .w800,
      ),
    );
  }
}
