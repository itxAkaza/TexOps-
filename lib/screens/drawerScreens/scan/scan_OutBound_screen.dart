import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texops/resources/colors/app_colors.dart';

class ScannedOutboundScreen extends StatelessWidget {
  final Map<String, dynamic> manifestData;

  const ScannedOutboundScreen({super.key, required this.manifestData});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.verified, color: Colors.green, size: 40),
                  const SizedBox(height: 10),
                  const Text("Quality Assured & Dispatched", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 5),
                  Text("GatePass #${manifestData['gatePassRef'] ?? 'Unknown'}", style: const TextStyle(color: AppColors.primaryDarkTeal, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Base Info
            const Text("Logistics Data", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDarkTeal)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  _buildDataRow("Supplier", manifestData['supplier'] ?? 'N/A'),
                  const Divider(height: 20),
                  _buildDataRow("Material", manifestData['baleType'] ?? 'N/A'),
                  const Divider(height: 20),
                  _buildDataRow("Total Weight", "${manifestData['weight'] ?? '0'} kg"),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Quality Metrics
            const Text("Quality Summary", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDarkTeal)),
            const SizedBox(height: 10),

            // Unpacking the Slim Payload dynamically
            if (manifestData['f_grd'] != 'N/A')
              _buildGradeCard("Fibre Score", manifestData['f_grd'], "Denier: ${manifestData['f_den']} | Length: ${manifestData['f_len']}"),

            if (manifestData['y_grd'] != 'N/A')
              _buildGradeCard("Yarn Score", manifestData['y_grd'], "Count: ${manifestData['y_cnt']} | CLSP: ${manifestData['y_clsp']}"),

            if (manifestData['fab_grd'] != 'N/A')
              _buildGradeCard("Fabric Score", manifestData['fab_grd'], "GSM: ${manifestData['fab_gsm']}"),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textGrey, fontSize: 14)),
        Text(value, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildGradeCard(String title, String grade, String subtext) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDarkTeal, fontSize: 15)),
              const SizedBox(height: 4),
              Text(subtext, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
            child: Text(grade, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          )
        ],
      ),
    );
  }
}