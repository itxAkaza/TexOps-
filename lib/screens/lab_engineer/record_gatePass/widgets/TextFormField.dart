import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/resources/colors/app_colors.dart';

class MyTextFormField extends StatelessWidget {

  final String hint;
  final TextEditingController controller;
  final TextInputType textType;
  final String? Function(String?)? validator;
  const MyTextFormField({super.key,
  required this.hint,
    required this.controller,
    this.textType=TextInputType.text,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textType,
      validator: validator,
      decoration:InputDecoration(
        hintText: hint,

        hintStyle: GoogleFonts.poppins(textStyle: TextStyle(color: AppColors.textFormText)),

          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[500]!,
                width: 1
            ),
              borderRadius: BorderRadius.circular(14)
          ),

          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: AppColors.primaryDarkTeal,
                width: 1.5
              ),
              borderRadius: BorderRadius.circular(14)
          )

      ) ,
      onTapOutside: (_)=>FocusManager.instance.primaryFocus?.unfocus(),

      style: GoogleFonts.poppins(textStyle: TextStyle(color: AppColors.textGrey)),
    );
  }
}
