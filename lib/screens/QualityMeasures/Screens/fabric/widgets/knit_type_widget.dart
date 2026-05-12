import 'package:flutter/material.dart';

class KnitTypeWidget extends StatelessWidget {
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const KnitTypeWidget({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const Color darkTeal = Color(0xFF1B3B46);
    const Color accentOrange = Color(0xFFFDB45C);
    const Color borderColor = Color(0xFFE5E7EB);

    Widget option(String label) {
      final bool isSelected = selectedValue == label;

      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: OutlinedButton(
            onPressed: () => onChanged(label),
            style: OutlinedButton.styleFrom(
              backgroundColor: isSelected ? darkTeal : Colors.white,
              side: BorderSide(
                color: isSelected ? darkTeal : borderColor,
                width: 1.4,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : darkTeal,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Selection: Warp / Weft',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 12),
        Row(children: [option('Warp'), option('Weft')]),
        const SizedBox(height: 8),
        Text(
          'Selected Knit Type: $selectedValue',
          style: const TextStyle(
            color: accentOrange,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
