import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/resources/colors/app_colors.dart';

import '../../../../controllers/lab_engineer/record_gatePass/gatePass_controller.dart';

class CustomStepper extends StatelessWidget {
  final double width;
  final double height;

  // Simple constructor, NO 'const' keyword
  CustomStepper({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BaleEntryController>();
    const duration = Duration(milliseconds: 400);

    return Obx(() {
      int step = controller.currentStep.value;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepIndicator(
            stepNumber: 1,
            title: 'Gate Pass',
            isActive: step >= 0,
            duration: duration,
            height: height*0.11,
            width: width*0.11
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: AnimatedContainer(
              duration: duration,
              width: width * 0.3,
              height: 2,
              color: step >= 1 ? AppColors.primaryDarkTeal : Colors.grey[300]!,
            ),
          ),
          _buildStepIndicator(
            stepNumber: 2,
            title: 'Bale Inventory',
            isActive: step >= 1,
            duration: duration,
              height: height*0.11,
              width: width*0.11
          ),
        ],
      );
    });
  }

  Widget _buildStepIndicator({
    required int stepNumber,
    required String title,
    required bool isActive,
    required Duration duration,
    required double height,
    required double width
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: duration,
          width: height,
          height: width,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primaryDarkTeal : Colors.grey[200],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: duration,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: isActive
                  ? const Icon(Icons.check, color: Colors.white, size: 18, key: ValueKey('icon'))
                  : Text(
                stepNumber.toString(),
                key: const ValueKey('text'),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedDefaultTextStyle(
          duration: duration,
          style: TextStyle(
            color: isActive ? const Color(0xFF1B434D) : Colors.grey,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'TextOps',
          ),
          child: Text(title),
        ),
      ],
    );
  }
}