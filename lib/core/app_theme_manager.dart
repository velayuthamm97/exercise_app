import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppThemeManager {
  AppThemeManager._();

  static const Color blackColor = Color(0xFF000000);
  static const Color whiteColor = Color(0xFFFFFFFF);

  static TextStyle customTextStyleWithSize({
    required double size,
    FontWeight weight = FontWeight.normal,
    Color? color,
    bool isHeader = false,
    double lineSpace = 1.0,
    bool isUnderlined = false,
    Color? underlineColor,
    double underlineThickness = 1.0,
  }) {
    return TextStyle(
      fontFamily:
          isHeader
              ? GoogleFonts.montserrat().fontFamily
              : GoogleFonts.openSans().fontFamily,
      height: lineSpace,
      color: color ?? blackColor,
      fontWeight: weight,
      fontSize: size,
      decoration: isUnderlined ? TextDecoration.underline : TextDecoration.none,
      decorationColor: underlineColor,
      decorationThickness: underlineThickness,
    );
  }
}
