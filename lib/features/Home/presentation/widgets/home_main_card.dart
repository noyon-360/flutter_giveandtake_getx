import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HomeMainCard extends StatelessWidget {
  final String? iconPath;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;
  const HomeMainCard({
    super.key,
    this.iconPath,
    this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Color(0xffD3D3D3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath ?? "", height: 76, width: 86),
            const SizedBox(height: 40),
            Text(
              title ?? "Create account",
              style: TextStyle(
                fontSize: 22,
                color: AppColors.textBlack,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 21),
            Text(
              subtitle ??
                  "Build your profile, upload your CV and get\naccess to thousands of jobs",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xff707070),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
