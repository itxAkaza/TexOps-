import 'package:flutter/material.dart';
import 'package:texops/resources/colors/app_colors.dart'; // Adjust if needed

class CalculatedResultWidget extends StatelessWidget {
  final String formulaText;
  final String resultTitle;
  final String calculatedValue;

  const CalculatedResultWidget({
    super.key,
    required this.formulaText,
    required this.resultTitle,
    required this.calculatedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          formulaText,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED), // The light yellow/orange background
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                resultTitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B3B46),
                ),
              ),
              Text(
                calculatedValue,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accentOrange,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
