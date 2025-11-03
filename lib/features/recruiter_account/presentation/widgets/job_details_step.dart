import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/job_posing _controller.dart';


class JobDetailsStep extends StatelessWidget {
  const JobDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobPostingController>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Job Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: controller.jobTitleController,
            decoration: const InputDecoration(
              labelText: 'Job Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 100),
              ElevatedButton(
                onPressed: controller.nextStep,
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
