import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SearchFilterIconCard extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;
  const SearchFilterIconCard({super.key, required this.iconPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
          iconPath,
          color: AppColors.primaryWhite,
          width: 20,
          height: 20,
        ),
      ),
    );
  }
}
