import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/job_posting_controller.dart';

class CustomQuestionsStep extends StatelessWidget {
  const CustomQuestionsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobPostingController>();

    // Reactive list of questions
    final RxList<TextEditingController> questionControllers = <TextEditingController>[].obs;

    // initialize with 3 blank controllers if empty
    if (questionControllers.isEmpty) {
      questionControllers.addAll([
        TextEditingController(),
      ]);
    }

    void addQuestion() {
      questionControllers.add(TextEditingController());
    }

    void removeQuestion(int index) {
      if (questionControllers.length > 1) {
        questionControllers.removeAt(index);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Add Custom Questions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            TextButton(
              onPressed: controller.nextStep,
              child: Container(width: 60, height: 27, decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Color(0xFF2B7FD0)
                )
              ), child: Center(child: const Text("Skip", style: TextStyle(color: Color(0xFF2B7FD0), fontWeight: FontWeight.bold, fontSize: 15),))),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // List of dynamic question fields
        Obx(() => Column(
          children: List.generate(questionControllers.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ask a question",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2B7FD0),
                      fontSize: 18
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: questionControllers[index],
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
              ),
            );
          }),
        )),

        // Add question button
        TextButton.icon(
          onPressed: addQuestion,
          icon: Container(
            decoration: BoxDecoration(
              color: Color(0xFF2B7FD0),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
          label: const Text(
            "Add a question",
            style: TextStyle(color: Color(0xFF2B7FD0), fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF2B7FD0)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(),
                  child: Text(
                    'Cancle',
                    style: TextStyle(
                      color: Color(0xFF2B7FD0),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(width: 20),

            Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(color: Color(0xFF2B7FD0), borderRadius: BorderRadius.circular(8)),
              child: ElevatedButton(
                onPressed: () {controller.nextStep();},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                ),
                child: Text('Next', style: TextStyle(
                  color: Colors.white,fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),),
              ),
            ),
          ],
        ),
        SizedBox(height: 50)
      ],
    );
  }
}
