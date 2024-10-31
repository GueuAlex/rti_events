import 'package:flutter/material.dart';

class AppText extends Text {
  final Color? color;
  final FontWeight? fontWeight;
  final double? height;
  final double? letterSpacing;
  final double? fontSize;

  AppText.small(
    super.data, {
    super.key,
    this.letterSpacing = 0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    super.textAlign = TextAlign.left,
    int? maxLine,
    TextOverflow? textOverflow,
    this.height,
    this.fontSize = 12,
  }) : super(
          maxLines: maxLine,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            height: height,
            fontWeight: fontWeight,
            overflow: textOverflow,
            letterSpacing: letterSpacing,
          ),
        );

  AppText.medium(
    super.data, {
    super.key,
    this.letterSpacing = 0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w600,
    super.textAlign = TextAlign.left,
    int? maxLine,
    TextOverflow? textOverflow,
    this.height,
    this.fontSize = 14,
  }) : super(
          maxLines: maxLine,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            height: height,
            fontWeight: fontWeight,
            overflow: textOverflow,
            letterSpacing: letterSpacing,
          ),
        );

  AppText.large(
    super.data, {
    super.key,
    this.letterSpacing = 0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.bold,
    super.textAlign = TextAlign.center,
    int? maxLine,
    TextOverflow? textOverflow,
    this.height,
    this.fontSize = 24,
  }) : super(
          maxLines: maxLine,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            height: height,
            fontWeight: fontWeight,
            overflow: textOverflow,
            letterSpacing: letterSpacing,
          ),
        );

  AppText.normal(
    super.data, {
    super.key,
    this.letterSpacing = 0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    super.textAlign = TextAlign.center,
    int? maxLine,
    TextOverflow? textOverflow,
    this.height,
    this.fontSize,
  }) : super(
          maxLines: maxLine,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            height: height,
            fontWeight: fontWeight,
            overflow: textOverflow,
            letterSpacing: letterSpacing,
          ),
        );
}
