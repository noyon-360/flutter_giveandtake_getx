import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "About",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 8),
          const Text(
            //! <--- Need to add dynamically (API) --->
            "A talented professional with an academic background in IT and proven commercial development experience as a C++ developer since 1999. "
            "Has a sound knowledge of the software development life cycle. "
            "Was involved in more than 140 software development outsourcing projects.",
            style: TextStyle(height: 1.5, fontSize: 12),
          ),
          const SizedBox(height: 16),
          const Text(
            "Programming Languages:",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          const SizedBox(height: 4),
          const Text(
            //! <--- Need to add dynamically (API) --->
            "C/C++, .NET C++, Python, Bash, Shell, PERL, Regular expressions, Python, Active-script.",
            style: TextStyle(color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
