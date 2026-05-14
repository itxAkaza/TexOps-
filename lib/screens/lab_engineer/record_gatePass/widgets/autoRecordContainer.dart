import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/screens/lab_engineer/record_gatePass/widgets/text.dart';

import '../../../../controllers/lab_engineer/record_gatePass/gatePass_controller.dart';
import '../../../../resources/colors/app_colors.dart';

class AutoRecordedContainer extends StatelessWidget {
  final double height;
  final double width;
  final String text;
  final String autoValue;

  AutoRecordedContainer({super.key,
    required this.height,
    required this.width,
    required this.text,
    required this.autoValue
  });

  final baleController = Get.find<BaleEntryController>();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          MYText(text: text),
          SizedBox(height: 6,),
          Container(
            height: height*0.07,
            width: width*0.9,
            decoration: BoxDecoration(
                color:AppColors.autoRecorded,
                borderRadius: BorderRadius.circular(15)
            ),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              crossAxisAlignment: .center,
              children: [
                MYText(text: "Auto Recorded: "),
                Text(autoValue)
              ],
            ),

          ),
        ],
      ),
    );
  }
}
