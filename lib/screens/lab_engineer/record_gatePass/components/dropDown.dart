import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/screens/lab_engineer/record_gatePass/widgets/text.dart';

import '../../../../controllers/lab_engineer/record_gatePass/gatePass_controller.dart';
import '../../../../resources/colors/app_colors.dart';

class MYDropDown extends StatelessWidget {
  const MYDropDown({super.key});

  @override
  Widget build(BuildContext context) {

    final baleController = Get.find<BaleEntryController>();

    return   Obx(() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 8),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          MYText(text: "Supplier Name"),
          SizedBox(height: 6,),
          DropdownButtonFormField<String>(
            value: baleController.selectedSupplier.value,
            hint: const Text(
              'Select Supplier',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 15,
              ),
            ),
            dropdownColor:AppColors.cardOffWhite,
          
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.grey[500]!, // Light grey border color
                  width: 1,
                ),
              ),
              // Focused border
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primaryDarkTeal,
                  width: 1.5,
                ),
              ),
              // Background color of the field
              filled: true,
              fillColor: Colors.white,
            ),
          
            items: baleController.suppliers.map((String supplier) {
              return DropdownMenuItem<String>(
                value: supplier,
                child: Text(supplier),
              );
            }).toList(),
          
            onChanged: (String? value) {
              baleController.selectedSupplier.value = value;
            },

            style: GoogleFonts.poppins(textStyle: TextStyle(color: AppColors.textGrey)),
          ),
        ],
      ),
    ));
  }
}
