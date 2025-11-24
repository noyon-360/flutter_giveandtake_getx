import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AppliedJobCard extends StatelessWidget {
  final String jobLogo;
  final String title;
  final String description;

  AppliedJobCard({
    required this.title,
    required this.description,
    required this.jobLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(image: AssetImage(jobLogo), height: 20, width: 20),
              SizedBox(width: 18),
              Text(title),
              Spacer(),
              Image(
                image: AssetImage("assets/images/applied_jobs_heart.png"),
                height: 20,
                width: 20,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.",
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  "View Job",
                  style: TextStyle(
                    color: AppColors.textBlack,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                //! <--- Need to change Dynamically --->
                "Applied",
                style: TextStyle(
                  color: AppColors.textGreen,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
