import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/elevator_resume_controller.dart';

class OtherUrlsSection extends StatelessWidget {
  const OtherUrlsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ElevatorResumeController>();

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
            controller.otherUrlsList.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Other URL',
                        hintText: 'Enter Here',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        controller.otherUrlsList[index] = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => controller.removeOtherUrl(index),
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Remove',
                  ),
                ],
              ),
            ),
          ),
          TextButton.icon(
            onPressed: controller.addOtherUrl,
            icon: const Icon(Icons.add),
            label: const Text('Add More'),
          ),
        ],
      );
    });
  }
}
