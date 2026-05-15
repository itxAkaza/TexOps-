import 'package:flutter/material.dart';
import 'package:texops/resources/colors/app_colors.dart';

class MYDrawer extends StatelessWidget {
  const MYDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundLightPeach,
    );
  }
}
