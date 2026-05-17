import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/data/models/gate_pass_model.dart';
import 'package:texops/resources/colors/app_colors.dart';

class GatePassCard extends StatelessWidget {
  final GatePassModel model;

  const GatePassCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    String formattedPrice = "0";

    try {
      double price = double.parse(model.price);
      formattedPrice = price
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    } catch (e) {
      formattedPrice = model.price;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT ICON SECTION
          Column(
            children: [
              SizedBox(height: 15),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryDarkTeal,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                model.vehicleNumber,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatGatepassId(model.baleID),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.primaryDarkTeal,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Text(
                      "${model.gatePassRef} |  ${model.baleType}",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      "PKR $formattedPrice",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.primaryDarkTeal,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                _buildStatusBadge(model.qualityStatus),

                const SizedBox(height: 6),

                Text(
                  model.arrivalTime,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isCompleted) {
    final Color bgColor = isCompleted
        ? AppColors.primaryDarkTeal
        : AppColors.accentOrange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isCompleted ? "Completed" : "Pending",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Formats a raw bale ID string like "ahmed_8902-1" → "Ahmed-8902"
  static String _formatGatepassId(String raw) {
    try {
      final underscoreSplit = raw.split('_');
      final name = underscoreSplit[0];
      final secondPart = underscoreSplit.length > 1 ? underscoreSplit[1] : '';
      final number = secondPart.split('-')[0];
      final formattedName = name.isNotEmpty
          ? name[0].toUpperCase() + name.substring(1)
          : '';
      return "$formattedName-$number";
    } catch (e) {
      return raw;
    }
  }
}
