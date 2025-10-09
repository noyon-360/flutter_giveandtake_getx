import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';

class AwardsWidget extends StatelessWidget {
  const AwardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final awardsList = [
      {
        "image": "assets/icons/award_icon.png",
        "title": "Best Design Awards",
        "event": "DesignCon 2023 | March 2023",
        "description":
            "Awarded for creating an innovative, user-friendly mobile app interface",
        "location": "Willshire Glen, GA",
      },
      {
        "image": "assets/icons/award_icon.png",
        "title": "Best Design Awards",
        "event": "DesignCon 2023 | March 2023",
        "description":
            "Awarded for creating an innovative, user-friendly mobile app interface",
        "location": "Willshire Glen, GA",
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Awards & Honours",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Column(
            children: awardsList
                .map(
                  (myAward) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Award icon
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(myAward["image"]!),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                myAward["title"]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                myAward["event"]!,
                                style: const TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                myAward["description"]!,
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
                              myAward["location"]!,
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
