import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:texops/resources/colors/app_colors.dart';

class SendIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDisabled;

  const SendIconButton({
    Key? key,
    required this.onTap,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedOpacity(
        opacity: isDisabled ? 0.6 : 1,
        duration: const Duration(milliseconds: 180),
        child: Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppColors.primaryDarkTeal,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Iconsax.send_1,
            size: 20,
            color: AppColors.cardWhite,
          ),
        ),
      ),
    );
  }
}
