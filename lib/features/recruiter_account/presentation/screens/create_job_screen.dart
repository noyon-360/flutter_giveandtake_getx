import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../controller/job_posting_controller.dart';
import '../widgets/application_requirement_step.dart';
import '../widgets/custom_questions_step.dart';
import '../widgets/finish_step.dart';
import '../widgets/job_description_step.dart';
import '../widgets/job_details_step.dart';
import '../widgets/job_stepper.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  late final JobPostingController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(JobPostingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Job Posting',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2B7FD0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const JobStepper(),
          const Divider(thickness: 1, color: Colors.grey),

          Expanded(
            child: Obx(() {
              Widget stepWidget;
              switch (controller.currentStep.value) {
                case 1:
                  stepWidget = const JobDetailsStep();
                  break;
                case 2:
                  stepWidget = const JobDescriptionStep();
                  break;
                case 3:
                  stepWidget = const ApplicationRequirementStep();
                  break;
                case 4:
                  stepWidget = const CustomQuestionsStep();
                  break;
                case 5:
                  stepWidget = const FinishStep();
                  break;
                default:
                  stepWidget = const SizedBox.shrink();
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 20,left: 16, right: 16),
                      child: Container(
                        color: Color(0xFFE6E6FA).withOpacity(.3),
                        width: double.infinity,
                        child: stepWidget,
                      ),
                    ),

                    SizedBox()
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
