import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../job_listing/presentation/screens/job_listing_screen.dart';
import '../../../../core/theme/app_colors.dart';

class CustomSearchBox extends StatelessWidget {
  final String? hintText;
  final VoidCallback? onTap;

  const CustomSearchBox({super.key, this.hintText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Get.to(() => const JobListingScreen()),
      child: Container(
        child: TextField(
          enabled: false, // Make it non-editable, only tappable
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textFieldLightGrey,
            ),
            prefixIcon: Icon(Icons.search, color: AppColors.textFieldLightGrey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(width: 1, color: Color(0xFF9EC7DC)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(width: 1, color: Color(0xFF9EC7DC)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(width: 1, color: Color(0xFF9EC7DC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(width: 2, color: Color(0xFF3B9EFF)),
            ),
          ),
        ),
      ),
    );
  }
}
