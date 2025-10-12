import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/elevator_resume_controller.dart';

class ExperienceFormSection extends StatelessWidget {
  final int index;
  const ExperienceFormSection({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ElevatorResumeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index == 0) ...[
          const Text(
            'Experience',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Highlight your work journey and key achievements.'),
          const SizedBox(height: 16),
        ],
        if (index > 0) ...[Divider(thickness: 2), const SizedBox(height: 16)],
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Employer*',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Job Title*'),
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: controller.selectedJobTitle.value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Select Job Title'),
                      items: controller.jobTitles
                          .map(
                            (title) => DropdownMenuItem(
                              value: title,
                              child: Text(title),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        controller.selectedJobTitle.value = value;
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Start Date*'),
        Row(
          children: [
            Expanded(
              child: Obx(() {
                return DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: controller.selectedStartMonth.value,
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
                    controller.selectedStartMonth.value = value;
                  },
                );
              }),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(() {
                return DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: controller.selectedStartYear.value,
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
                    controller.selectedStartYear.value = value;
                  },
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('End Date*'),
        Row(
          children: [
            Expanded(
              child: Obx(() {
                return DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: controller.selectedEndMonth.value,
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
                    controller.selectedEndMonth.value = value;
                  },
                );
              }),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(() {
                return DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: controller.selectedEndYear.value,
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
                    controller.selectedEndYear.value = value;
                  },
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Country*'),
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: controller.selectedCountry.value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Select Country'),
                      items: controller.countries
                          .map(
                            (country) => DropdownMenuItem(
                              value: country,
                              child: Text(country),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        controller.selectedCountry.value = value;
                      },
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('City*'),
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: controller.selectedCity.value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Select City'),
                      items: controller.cities
                          .map(
                            (city) => DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        controller.selectedCity.value = value;
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Availability to Start*'),
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: controller.selectedAvailability.value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Select'),
                      items: controller.availabilities
                          .map(
                            (availability) => DropdownMenuItem(
                              value: availability,
                              child: Text(availability),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        controller.selectedAvailability.value = value;
                      },
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Job Categories*'),
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: controller.selectedJobCategory.value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Select'),
                      items: controller.jobCategories
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        controller.selectedJobCategory.value = value;
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          final isChecked =
              controller.experienceList[index]['presentlyWorkHere'] ?? false;
          return Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: (value) {
                  controller.togglePresentlyWorkHere(index);
                },
              ),
              const Text('I presently work here'),
            ],
          );
        }),
        const SizedBox(height: 16),
        const Text('Job Description'),
        const SizedBox(height: 8),
        const TextField(
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Write Here',
            border: OutlineInputBorder(),
          ),
        ),
        if (index > 0) ...[
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => controller.removeExperience(index),
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ],
    );
  }
}
