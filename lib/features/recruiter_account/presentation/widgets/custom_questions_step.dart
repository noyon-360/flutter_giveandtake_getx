import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/job_posting_controller.dart';

class CustomQuestionsStep extends StatelessWidget {
  const CustomQuestionsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobPostingController>();

    // Reactive list of extra question controllers (after the first one)
    final RxList<TextEditingController> extraQuestionControllers = <TextEditingController>[].obs;

    // First question controller (always present)
    final TextEditingController firstQuestionController = TextEditingController(
        text: controller.customQuestion.isNotEmpty ? controller.customQuestion[0] : '');

    // Initialize extra questions if they exist
    if (extraQuestionControllers.isEmpty && controller.customQuestion.length > 1) {
      for (int i = 1; i < controller.customQuestion.length; i++) {
        extraQuestionControllers.add(TextEditingController(text: controller.customQuestion[i]));
      }
    }

    // Function to add a new extra question
    void addQuestion() {
      extraQuestionControllers.add(TextEditingController());
    }

    return Obx(() => Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Custom Questions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // First mandatory question
          _buildQuestionField(firstQuestionController, "Ask a question"),

          // Extra questions
          Column(
            children: List.generate(extraQuestionControllers.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildQuestionField(
                    extraQuestionControllers[index], "Ask a question"),
              );
            }),
          ),

          const SizedBox(height: 16),

          // Add question button
          TextButton.icon(
            onPressed: addQuestion,
            icon: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2B7FD0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
            label: const Text(
              "Add a question",
              style: TextStyle(
                color: Color(0xFF2B7FD0),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Cancel button
              SizedBox(
                height: 50,
                width: 120,
                child: OutlinedButton(
                  onPressed: () {
                    // Store all questions in controller
                    controller.customQuestion.value = [
                      firstQuestionController.text.trim(),
                      ...extraQuestionControllers
                          .map((c) => c.text.trim())
                          .where((q) => q.isNotEmpty)
                    ];
                    controller.nextStep();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2B7FD0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFF2B7FD0),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Next button
              SizedBox(
                height: 50,
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    // Store all questions in controller
                    controller.customQuestion.value = [
                      firstQuestionController.text.trim(),
                      ...extraQuestionControllers
                          .map((c) => c.text.trim())
                          .where((q) => q.isNotEmpty)
                    ];
                    controller.nextStep();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B7FD0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    ));
  }

  Widget _buildQuestionField(TextEditingController controller, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF2B7FD0),
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Write Here",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          maxLines: 2,
        ),
      ],
    );
  }
}
