import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    scaffoldBackgroundColor: AppColors.primaryWhite,
    primaryColor: AppColors.primaryBlue,
    colorScheme: ColorScheme.dark(primary: AppColors.primaryBlue),

    textTheme: GoogleFonts.interTextTheme(),
    // appBarTheme: AppBarTheme(
    //   titleTextStyle: TextStyle(
    //     color: AppColors.,
    //     fontSize: 16,
    //     fontWeight: FontWeight.w600,
    //   ),
    // ),
  );
}
