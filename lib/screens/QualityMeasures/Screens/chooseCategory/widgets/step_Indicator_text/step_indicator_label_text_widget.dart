import 'package:flutter/material.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/step_Indicator_text/step_indicator_label_text.dart';

class StepIndicatorLabelTextWidget extends StatelessWidget {
  const StepIndicatorLabelTextWidget({super.key,
  required this.currentStep
  });

  final int currentStep;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceAround,

      children: [
        StepIndicatorLabelText(text: ' Select\n Metric' , currentStep: currentStep,  stepIndex: 1, ),
        Container(width: 40, height: 2, color: Colors.transparent),
        StepIndicatorLabelText(text: 'Record\nData', currentStep: currentStep,  stepIndex: 2, ),

        Container(width: 40, height: 2, color: Colors.transparent),
        StepIndicatorLabelText(text: 'Review\n& Save', currentStep: currentStep,  stepIndex: 3,  ),
      ],
    );
  }
}
