import 'package:flutter/material.dart';

class RaqamiText extends StatelessWidget {
  const RaqamiText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.softWrap = true,
    this.textHeightBehavior,
    this.maxLines,
    this.textColor,
    this.fontSize,
  });
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool softWrap;
  final Color? textColor;
  final TextHeightBehavior? textHeightBehavior;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.copyWith(color: textColor,fontSize: fontSize) ?? TextStyle(color: textColor,fontSize: fontSize),
      softWrap: softWrap,
      textAlign: textAlign,
      maxLines: maxLines,
    
      textHeightBehavior: textHeightBehavior,
    );
  }
}
