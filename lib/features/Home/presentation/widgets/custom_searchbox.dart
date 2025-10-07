import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CustomSearchBox extends StatelessWidget {
   final String? hintText;
  const CustomSearchBox({super.key, this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textFieldLightGrey,
        ),
        prefixIcon: Icon(Icons.search, color: AppColors.textFieldLightGrey),
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(width: 1, color: Color(0xFF9EC7DC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(width: 1, color: Color(0xFF9EC7DC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(width: 2, color: Color(0xFF3B9EFF)),
        ),
      ),
    );
  }
}
