import 'package:flutter/material.dart';

class SkillsWidget extends StatelessWidget {
  //! <--- Need to add dynamically (API) --->
  final List<String> skills = const [
    "Agile",
    "Wireframe",
    "Prototyping",
    "Waterfall Model",
    "Web Design",
  ];

  const SkillsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Skills",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: skills
                .map(
                  (skill) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      skill,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
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
