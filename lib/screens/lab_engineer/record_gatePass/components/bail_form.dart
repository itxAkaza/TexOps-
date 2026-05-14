import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/resources/route/routes_names.dart';
import 'package:texops/screens/lab_engineer/record_gatePass/widgets/TextFormField.dart';
import 'package:texops/screens/lab_engineer/record_gatePass/widgets/autoRecordContainer.dart';
import 'package:texops/screens/lab_engineer/record_gatePass/widgets/bailButon.dart';

import '../../../../controllers/lab_engineer/record_gatePass/gatePass_controller.dart';
import '../widgets/text.dart';


class BaleInventoryForm extends StatelessWidget {
  const BaleInventoryForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baleController = Get.find<BaleEntryController>();
    final height =MediaQuery.of(context).size.height;
    final width =MediaQuery.of(context).size.width;


    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Form(
          key: baleController.formKeyStep2,
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              SizedBox(height: height*0.01,),

              AutoRecordedContainer(
                  height: height,
                  width: width,
                  text: "Bale ID",
                  autoValue:baleController.generatedBaleId.value
              ),

              _buildTextField(
                  text: "Type/(Material)",
                  hint: "e.g., 30/1 Combed Cotton",
                  controller: baleController.baleTypeController,
                validator: (value) => value == null || value.trim().isEmpty ? 'Material type is required' : null,

              ),
              _buildTextField(
                  text: "Number of Bales Count",
                  hint: "e.g., 50",
                  controller: baleController.baleCountController,
                type: TextInputType.number,
                validator: (value) => baleController.validateNumber(value, 'Bale count'),
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                        text: "Quantity",
                        hint: "e.g., 1",
                        controller: baleController.quantityController,
                        type: TextInputType.number,
                      validator: (value) => baleController.validateNumber(value, 'Quantity'),
                    ),
                  ),

                  SizedBox(width: 10,),

                  Expanded(
                    child: _buildTextField(
                        text: "Weight",
                        hint: "e.g., 100 lbs",
                        controller: baleController.weightController,
                        type: TextInputType.number,
                      validator: (value) => baleController.validateNumber(value, 'Weight'),
                    ),
                  ),
                ],
              ),

               _buildTextField(
                  text: "Purchase Price",
                  hint: "e.g., Rs45,000",
                  controller: baleController.priceController,
                  type: TextInputType.number,
                 validator: (value) => baleController.validateNumber(value, 'Price'),
              ),

              SizedBox(height: 10,),

              BailButton(
                  onTap: (){
                    if (baleController.formKeyStep2.currentState!.validate()) {
                      baleController.submitData();
                      Get.toNamed(RoutesNames.bailBarcodeView);
                    }
                  },
                  text: "Save & Generate QR Tag ",
                  height: height*0.07,
                  width: width,
                  icon: Icons.qr_code
              )


            ],
          ),
        ),


      ),
    );
  }

}


Widget _buildTextField({String? Function(String?)? validator,required String text,required String hint,required TextEditingController controller,TextInputType type=TextInputType.text}){
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
          validator: validator,
        )


      ],
    ),
  );
}