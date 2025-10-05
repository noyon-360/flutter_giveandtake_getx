import 'package:flutter/material.dart';
import 'package:karlfive/core/common/widgets/app_logo.dart';

import '../../../../core/common/constants/app_images.dart';
import '../../../../core/theme/app_colors.dart';

class SecurityQuestionsScreen extends StatefulWidget {
  const SecurityQuestionsScreen({super.key});

  @override
  State<SecurityQuestionsScreen> createState() =>
      _SecurityQuestionsScreenState();
}

class _SecurityQuestionsScreenState extends State<SecurityQuestionsScreen> {
  final List<Map<String, String>> questions = [
    {'question': 'Where did you go for your first holiday?', 'answer': ''},
    {
      'question': 'What was the first name of your childhood best friend?',
      'answer': '',
    },
    {'question': 'Who was your favourite teacher?', 'answer': ''},
    {'question': 'What is your favourite meal?', 'answer': ''},
    {'question': 'What is your favourite flavour of ice-cream?', 'answer': ''},
    {
      'question': 'What was your favourite subject in high school?',
      'answer': '',
    },
    {
      'question': 'What was your favourite relation’s first name?',
      'answer': '',
    },
    {'question': 'What was your favourite TV Show growing up?', 'answer': ''},
  ];

  int get answeredCount =>
      questions.where((q) => q['answer']!.trim().isNotEmpty).length;

  void _onAnswerChanged(String value, int index) {
    setState(() {
      questions[index]['answer'] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* <--- Logo --->
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 160,
                    width: 160,
                    child: AppLogo(images: AppImages.appLogoBlue),
                  ),
                ],
              ),

              // const SizedBox(height: 12),
              const Text(
                "Set Up Your 3 Security Questions",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Add extra protection to your account by choosing 3 security questions only you can answer.",
                style: TextStyle(fontSize: 14, color: AppColors.textGrey),
              ),
              const SizedBox(height: 24),

              //* <--- Questions --->
              ListView.builder(
                itemCount: questions.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question['question']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          initialValue: question['answer'],
                          onChanged: (val) => _onAnswerChanged(val, index),
                          decoration: InputDecoration(
                            hintText: "Write Here",
                            hintStyle: const TextStyle(
                              color: AppColors.textGrey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: AppColors.primaryBlue),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: answeredCount >= 3
                          ? AppColors.primaryBlue
                          : AppColors.textGrey,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: answeredCount >= 3
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Proceeding to next page..."),
                              ),
                            );
                            // TODO: Navigate to next screen here
                          }
                        : null,
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
