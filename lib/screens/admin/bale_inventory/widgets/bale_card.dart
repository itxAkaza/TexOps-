import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/resources/colors/app_colors.dart';

enum BaleStatus { inStorage, sentForYarn, testing, completed }

enum LabStatus { pending, completed, failed }

class BaleModel {
  final String baleId;
  final String materialType;
  final String vendor;
  final String weight;
  final double purchasePrice;
  final BaleStatus status;
  final LabStatus labStatus;

  BaleModel({
    required this.baleId,
    required this.materialType,
    required this.vendor,
    required this.weight,
    required this.purchasePrice,
    required this.status,
    required this.labStatus,
  });
}

class BaleCard extends StatelessWidget {
  final BaleModel bale;
  final VoidCallback? onTap;

  const BaleCard({super.key, required this.bale, this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(bale.status);
    final labColor = getLabStatusColor(bale.labStatus);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardOffWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.accentOrange.withOpacity(0.18),
            width: 1,
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOP ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bale #${bale.baleId}",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDarkTeal,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    getStatusText(bale.status),
                    style: GoogleFonts.poppins(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// MATERIAL TYPE
            _InfoTile(title: "Material Type", value: bale.materialType),

            const SizedBox(height: 12),

            /// VENDOR + WEIGHT
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _InfoTile(title: "Vendor", value: bale.vendor),
                ),

                Expanded(
                  child: _InfoTile(title: "Weight", value: bale.weight),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// PURCHASE PRICE
            _InfoTile(
              title: "Purchase Price",
              value: "₨${bale.purchasePrice.toStringAsFixed(0)}",
            ),

            const SizedBox(height: 16),

            /// LAB STATUS
            Row(
              children: [
                Icon(
                  bale.labStatus == LabStatus.completed
                      ? Icons.check
                      : Icons.science_outlined,
                  size: 15,
                  color: labColor,
                ),

                const SizedBox(width: 6),

                Text(
                  "Lab Testing:",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(width: 4),

                Text(
                  getLabStatusText(bale.labStatus),
                  style: GoogleFonts.poppins(
                    color: labColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// STATUS COLOR
  Color getStatusColor(BaleStatus status) {
    switch (status) {
      case BaleStatus.inStorage:
        return AppColors.accentOrange;

      case BaleStatus.sentForYarn:
        return AppColors.primaryDarkTeal;

      case BaleStatus.testing:
        return Colors.purple;

      case BaleStatus.completed:
        return Colors.green;
    }
  }

  /// LAB STATUS COLOR
  Color getLabStatusColor(LabStatus status) {
    switch (status) {
      case LabStatus.pending:
        return AppColors.accentOrange;

      case LabStatus.completed:
        return Colors.green;

      case LabStatus.failed:
        return Colors.red;
    }
  }

  /// STATUS TEXT
  String getStatusText(BaleStatus status) {
    switch (status) {
      case BaleStatus.inStorage:
        return "In Storage";

      case BaleStatus.sentForYarn:
        return "Sent for Yarn";

      case BaleStatus.testing:
        return "Testing";

      case BaleStatus.completed:
        return "Completed";
    }
  }

  /// LAB STATUS TEXT
  String getLabStatusText(LabStatus status) {
    switch (status) {
      case LabStatus.pending:
        return "Pending";

      case LabStatus.completed:
        return "Completed";

      case LabStatus.failed:
        return "Failed";
    }
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const _InfoTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: AppColors.textGrey,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            height: 1.3,
            color: AppColors.primaryDarkTeal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
