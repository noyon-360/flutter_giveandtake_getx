// lib/features/elevator/presentation/widgets/skills_section.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/elevator_resume_controller.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  final TextEditingController _skillController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // Dummy master list – ichcha moto add korte paro
  final List<String> _allSkills = const [
    'Flutter',
    'Dart',
    'Java',
    'Kotlin',
    'Swift',
    'Objective-C',
    'JavaScript',
    'TypeScript',
    'React',
    'React Native',
    'Node.js',
    'Express',
    'PHP',
    'Laravel',
    'Python',
    'Django',
    'Flask',
    'C#',
    '.NET',
    'C++',
    'HTML',
    'CSS',
    'Tailwind',
    'Bootstrap',
    'SQL',
    'MySQL',
    'PostgreSQL',
    'MongoDB',
    'Firebase',
    'REST API',
    'GraphQL',
    'UI/UX Design',
    'Figma',
    'Git',
    'GitHub',
    'Jira',
  ];

  List<String> _filteredSkills = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _showSuggestions = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _skillController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged(String value, ElevatorResumeController controller) {
    final query = value.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredSkills = [];
        _showSuggestions = false;
      });
      return;
    }

    final selected = controller.skillsList;

    setState(() {
      _filteredSkills = _allSkills
          .where(
            (s) =>
        s.toLowerCase().contains(query) &&
            !selected.contains(s), // already selected hole dekhabo na
      )
          .take(8)
          .toList();
      _showSuggestions = _filteredSkills.isNotEmpty;
    });
  }

  void _addSkillFromInput(ElevatorResumeController controller, String value) {
    final text = value.trim();
    if (text.isEmpty) return;

    controller.addSkill(text);
    _skillController.clear();
    setState(() {
      _filteredSkills = [];
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<ElevatorResumeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // label "Skills*"
        Text(
          'Skills*',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),

        // search & add field
        TextField(
          controller: _skillController,
          focusNode: _focusNode,
          textInputAction: TextInputAction.done,
          onChanged: (value) => _onTextChanged(value, controller),
          onSubmitted: (value) => _addSkillFromInput(controller, value),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey[500],
            ),
            hintText: 'Search and add skills (e.g., Java, Python, React, JavaScript)',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2563EB)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),

        const SizedBox(height: 4),

        // suggestion list (textfield er niche)
        if (_showSuggestions && _filteredSkills.isNotEmpty)
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 200,
            ),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(8),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredSkills.length,
                itemBuilder: (context, index) {
                  final skill = _filteredSkills[index];
                  return ListTile(
                    dense: true,
                    title: Text(skill),
                    onTap: () {
                      controller.addSkill(skill);
                      _skillController.clear();
                      setState(() {
                        _filteredSkills = [];
                        _showSuggestions = false;
                      });
                    },
                  );
                },
              ),
            ),
          ),

        const SizedBox(height: 8),

        // chips / empty message
        Obx(
              () {
            if (controller.skillsList.isEmpty) {
              return Text(
                'No skills selected. Start typing to search and add skills.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              );
            }

            return Wrap(
              spacing: 8,
              runSpacing: 4,
              children: List.generate(
                controller.skillsList.length,
                    (index) {
                  final skill = controller.skillsList[index];
                  return Chip(
                    label: Text(skill),
                    shape: const StadiumBorder(),
                    backgroundColor: const Color(0xFFE5F0FF),
                    labelStyle: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.w500,
                    ),
                    deleteIcon: const Icon(
                      Icons.close,
                      size: 16,
                    ),
                    onDeleted: () => controller.removeSkill(index),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
