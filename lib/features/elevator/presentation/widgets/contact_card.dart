import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column - Profile
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile image placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "John D.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Text(
                "Product Designer",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 10),
              // Social icons
              Row(
                children: const [
                  Icon(
                    FontAwesomeIcons.twitter,
                    size: 16,
                    color: Colors.lightBlue,
                  ),
                  SizedBox(width: 10),
                  Icon(
                    FontAwesomeIcons.linkedin,
                    size: 16,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(width: 10),
                  Icon(FontAwesomeIcons.behance, size: 16, color: Colors.blue),
                  SizedBox(width: 10),
                  Icon(FontAwesomeIcons.tiktok, size: 16, color: Colors.black),
                  SizedBox(width: 10),
                  Icon(FontAwesomeIcons.youtube, size: 16, color: Colors.red),
                ],
              ),
            ],
          ),

          const SizedBox(width: 40),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Contact Info",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                  color: AppColors.textGrey,
                ),

                _infoRow(
                  "Location",
                  "New York, USA",
                  "Email",
                  "youremail@gmail.com",
                ),
                const SizedBox(height: 12),
                _infoRow(
                  "Phone",
                  "+999 454 433",
                  "Website Link",
                  "yourwebsite.com",
                ),
                const SizedBox(height: 12),
                _infoRow("Availability to start", "+999 454 433", "", ""),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    String leftTitle,
    String leftValue,
    String rightTitle,
    String rightValue,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leftTitle,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(leftValue, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        // Right side
        if (rightTitle.isNotEmpty)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rightTitle,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(rightValue, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
      ],
    );
  }
}
