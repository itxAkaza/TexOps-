import 'package:flutter/material.dart';
import 'package:texops/resources/colors/app_colors.dart';

class ECircularContainer extends StatelessWidget {
  const ECircularContainer({
    super.key,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.padding = 0,
    this.child,
    this.bgColor = AppColors.backgroundLightPeach,
    this.margin,
    this.wantBgColor = false,
    required this.wantBorder,
  });

  final double? width;
  final double? height;
  final double radius;
  final double? padding;
  final Widget? child;
  final Color bgColor;
  final EdgeInsets? margin;
  final bool wantBgColor;
  final bool wantBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: EdgeInsets.all(padding!),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: wantBorder ? Border.all(color: Colors.grey) : null,
        color: wantBgColor ? bgColor : Colors.transparent,
      ),
      child: child,
    );
  }
}
