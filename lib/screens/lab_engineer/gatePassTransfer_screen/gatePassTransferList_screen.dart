
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:texops/resources/colors/app_colors.dart';

import '../../../controllers/lab_engineer/gatePassTransfer/gatePassTransfer_controller.dart';


class GatePassTransferListScreen extends StatelessWidget {
  const GatePassTransferListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GatePassTransferController());

    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primaryDarkTeal),
        title: const Text(
          "Outbound Queue",
          style: TextStyle(color: AppColors.primaryDarkTeal, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Obx(() {
        if (controller.readyForTransferBales.isEmpty) {
          return const Center(
            child: Text("No inventory cleared for transfer yet.", style: TextStyle(color: AppColors.textGrey, fontSize: 16)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: controller.readyForTransferBales.length,
          itemBuilder: (context, index) {
            var bale = controller.readyForTransferBales[index];
            double totalValue = controller.getGatePassTotal(bale);

            return GestureDetector(
              onTap: () => controller.openTransferDetails(bale),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withOpacity(0.4), width: 1.2),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.verified, color: Colors.green, size: 14),
                              SizedBox(width: 6),
                              Text("Quality Verified", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        ),
                        Text(
                          bale['arrivalTime'] ?? '',
                          style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primaryDarkTeal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.outbound_rounded, color: AppColors.primaryDarkTeal, size: 26),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "GatePass #${bale['gatePassRef'] ?? 'N/A'}",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDarkTeal),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${bale['supplier']} | ${bale['baleType']}",
                                style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              NumberFormat.currency(symbol: 'Rs ', decimalDigits: 0).format(totalValue),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.accentOrange),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${bale['weight'] ?? '0'} kg",
                              style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}