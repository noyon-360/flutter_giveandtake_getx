import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/job_posing _controller.dart';


class JobStepper extends StatelessWidget {
  const JobStepper({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobPostingController>();
    final steps = [
      'Job Details',
      'Job Description',
      'Application Requirements',
      'Custom Questions',
      'Finish',
    ];

    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(steps.length, (index) {
        final stepNumber = index + 1;
        final isActive = controller.currentStep.value == stepNumber;
        return Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor:
              isActive ? Colors.blue : Colors.grey.shade300,
              child: Text(
                '$stepNumber',
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              steps[index],
              style: TextStyle(
                color: isActive ? Colors.blue : Colors.grey,
                fontWeight:
                isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (index < steps.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: 30,
                  height: 2,
                  color: Colors.grey.shade300,
                ),
              ),
          ],
        );
      }),
    ));
  }
}
