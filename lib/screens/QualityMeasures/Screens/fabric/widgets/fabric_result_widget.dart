import 'package:flutter/material.dart';

class FabricCalculatedResultWidget extends StatelessWidget {
  final String formulaText;
  final String resultTitle;
  final String calculatedValue;
  final String units;

  const FabricCalculatedResultWidget({
    super.key,
    required this.formulaText,
    required this.resultTitle,
    required this.calculatedValue,
    this.units = '',
  });

  @override
  Widget build(BuildContext context) {
    final String displayValue = units.isEmpty ? calculatedValue : '$calculatedValue $units';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          formulaText,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
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
                displayValue,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFDB45C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}