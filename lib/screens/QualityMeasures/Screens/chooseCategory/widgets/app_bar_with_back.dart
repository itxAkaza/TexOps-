// TODO: AppBarWithBack — reusable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/QualityMeasures/Screens/Common/quality_responsive_text.dart';


/// A generic reusable AppBar with a back arrow, centered title,
/// and an optional trailing widget. Used across all inner screens.
class AppBarWithBack extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? trailingWidget;

  const AppBarWithBack({
    super.key,
    required this.title,
    this.onBack,
    this.trailingWidget,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundLightPeach,
      elevation: 0,
      scrolledUnderElevation: 0,
      //centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.primaryDarkTeal,
          size: 20,
        ),
        onPressed: onBack ?? () => Get.back(),
      ),
      title: QualityResponsiveText(
        text: title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: AppColors.primaryDarkTeal,
        ),
        maxLines: 1,
        softWrap: false,
      ),
      actions: [
        trailingWidget ?? const SizedBox(width: 48),
      ],
    );
  }
}
