

import 'package:flutter/material.dart';
import 'package:texops/resources/colors/app_colors.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/circular_container.dart';
import 'package:texops/screens/QualityMeasures/Screens/chooseCategory/widgets/curved_edges/curved_edges_widget.dart';

class EPrimaryHeaderContainer extends StatelessWidget {
  const EPrimaryHeaderContainer({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ECurvedEdgesWidget(
      child: Container(
        color: AppColors.backgroundLightPeach,
        padding: EdgeInsets.zero,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -150,
              right: -250,
              child: ECircularContainer(
                bgColor: AppColors.backgroundLightPeach.withValues(alpha: 0.1), wantBorder: false,
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: ECircularContainer(
                bgColor: AppColors.backgroundLightPeach.withValues(alpha: 0.1), wantBorder: false,
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
