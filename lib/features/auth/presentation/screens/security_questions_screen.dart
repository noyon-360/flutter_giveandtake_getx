import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/common/widgets/app_logo.dart';
import 'package:giveandtake/core/common/widgets/form_error_message.dart';
import 'package:giveandtake/features/auth/data/models/security_questions_request_model.dart';
import 'package:giveandtake/features/auth/presentation/controller/auth_controller.dart';

import '../../../../core/common/constants/app_images.dart';
import '../../../../core/theme/app_buttoms.dart';
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

  // Use fixed 3 slots as per requirement
  final List<String?> _selectedQuestions = [null, null, null];
  final List<TextEditingController> _answerControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void initState() {
    super.initState();
    _authController.setLoading(false);
    _authController.setError('');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _authController.getDefaultSecurityQuestions();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  int get answeredCount {
    int count = 0;
    for (int i = 0; i < 3; i++) {
      if (_selectedQuestions[i] != null &&
          _answerControllers[i].text.trim().isNotEmpty) {
        count++;
      }
    }
    return count;
  }

  bool get isReadyToSubmit =>
      _selectedQuestions.every((q) => q != null) &&
      _answerControllers.every((c) => c.text.trim().isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<AuthController>(
          builder: (controller) {
            if (controller.isLoading.value &&
                controller.securityQuestions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primaryBlue),
                    const SizedBox(height: 16),
                    const Text(
                      'Loading security questions...',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: AppLogo(images: AppImages.appLogoBlue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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

                  if (controller.errorMessage.value.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: FormErrorMessage(
                        message: controller.errorMessage.value,
                      ),
                    ),

                  // Slot 1
                  _buildQuestionSlot(0, controller.securityQuestions),
                  const SizedBox(height: 20),
                  // Slot 2
                  _buildQuestionSlot(1, controller.securityQuestions),
                  const SizedBox(height: 20),
                  // Slot 3
                  _buildQuestionSlot(2, controller.securityQuestions),

                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          onPressed: () => Navigator.pop(context),
                          text: "Cancel",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          onPressed:
                              isReadyToSubmit && !controller.isLoading.value
                              ? _showConfirmationDialog
                              : null,
                          isLoading: controller.isLoading.value,
                          text: "Next",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuestionSlot(int index, List<dynamic> allQuestions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              value: _selectedQuestions[index],
              hint: const Text(
                "Select a security question",
                style: TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textGrey,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedQuestions[index] = newValue;
                });
              },
              items: allQuestions.map<DropdownMenuItem<String>>((
                dynamic question,
              ) {
                final questionStr = question.toString();
                // Check if this question is selected in OTHER slots
                bool isAlreadySelected = false;
                for (int i = 0; i < _selectedQuestions.length; i++) {
                  if (i != index && _selectedQuestions[i] == questionStr) {
                    isAlreadySelected = true;
                    break;
                  }
                }

                return DropdownMenuItem<String>(
                  value: questionStr,
                  enabled: !isAlreadySelected,
                  child: Text(
                    questionStr,
                    style: TextStyle(
                      color: isAlreadySelected
                          ? Colors.grey.shade400
                          : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        if (_selectedQuestions[index] != null) ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: _answerControllers[index],
            onChanged: (val) => setState(() {}),
            decoration: InputDecoration(
              hintText: "Write here (text only, max 50 characters)",
              hintStyle: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 14,
              ),
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
                borderSide: const BorderSide(color: AppColors.primaryBlue),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            maxLength: 50,
            buildCounter:
                (
                  context, {
                  required currentLength,
                  required isFocused,
                  maxLength,
                }) => null,
          ),
        ],
      ],
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
              const Text(
                'Are you sure you want to save these 3 security questions?',
                style: TextStyle(fontSize: 14),
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
    final List<SecurityQuestionAnswer> answeredQuestions = [];
    for (int i = 0; i < 3; i++) {
      answeredQuestions.add(
        SecurityQuestionAnswer(
          question: _selectedQuestions[i]!,
          answer: _answerControllers[i].text.trim(),
        ),
      );
    }

    _authController.submitSecurityAnswers(
      email: widget.email,
      questions: answeredQuestions,
      isRegistration: true,
    );
  }
}
