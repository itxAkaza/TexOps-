import 'package:flutter/material.dart';

class StatelessExpandableInputCard extends StatelessWidget {
  final String title;
  
  // State variables passed from the parent
  final bool isExpanded;
  final VoidCallback onToggle;
  
  // Input configuration
  final bool hasMultipleInputs;
  final List<String> inputLabels;
  final List<String> inputHints;
  final Widget? bottomWidget;

  const StatelessExpandableInputCard({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    required this.hasMultipleInputs,
    required this.inputLabels,
    required this.inputHints,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    // Colors matching your UI
    const Color darkTeal = Color(0xFF1B3B46);
    const Color accentOrange = Color(0xFFFDB45C);
    const Color borderColor = Color(0xFFE5E7EB);
    const Color labelColor = Color(0xFF4B5563);

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header (Tappable, triggers the callback passed from parent)
            InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: darkTeal,
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: isExpanded ? accentOrange : darkTeal,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),

            // Expanded Content (Only builds if parent says isExpanded is true)
            if (isExpanded) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: borderColor, height: 1, thickness: 1),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logic for Single vs Multiple Inputs
                    if (hasMultipleInputs)
                      Row(
                        children: List.generate(
                          inputLabels.length,
                          (index) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index < inputLabels.length - 1 ? 16.0 : 0,
                              ),
                              child: _buildInputField(
                                inputLabels[index],
                                inputHints[index],
                                darkTeal,
                                labelColor,
                                borderColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      _buildInputField(
                        inputLabels.first,
                        inputHints.first,
                        darkTeal,
                        labelColor,
                        borderColor,
                      ),

                    // Formula Box or other bottom widgets
                    if (bottomWidget != null) ...[
                      const SizedBox(height: 16),
                      bottomWidget!,
                    ]
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Internal visual builder for the text fields
  Widget _buildInputField(String label, String hint, Color darkTeal, Color labelColor, Color borderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: darkTeal,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: darkTeal, width: 1.5),
            ),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }
}