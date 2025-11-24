import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class EducationWidget extends StatelessWidget {
  const EducationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final educationList = [
      {
        "degree": "Masters in Art Design",
        "institution": "Harvard University",
        "duration": "Jun 2020 – April 2023 – 3 years",
        "location": "Willshire Glen, GA",
      },
      {
        "degree": "Masters in Art Design",
        "institution": "Harvard University",
        "duration": "Jun 2020 – April 2023 – 3 years",
        "location": "Willshire Glen, GA",
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Education",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Column(
            children: educationList
                .map(
                  (myEdu) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/icons/education_icon.png",
                              ),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                myEdu["degree"]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                myEdu["institution"]!,
                                style: const TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                myEdu["duration"]!,
                                style: const TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Location
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: AppColors.textGrey,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              myEdu["location"]!,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
