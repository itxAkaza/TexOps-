// Location: QualityMeasures/Screens/chooseCategory/widgets/step_progress_indicator.dart


import 'package:flutter/material.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/circular_container.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/quality_container_text.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep; // Pass the current screen's step here

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // --- STEP 1 ---
          ECircularContainer(
            bgColor: AppColors.accentOrange,
            height: 50,
            width: 50,
            wantBgColor: currentStep == 1, // Only true if exactly step 1
            wantBorder: currentStep != 1,
            child: Center(
              child: QualityCircularContainerText(
                isTransparent: currentStep != 1,
                text: '1',
              ),
            ),
          ),

          Container(width: 40, height: 2, color: Colors.grey),

          // --- STEP 2 ---
          ECircularContainer(
            bgColor: AppColors.accentOrange,
            height: 50,
            width: 50,
            wantBgColor: currentStep == 2, // Only true if exactly step 2
            wantBorder: currentStep != 2,
            child: Center(
              child: QualityCircularContainerText(
                isTransparent: currentStep != 2,
                text: '2',
              ),
            ),
          ),

          Container(width: 40, height: 2, color: Colors.grey),

          // --- STEP 3 ---
          ECircularContainer(
            bgColor: AppColors.accentOrange,
            height: 50,
            width: 50,
            wantBgColor: currentStep == 3, // Only true if exactly step 3
            wantBorder: currentStep != 3,
            child: Center(
              child: QualityCircularContainerText(
                isTransparent: currentStep != 3,
                text: '3',
              ),
            ),
          ),
        ],
      ),
    );
  }
}