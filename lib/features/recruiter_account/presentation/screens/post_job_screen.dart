import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/job_posing _controller.dart';
import '../widgets/job_description_step.dart';
import '../widgets/job_details_step.dart';
import '../widgets/job_stepper.dart';

class CreateJobPostingScreen extends StatelessWidget {
  const CreateJobPostingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JobPostingController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Job Posting'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const JobStepper(),
          const Divider(height: 32, thickness: 1),

          // Dynamic step content
          Expanded(
            child: Obx(() {
              switch (controller.currentStep.value) {
                case 1:
                  return const JobDetailsStep();
                case 2:
                  return const JobDescriptionStep();
                // case 3:
                //   return const ApplicationRequirementsStep();
                // case 4:
                //   return const CustomQuestionsStep();
                // case 5:
                //   return const FinishStep();
                default:
                  return const SizedBox.shrink();
              }
            }),
          ),
        ],
      ),
    );
  }
}
