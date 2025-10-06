import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_logo.dart';
import 'package:karlfive/core/common/widgets/form_error_message.dart';
import 'package:karlfive/features/auth/data/models/security_questions_request_model.dart';
import 'package:karlfive/features/auth/presentation/controller/auth_controller.dart';

import '../../../../core/common/constants/app_images.dart';
import '../../../../core/theme/app_colors.dart';

class SecurityQuestionsScreen extends StatefulWidget {
  const SecurityQuestionsScreen({super.key, required this.email});

  final String email;

  @override
  State<SecurityQuestionsScreen> createState() =>
      _SecurityQuestionsScreenState();
}

class _SecurityQuestionsScreenState extends State<SecurityQuestionsScreen> {
  final _authController = Get.find<AuthController>();

  List<Map<String, String>> questions = [];
  bool _isLoadingQuestions = true;

  @override
  void initState() {
    super.initState();
    // Reset controller loading state when entering this screen
    _authController.setLoading(false);
    _authController.setError('');
    _loadSecurityQuestions();
  }

  Future<void> _loadSecurityQuestions() async {
    setState(() {
      _isLoadingQuestions = true;
    });

    await _authController.getDefaultSecurityQuestions();

    // Check if we got questions successfully
    if (_authController.securityQuestions.isEmpty &&
        _authController.errorMessage.value.isNotEmpty) {
      // API failed, show error and stop loading
      setState(() {
        _isLoadingQuestions = false;
      });
      return;
    }

    setState(() {
      questions = _authController.securityQuestions
          .map((q) => {'question': q.toString(), 'answer': ''})
          .toList();
      _isLoadingQuestions = false;
    });
  }

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
        child: _isLoadingQuestions
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primaryBlue),
                    SizedBox(height: 16),
                    Text(
                      'Loading security questions...',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const SizedBox(height: 12),
                    const Text(
                      "Set Up Your Security Questions",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Add extra protection to your account by answering at least 3 security questions.",
                      style: TextStyle(fontSize: 14, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 24),
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
                                onChanged: (val) =>
                                    _onAnswerChanged(val, index),
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
                    Obx(() {
                      final error = _authController.errorMessage.value;
                      if (error.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: FormErrorMessage(message: error),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
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
                        Obx(
                          () => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: answeredCount >= 3
                                  ? AppColors.primaryBlue
                                  : AppColors.textGrey,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            onPressed:
                                answeredCount >= 3 &&
                                    !_authController.isLoading.value
                                ? _showConfirmationDialog
                                : null,
                            child: _authController.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Next",
                                    style: TextStyle(color: Colors.white),
                                  ),
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

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Confirm Security Questions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You have answered $answeredCount security question${answeredCount > 1 ? 's' : ''}. Do you want to proceed?',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text(
                'Note: These questions will be used to verify your identity if you forget your password.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textGrey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _submitSecurityAnswers();
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _submitSecurityAnswers() {
    final answeredQuestions = questions
        .where((q) => q['answer']!.trim().isNotEmpty)
        .map(
          (q) => SecurityQuestionAnswer(
            question: q['question']!,
            answer: q['answer']!,
          ),
        )
        .toList();

    if (answeredQuestions.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer at least 3 security questions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _authController.submitSecurityAnswers(
      email: widget.email,
      questions: answeredQuestions,
      isRegistration: true,
    );
  }
}
