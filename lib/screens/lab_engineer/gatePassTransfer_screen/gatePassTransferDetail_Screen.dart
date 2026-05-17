import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/lab_engineer/bailBarcode/widget/qrButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../controllers/lab_engineer/gatePassTransfer/gatePassTransfer_controller.dart';


class GatePassTransferDetailScreen extends StatelessWidget {
  const GatePassTransferDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GatePassTransferController>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primaryDarkTeal),
        title: const Text(
          "Outbound Manifest",
          style: TextStyle(color: AppColors.primaryDarkTeal, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Obx(() {
        var bale = controller.selectedBale;
        if (bale.isEmpty) return const SizedBox.shrink();

        double price = double.tryParse(bale['price']?.toString() ?? '0') ?? 0.0;
        String formattedPrice = NumberFormat.currency(symbol: 'Rs ', decimalDigits: 0).format(price);

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Colors.white,
                elevation: 8,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      QrImageView(
                        data: controller.getSlimQrData(),

                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                        size: 200,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "GatePass #${bale['gatePassRef']}",
                        style: const TextStyle(color: AppColors.primaryDarkTeal, fontWeight: FontWeight.w900, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Bale ID: ${bale['baleId']}",
                        style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              _buildSectionHeader(Icons.inventory_2_outlined, "Inventory & Logistics"),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildDataCol("Supplier", bale['supplier'] ?? "N/A"),
                        _buildDataCol("Vehicle No.", bale['vehicleNumber'] ?? "N/A"),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        _buildDataCol("Material Type", bale['baleType'] ?? "N/A"),
                        _buildDataCol("Total Bales", "${bale['baleCount'] ?? '0'}"),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        _buildDataCol("Total Quantity", bale['quantity']?.toString() ?? "0"),
                        _buildDataCol("Total Weight", "${bale['weight'] ?? '0'} kg"),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        _buildDataCol("Total Cost", formattedPrice, isHighlight: true),
                        _buildDataCol("Engineer ID", bale['engineerID'] ?? "N/A"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              _buildSectionHeader(Icons.science_outlined, "Comprehensive Quality Report"),
              const SizedBox(height: 15),

              Builder(
                  builder: (context) {
                    var fibreTest = bale['qualitytests.fibre'];
                    var yarnTest = bale['qualitytests.yarn'];
                    var fabricTest = bale['qualitytests.fabric'];

                    if (fibreTest != null || yarnTest != null || fabricTest != null) {
                      return Column(
                        children: [
                          if (fibreTest != null)
                            _buildQualityTestCard("Fibre Testing", fibreTest),

                          if (yarnTest != null)
                            _buildQualityTestCard("Yarn Testing", yarnTest),

                          if (fabricTest != null)
                            _buildQualityTestCard("Fabric Testing", fabricTest),
                        ],
                      );
                    } else {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                            child: Text(
                                "Basic Quality Cleared\n(Detailed metrics map not found in database)",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.textGrey)
                            )
                        ),
                      );
                    }
                  }
              ),
              const SizedBox(height: 40),

              QrButton(
                text: "Share Full Record PDF",
                height: height * 0.07,
                width: width,
                onTap: controller.shareQRAsPDF,
                color: AppColors.primaryDarkTeal,
                icon: Icons.picture_as_pdf_outlined,
              ),
              const SizedBox(height: 15),
              QrButton(
                text: controller.isLoading.value ? "Processing..." : "Confirm Outbound Transfer",
                height: height * 0.07,
                width: width,
                isLoading: controller.isLoading.value,
                onTap: controller.isLoading.value ? null : () => controller.executeTransfer(),
                color: AppColors.accentOrange,
                icon: Icons.local_shipping_outlined,
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryDarkTeal, size: 22),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDarkTeal),
        ),
      ],
    );
  }

  Widget _buildDataCol(String title, String value, {bool isHighlight = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: isHighlight ? AppColors.accentOrange : AppColors.primaryDarkTeal,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityTestCard(String title, Map<String, dynamic> testData) {
    String grade = testData['calculatedGrade'] ?? 'N/A';
    Map<String, dynamic> metrics = testData['metrics'] ?? {};

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: AppColors.primaryDarkTeal.withOpacity(0.03),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDarkTeal, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                  child: Text(grade, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                )
              ],
            ),
          ),

          if (metrics.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 20,
                runSpacing: 15,
                children: metrics.entries.map((entry) {
                  String formattedKey = entry.key.replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}').capitalizeFirst ?? entry.key;

                  return SizedBox(
                    width: (Get.width / 2) - 55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(formattedKey, style: TextStyle(color: Colors.grey.shade500, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(entry.value.toString(), style: const TextStyle(color: AppColors.primaryDarkTeal, fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text("No detailed metrics recorded.", style: TextStyle(color: Colors.grey)),
            )
        ],
      ),
    );
  }
}