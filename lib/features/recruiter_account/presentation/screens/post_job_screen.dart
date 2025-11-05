import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../controller/job_posting _controller.dart';
import '../widgets/job_description_step.dart';
import '../widgets/job_details_step.dart';
import '../widgets/job_stepper.dart';

class CreateJobScreen extends StatelessWidget {
  const CreateJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JobPostingController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Job Posting',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const JobStepper(),
          const Divider(thickness: 1, color: Colors.grey),

          // ✅ Expanded makes scrollable content fill the remaining space
          Expanded(
            child: Obx(() {
              Widget stepWidget;
              switch (controller.currentStep.value) {
                case 1:
                  stepWidget =  JobDetailsStep();
                  break;
                case 2:
                  stepWidget = const JobDescriptionStep();
                  break;
              // case 3:
              //   stepWidget = const ApplicationRequirementsStep();
              //   break;
              // case 4:
              //   stepWidget = const CustomQuestionsStep();
              //   break;
              // case 5:
              //   stepWidget = const FinishStep();
              //   break;
                default:
                  stepWidget = const SizedBox.shrink();
              }

              // ✅ Wrap the step widget in a scroll view
              return SingleChildScrollView(
                ///padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: stepWidget,
              );
            }),
          ),
        ],
      ),
    );
  }
}
