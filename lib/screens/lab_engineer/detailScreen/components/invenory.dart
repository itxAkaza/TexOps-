

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../../../resources/colors/app_colors.dart';

class InventoryDataCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const InventoryDataCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Format price if available
    double rawPrice = double.tryParse(data['price']?.toString() ?? '0') ?? 0.0;
    String formattedPrice = NumberFormat.currency(symbol: 'Rs', decimalDigits: 0).format(rawPrice);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Receiving & Inventory Data",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDarkTeal),
          ),

          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildInfoItem("Supplier", data['supplier'] ?? 'N/A')),
              Expanded(child: _buildInfoItem("Vehicle No.", data['vehicleNumber'] ?? 'N/A')),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(child: _buildInfoItem("Arrival Time", data['arrivalTime'] ?? 'N/A',size: 14)),
              SizedBox(width: 2,),
              Expanded(child: _buildInfoItem("Engineer ID", data['engineerID'] ?? 'N/A')),
            ],
          ),

          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildInfoItem("Material Type", data['baleType'] ?? 'N/A')),
              Expanded(child: _buildInfoItem("Quantity", "${data['quantity'] ?? '0'} Bales")),
            ],
          ),

          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildInfoItem("Weight", "${data['weight'] ?? '0'} kg")),
              Expanded(child: _buildInfoItem("Purchase Price", formattedPrice)),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, {double size = 15})
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDarkTeal, fontSize: size)),
      ],
    );
  }
}