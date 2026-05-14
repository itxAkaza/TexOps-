import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/lab_engineer/record_gatePass/widgets/stepper.dart';

import '../../../controllers/lab_engineer/record_gatePass/gatePass_controller.dart';
import 'components/bail_form.dart';
import 'components/gatePass_form.dart';


class BaleEntryScreen extends StatelessWidget {
  BaleEntryScreen({Key? key}) : super(key: key);

  final BaleEntryController controller = Get.put(BaleEntryController());

  @override
  Widget build(BuildContext context) {
    final height =MediaQuery.of(context).size.height;
    final width =MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDarkTeal),
          onPressed: () {
            if (controller.currentStep.value == 1)
            {
              controller.goToPreviousStep();
            } else {
              Get.back();
            }
          },
        ),
        title: Obx(() => Text(
          controller.currentStep.value == 0 ? 'Record Gate Pass' : 'Record Bale Data',
          style: const TextStyle(color: AppColors.primaryDarkTeal, fontWeight: FontWeight.bold),
        )),
      ),

      body: Column(
        children: [
          SizedBox(height: height*0.04),
          CustomStepper(height: height,width: width,),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),

              child: Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: controller.currentStep.value == 0
                    ?  GatePassForm(key: ValueKey('step1'))
                    :  BaleInventoryForm(key: ValueKey('step2')),
              )),
            ),
          ),
        ],
      ),
    );
  }
}