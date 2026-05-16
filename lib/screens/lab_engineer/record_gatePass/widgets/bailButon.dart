import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/resources/colors/app_colors.dart';

class BailButton extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final VoidCallback? onTap;
  final IconData icon;

  const BailButton({super.key ,
    required this.text,
    required this.height,
    required this.width,
    required this.onTap,
    required this.icon
  } );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: AppColors.primaryDarkTeal,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text,style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: AppColors.readOnlyBg,
                        fontSize: 17,
                        fontWeight: .w500
                    )
                ),),
                SizedBox(width: 5,),
                Icon(icon,color: Colors.white,)
              ],
            )
          ),
        ),
      ),
    );
  }
}
