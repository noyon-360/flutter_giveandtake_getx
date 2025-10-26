import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../core/theme/app_colors.dart';

class HomeMainCard extends StatelessWidget {
  final String? iconPath;
  final String title;
  final String? subtitle;
  final bool isHtml;
  final VoidCallback? onTap;
  const HomeMainCard({
    super.key,
    this.iconPath,
    required this.title,
    this.subtitle,
    this.isHtml = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Color(0xffD3D3D3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath ?? "", height: 76, width: 86),
          const SizedBox(height: 22),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              color: AppColors.textBlack,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 21),
          if (isHtml && subtitle != null)
            Html(
              data: subtitle,
              style: {
                "body": Style(
                  fontSize: FontSize(15),
                  color: Color(0xff707070),
                  fontWeight: FontWeight.w400,
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  textAlign: TextAlign.center,
                ),
                "li": Style(
                  fontSize: FontSize(14),
                  color: Color(0xff707070),
                  fontWeight: FontWeight.w400,
                ),
                "ol": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.only(left: 20),
                ),
                "ul": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.only(left: 20),
                ),
              },
            )
          else
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
    );
  }
}
