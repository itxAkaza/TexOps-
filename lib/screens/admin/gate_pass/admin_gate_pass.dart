import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/controllers/admin/gate_pass_controller.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/admin/gate_pass/widgets/gate_pass_card.dart';
import 'package:texops/screens/admin/gate_pass/widgets/gate_pass_header.dart';

class AdminGatePass extends StatelessWidget {
  AdminGatePass({super.key});
  final GatePassController controller = Get.put(GatePassController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.primaryDarkTeal,
              size: 20,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "All Gate Passes",
              style: GoogleFonts.poppins(
                color: AppColors.primaryDarkTeal,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          GatePassHeader(controller: controller),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              final list = controller.displayedPasses;
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return GatePassCard(model: list[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
