import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExperienceWidget extends StatelessWidget {
  const ExperienceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final experienceList = [
      {
        "position": "Software Engineer",
        "company": "Betacom",
        "duration": "Jun 2020 – April 2023 – 3 years",
        "location": "Willshire Glen, GA",
      },
      {
        "position": "Software Engineer",
        "company": "Betacom",
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
            "Experience",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Column(
            children: experienceList
                .map(
                  (exp) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Company logo or icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0D6EFD),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            FontAwesomeIcons.briefcase,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Job details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exp["position"]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                exp["company"]!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                exp["duration"]!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Location (aligned right)
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.grey,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              exp["location"]!,
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
