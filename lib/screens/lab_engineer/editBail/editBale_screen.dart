
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/lab_engineer/record_gatePass/widgets/TextFormField.dart';
import 'package:texops/screens/lab_engineer/record_gatePass/widgets/text.dart';

import '../../../controllers/lab_engineer/edit/edit_bail_controller.dart';
import '../record_gatePass/widgets/bailButon.dart';


class EditBaleScreen extends StatelessWidget {
  const EditBaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditBaleController());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel", style: TextStyle(color: AppColors.primaryDarkTeal, fontWeight: FontWeight.w600)),
        ),
        leadingWidth: 80,
        title: const Text(
          "Edit Bale Data",
          style: TextStyle(color: AppColors.primaryDarkTeal, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              MYText(
                text: "Bale #${controller.originalData['baleId'] ?? 'Unknown'}",
                size: 24,
                color: AppColors.primaryDarkTeal,
                fontweight: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              Text(
                "Only highlighted fields can be modified. Derived\nGatePass data cannot be edited here.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 13,
                ),

              ),
              const SizedBox(height: 25),


              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MYText(
                      text: "Inventory Fields",
                      size: 16,
                      color: AppColors.primaryDarkTeal,
                      fontweight: FontWeight.bold,
                    ),
                    const SizedBox(height: 15),

                    _buildTextFieldRow(
                      text: "Type (Material)",
                      controller: controller.typeController,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFieldRow(
                            text: "Quantity",
                            controller: controller.quantityController,
                            type: TextInputType.number,
                            validator: (val) => controller.validateNumber(val, 'Quantity'),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildTextFieldRow(
                            text: "Weight",
                            controller: controller.weightController,
                            type: TextInputType.number,
                            validator: (val) => controller.validateNumber(val, 'Weight'),
                          ),
                        ),
                      ],
                    ),

                    _buildTextFieldRow(
                      text: "Purchase Price",
                      controller: controller.priceController,
                      type: TextInputType.number,
                      validator: (val) => controller.validateNumber(val, 'Price'),
                    ),


                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppColors.readOnlyBg,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MYText(
                            text: "Reference (GatePass Data)",
                            size: 14,
                            fontweight: FontWeight.bold,
                            color: AppColors.primaryDarkTeal,
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(child: _buildInfoItem("Supplier", controller.originalData['supplier'] ?? 'N/A')),
                              Expanded(child: _buildInfoItem("Vehicle No.", controller.originalData['vehicleNumber'] ?? 'N/A')),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(child: _buildInfoItem("Arrival Time", controller.originalData['arrivalTime'] ?? 'N/A')),
                              Expanded(child: _buildInfoItem("Engineer ID", controller.originalData['engineerID'] ?? 'N/A')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),


              Obx(() {
                return BailButton(
                  onTap: controller.isLoading.value ? null : () => controller.saveChanges(),
                  text: controller.isLoading.value ? "Saving..." : "Save Changes",
                  height: height * 0.07,
                  width: width,
                  icon: Icons.download_outlined,
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTextFieldRow({
    required String text,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MYText(text: text, size: 14, color: AppColors.textGrey),
          const SizedBox(height: 6),
          MyTextFormField(
            hint: "",
            controller: controller,
            textType: type,
            validator: validator,
          )
        ],
      ),
    );
  }


  Widget _buildInfoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDarkTeal, fontSize: 13)),
      ],
    );
  }
}