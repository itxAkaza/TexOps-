import 'package:flutter/material.dart';

class CalculatedDenierWidget extends StatelessWidget {
  /// The final calculated value passed down from your state controller.
  /// Pass something like "1.0" or "0.0" when ready.
  final String calculatedValue;

  const CalculatedDenierWidget({
    super.key,
    required this.calculatedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        
        // The Italicized Formula Text
        const Text(
          'Formula: (Weight / Length) × 9000',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // The Orange Result Container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED), // The light orange background
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Calculated Denier:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B3B46), // Dark Teal
                ),
              ),
              Text(
                '$calculatedValue D', // Appends the " D" automatically
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFDB45C), // Accent Orange
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}