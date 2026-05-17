import 'package:flutter/material.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/quality_responsive_text.dart';

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

  // FIX 1: You must declare the variable here so the class can hold it
  final List<TextEditingController>? inputControllers;
  final List<FocusNode>? inputFocusNodes;

  const StatelessExpandableInputCard({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    required this.hasMultipleInputs,
    required this.inputLabels,
    required this.inputHints,
    this.bottomWidget,
    this.inputControllers, // Keeping your constructor addition
    this.inputFocusNodes,
  });

  @override
  Widget build(BuildContext context) {
    // Colors matching your UI
    const Color darkTeal = Color(0xFF1B3B46);
    const Color accentOrange = Color(0xFFFDB45C);
    const Color borderColor = Color(0xFFE5E7EB);
    const Color labelColor = Color(0xFF4B5563);

    if (isExpanded && inputFocusNodes != null && inputFocusNodes!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final FocusNode target = inputFocusNodes!.first;
        if (!target.hasFocus) {
          target.requestFocus();
        }
      });
    }

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
              color: Colors.black.withValues(alpha: 0.03),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QualityResponsiveText(
                      text: title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: darkTeal,
                      ),
                      maxLines: 1,
                      softWrap: false,
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
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
                                right: index < inputLabels.length - 1
                                    ? 16.0
                                    : 0,
                              ),
                              child: _buildInputField(
                                inputLabels[index],
                                inputHints[index],
                                // FIX 2: Pass the specific controller based on the index
                                inputControllers != null &&
                                        inputControllers!.length > index
                                    ? inputControllers![index]
                                    : null,
                                inputFocusNodes != null &&
                                        inputFocusNodes!.length > index
                                    ? inputFocusNodes![index]
                                    : null,
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
                        // FIX 3: Pass the first controller if it exists
                        inputControllers != null && inputControllers!.isNotEmpty
                            ? inputControllers!.first
                            : null,
                        inputFocusNodes != null && inputFocusNodes!.isNotEmpty
                            ? inputFocusNodes!.first
                            : null,
                        darkTeal,
                        labelColor,
                        borderColor,
                      ),

                    // Formula Box or other bottom widgets
                    if (bottomWidget != null) ...[
                      const SizedBox(height: 16),
                      bottomWidget!,
                    ],
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
  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController? controller, // FIX 4: Accept the controller here
    FocusNode? focusNode,
    Color darkTeal,
    Color labelColor,
    Color borderColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QualityResponsiveText(
          text: label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: darkTeal,
          ),
          maxLines: 1,
          softWrap: false,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller, // FIX 5: Attach it to the field!
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
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
