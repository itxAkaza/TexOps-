import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/screens/lab_engineer/record_gatePass/components/dropDown.dart';
import 'package:texops/screens/lab_engineer/record_gatePass/widgets/autoRecordContainer.dart';
import 'package:texops/screens/lab_engineer/record_gatePass/widgets/bailButon.dart';
import 'package:texops/screens/onBoarding/widgets/my_button.dart';

import '../../../../controllers/lab_engineer/record_gatePass/gatePass_controller.dart';
import '../../../../resources/colors/app_colors.dart';
import '../widgets/TextFormField.dart';
import '../widgets/text.dart';


class GatePassForm extends StatelessWidget {
  const GatePassForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baleController = Get.find<BaleEntryController>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;


    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            SizedBox(height: height * 0.02,),
            _buildTextField(
                text: "Gate Pass Refrence id",
                hint: "e.g., GatePass: #GP-4567",
                controller: baleController.gatePassRefController
            ),

            MYDropDown(),

            _buildTextField(
                text: "Vehicle Number",
                hint: "e.g., L-49201",
                controller: baleController.vehicleNumberController,
            ),



            AutoRecordedContainer(
                height: height,
                width: width,
                text: "Arrival Time",
                autoValue: baleController.arrivalTime.toString()
            ),



            SizedBox(height: height*0.1,),


            BailButton(
              onTap: baleController.goToNextStep,
                text: "Continue to Bale Entry ",
                height: height*0.07,
                width: width*0.9,
              icon: Icons.arrow_forward,

            )

          ],
        ),


      ),
    );
  }

}

Widget _buildTextField({required String text,required String hint,required TextEditingController controller,TextInputType type=TextInputType.text}){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 8),
    child: Column(
      crossAxisAlignment: .start,
      children: [
        MYText(text: text),
        SizedBox(height: 6,),
        MyTextFormField(
          hint: hint,
          controller: controller,
          textType: type,
        )


      ],
    ),
  );
}