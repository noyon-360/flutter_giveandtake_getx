import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/job_posting _controller.dart';


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

    return Obx(() {
      return SizedBox(
        height: 90, // enough height for text under circles
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: List.generate(steps.length, (index) {
                final stepNumber = index + 1;
                final isActive = controller.currentStep.value == stepNumber;

                return Row(
                  children: [
                    // Step Column (circle + text)
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () =>
                          controller.currentStep.value = stepNumber,
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: isActive
                                ? Color(0xFF2B7FD0)
                                : Colors.grey.shade300,
                            child: Text(
                              '$stepNumber',
                              style: TextStyle(
                                color: isActive
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 90, // consistent width for each label
                          child: Text(
                            steps[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isActive
                                  ? Color(0xFF2B7FD0)
                                  : Colors.grey.shade600,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (index < steps.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Container(
                          width: 40,
                          height: 2,
                          color: isActive
                              ? Color(0xFF2B7FD0)
                              : Colors.grey.shade600,
                        ),
                      ),

                    SizedBox(width: 18,)
                  ],
                );
              }),
            ),
          ),
        ),
      );
    });
  }
}
