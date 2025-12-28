import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/elevator_resume_controller.dart';

class ExperienceFormSection extends StatelessWidget {
  final int index;

  const ExperienceFormSection({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<ElevatorResumeController>();

    InputDecoration _inputDecoration(String label, String hint) =>
        InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Color(0xFF2563EB)),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        );

    return Obx(() {
      final exp = controller.experienceList[index];
      final bool currentlyWorking = exp['presentlyWorkHere'] ?? false;
      final String? selectedCountry = exp['country'];
      final String? selectedCity = exp['city'];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job Title
          TextFormField(
            decoration:
            _inputDecoration('Job Title', 'e.g. Software Engineer'),
            onChanged: (v) => exp['jobTitle'] = v,
          ),
          const SizedBox(height: 12),

          // Company Name
          TextFormField(
            decoration: _inputDecoration('Company Name', 'e.g. IBM'),
            onChanged: (v) => exp['companyName'] = v,
          ),
          const SizedBox(height: 12),

          // Country
          const Text('Country'),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: selectedCountry,
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Color(0xFF2563EB)),
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
              exp['country'] = value;
              exp['city'] = null; // country change -> city reset
              controller.experienceList.refresh();
            },
          ),
          const SizedBox(height: 12),

          // City
          const Text('City'),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            isExpanded: true,
            value: selectedCountry == null ? null : selectedCity,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Color(0xFF2563EB)),
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            hint: Text(
              selectedCountry == null ? 'Select country first' : 'Select City',
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                selectedCountry == null ? Colors.grey : Colors.grey[700],
              ),
            ),
            items: controller.cities
                .map(
                  (city) => DropdownMenuItem(
                value: city,
                child: Text(city),
              ),
            )
                .toList(),
            onChanged: selectedCountry == null
                ? null
                : (value) {
              exp['city'] = value;
              controller.experienceList.refresh();
            },
          ),
          const SizedBox(height: 8),

          // Currently Working
          Row(
            children: [
              Checkbox(
                value: currentlyWorking,
                onChanged: (_) => controller.togglePresentlyWorkHere(index),
              ),
              const SizedBox(width: 4),
              const Text('Currently Working'),
            ],
          ),
          const SizedBox(height: 8),

          // Start Date
          TextFormField(
            decoration: _inputDecoration('Start Date', 'MM/YYYY'),
            keyboardType: TextInputType.datetime,
            onChanged: (v) => exp['startDate'] = v,
          ),
          const SizedBox(height: 12),

          // End Date (disabled if currently working)
          TextFormField(
            decoration: _inputDecoration('End Date', 'MM/YYYY'),
            keyboardType: TextInputType.datetime,
            enabled: !currentlyWorking,
            onChanged: (v) => exp['endDate'] = v,
          ),
          const SizedBox(height: 12),

          // Job Description
          Text(
            'Job Description',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),
          TextFormField(
            maxLines: 4,
            minLines: 4,
            decoration: InputDecoration(
              hintText:
              'Describe your responsibilities and achievements',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Color(0xFF2563EB)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            onChanged: (v) => exp['description'] = v,
          ),
          const SizedBox(height: 12),

          // Remove Experience
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFE11D48),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () => controller.removeExperience(index),
              child: const Text('Remove Experience'),
            ),
          ),
        ],
      );
    });
  }
}
