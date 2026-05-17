import 'package:flutter/material.dart';

class QualityResponsiveText extends StatelessWidget {
  const QualityResponsiveText({
    super.key,
    required this.text,
    required this.style,
    this.maxLines,
    this.textAlign,
    this.overflow = TextOverflow.ellipsis,
    this.softWrap,
  });

  final String text;
  final TextStyle style;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow overflow;
  final bool? softWrap;

  double _scaleFactor(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return (width / 390).clamp(0.82, 1.08);
  }

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = _scaleFactor(context);
    final double fontSize = (style.fontSize ?? 14) * scaleFactor;

    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      softWrap: softWrap ?? (maxLines != 1),
      style: style.copyWith(fontSize: fontSize),
    );
  }
}
