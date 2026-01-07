import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/job_posting_controller.dart';

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
        height: 100, // enough height for text under circles
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: List.generate(steps.length, (index) {
                final stepNumber = index + 1;
                final isCompleted = controller.currentStep.value > stepNumber;
                final isActive = controller.currentStep.value == stepNumber;

                Color circleColor;
                Color textColor;
                FontWeight fontWeight;

                if (isActive || isCompleted) {
                  circleColor = Color(0xFF2B7FD0);
                  textColor = Color(0xFF2B7FD0);
                  fontWeight = FontWeight.w600;
                } else {
                  circleColor = Colors.grey.shade300;
                  textColor = Colors.grey.shade600;
                  fontWeight = FontWeight.normal;
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () =>
                            controller.currentStep.value = stepNumber,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: circleColor,
                              child: Text(
                                '$stepNumber',
                                style: TextStyle(
                                  color: isActive || isCompleted
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
                                color: textColor,
                                fontWeight: fontWeight,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index < steps.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Container(
                          width: 40,
                          height: 2,
                          color: isCompleted || isActive
                              ? Color(0xFF2B7FD0)
                              : Colors.grey.shade600,
                        ),
                      ),
                    const SizedBox(width: 18),
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
