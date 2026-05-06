import 'package:flutter/material.dart';

class AdminStatCard extends StatelessWidget {
  final Color backgroundColor;
  final String headingText;
  final IconData icon;
  final String bodyText;
  final String subtextText;

  const AdminStatCard({
    super.key,
    required this.backgroundColor,
    required this.headingText,
    required this.icon,
    required this.bodyText,
    required this.subtextText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  headingText,
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Icon(icon, color: Colors.white, size: 20),
            ],
          ),

          Text(
            bodyText,
            style: textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: -0.5,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.arrow_right_alt,
                size: 16,
                color: Colors.white.withOpacity(0.8),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  subtextText,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
