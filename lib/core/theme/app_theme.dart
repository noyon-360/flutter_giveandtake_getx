import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    scaffoldBackgroundColor: AppColors.primaryWhite,
    primaryColor: AppColors.primaryBlue,
    colorScheme: ColorScheme.light(primary: AppColors.primaryBlue),
    textTheme: GoogleFonts.interTextTheme(),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 24,
        color: Color(0xFF1A3E74),
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
