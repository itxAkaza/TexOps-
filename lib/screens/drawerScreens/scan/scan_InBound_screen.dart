import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:texops/resources/colors/app_colors.dart';

class ScannedInboundScreen extends StatelessWidget {
  final Map<String, dynamic> baleData;

  const ScannedInboundScreen({super.key, required this.baleData});

  @override
  Widget build(BuildContext context) {
    double price = double.tryParse(baleData['price']?.toString() ?? '0') ?? 0.0;
    String formattedPrice = NumberFormat.currency(symbol: 'Rs ', decimalDigits: 0).format(price);

    return Scaffold(
      backgroundColor: AppColors.backgroundLightPeach,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primaryDarkTeal),
        title: const Text(
          "Inbound Bale Data",
          style: TextStyle(color: AppColors.primaryDarkTeal, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Status Header
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.accentOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accentOrange.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.inventory_2_outlined, color: AppColors.accentOrange, size: 40),
                  const SizedBox(height: 10),
                  const Text("Pending Quality Test", style: TextStyle(color: AppColors.accentOrange, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 5),
                  Text("Bale #${baleData['baleId'] ?? 'Unknown'}", style: const TextStyle(color: AppColors.primaryDarkTeal, fontSize: 14)),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Data Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow("GatePass Ref", "#${baleData['gatePassRef'] ?? 'N/A'}"),
                  const Divider(height: 25),
                  _buildRow("Supplier", baleData['supplier'] ?? 'N/A'),
                  const Divider(height: 25),
                  _buildRow("Material Type", baleData['baleType'] ?? 'N/A'),
                  const Divider(height: 25),
                  Row(
                    children: [
                      Expanded(child: _buildCol("Quantity", "${baleData['quantity'] ?? '0'} Bales")),
                      Expanded(child: _buildCol("Weight", "${baleData['weight'] ?? '0'} kg")),
                    ],
                  ),
                  const Divider(height: 25),
                  _buildRow("Total Value", formattedPrice, isHighlight: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textGrey, fontSize: 14)),
        Text(value, style: TextStyle(
          color: isHighlight ? AppColors.primaryDarkTeal : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: isHighlight ? 18 : 14,
        )),
      ],
    );
  }

  Widget _buildCol(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }
}