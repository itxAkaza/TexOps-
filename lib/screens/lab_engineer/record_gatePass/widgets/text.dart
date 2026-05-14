import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MYText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final FontWeight fontweight;
  const MYText({super.key,
  required this.text,
    this.color=Colors.black,
    this.size=13,
    this.fontweight=FontWeight.w400
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
    style: GoogleFonts.poppins(
      textStyle: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontweight
      )
    ),
    );
  }
}
