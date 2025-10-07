import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: AppColors.primaryBlue,
    colorScheme: ColorScheme.light(primary: AppColors.primaryBlue),

    textTheme: GoogleFonts.robotoTextTheme(),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Color(0xFF1A3E74)),
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 24,
        color: Color(0xFF1A3E74),
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
