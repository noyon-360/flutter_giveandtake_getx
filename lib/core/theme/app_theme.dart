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
      // White-on-white made every default AppBar's back arrow / action icons
      // invisible. Use black so they show on the white bar. Screens with a
      // coloured AppBar set their own iconTheme, overriding this.
      iconTheme: IconThemeData(color: Colors.black),
      actionsIconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 24,
        color: Color(0xFF1A3E74),
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
