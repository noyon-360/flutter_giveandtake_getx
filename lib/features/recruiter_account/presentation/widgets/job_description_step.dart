import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/job_posting _controller.dart';

class JobDescriptionStep extends StatelessWidget {
  const JobDescriptionStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobPostingController>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Job Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            //controller: controller.jobDescriptionController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Describe the job role...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: controller.previousStep,
                  child: const Text('Previous')),
              ElevatedButton(
                  onPressed: controller.nextStep, child: const Text('Next')),
            ],
          ),
        ],
      ),
    );
  }
}
