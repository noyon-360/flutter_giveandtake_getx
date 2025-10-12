import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/elevator_resume_controller.dart';

class EducationFormSection extends StatelessWidget {
  final int index;
  const EducationFormSection({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ElevatorResumeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index == 0) ...[
          const Text(
            'Education',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Showcase your academic background and qualifications.'),
          const SizedBox(height: 16),
        ],
        if (index > 0) ...[Divider(thickness: 2), const SizedBox(height: 16)],
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Institution Name*',
                  hintText: 'eg Havard',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'City*',
                  hintText: 'eg Berlin',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'State*',
                  hintText: 'Write here',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Degree*'),
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: controller.selectedDegree.value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Select a degree'),
                      items: controller.degrees
                          .map(
                            (degree) => DropdownMenuItem(
                              value: degree,
                              child: Text(degree),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        controller.selectedDegree.value = value;
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Field Of Study*',
            hintText: 'Write Here',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Graduation Date*'),
        Row(
          children: [
            Expanded(
              child: Obx(() {
                return DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: controller.selectedGradMonth.value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('Month'),
                  items: controller.months
                      .map(
                        (month) =>
                            DropdownMenuItem(value: month, child: Text(month)),
                      )
                      .toList(),
                  onChanged: (value) {
                    controller.selectedGradMonth.value = value;
                  },
                );
              }),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(() {
                return DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: controller.selectedGradYear.value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('Year'),
                  items: controller.years
                      .map(
                        (year) =>
                            DropdownMenuItem(value: year, child: Text(year)),
                      )
                      .toList(),
                  onChanged: (value) {
                    controller.selectedGradYear.value = value;
                  },
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          final isChecked =
              controller.educationList[index]['presentlyAttendHere'] ?? false;
          return Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: (value) {
                  controller.togglePresentlyAttendHere(index);
                },
              ),
              const Text('I presently attend here'),
            ],
          );
        }),
        if (index > 0) ...[
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => controller.removeEducation(index),
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ],
    );
  }
}
