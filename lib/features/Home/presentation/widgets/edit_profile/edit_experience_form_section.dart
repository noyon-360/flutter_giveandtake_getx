import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/edit_candidate_profile_controller.dart';
import 'searchable_dropdown.dart';

class EditExperienceFormSection extends StatelessWidget {
  final int index;

  const EditExperienceFormSection({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<EditCandidateProfileController>();

    InputDecoration _inputDecoration(String label, String hint) =>
        InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
            initialValue: exp['jobTitle'],
            decoration: _inputDecoration('Job Title', 'e.g. Software Engineer'),
            onChanged: (v) => exp['jobTitle'] = v,
          ),
          const SizedBox(height: 12),

          // Company Name
          TextFormField(
             initialValue: exp['companyName'],
            decoration: _inputDecoration('Company Name', 'e.g. IBM'),
            onChanged: (v) => exp['companyName'] = v,
          ),
          const SizedBox(height: 12),

          // Country
          const Text('Country'),
          const SizedBox(height: 6),
          SearchableDropdown(
            hint: 'Select Country',
            items: controller.countries.toList(),
            value: selectedCountry,
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
          SearchableDropdown(
            hint: 'Select City',
            items: controller.cities.toList(),
            value: selectedCity,
            onChanged: (value) {
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
          const Text('Start Date'),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => _selectDate(context, exp, 'startDate'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    exp['startDate']?.toString().isEmpty ?? true
                        ? 'MM/YYYY'
                        : exp['startDate'],
                    style: TextStyle(
                      color: exp['startDate']?.toString().isEmpty ?? true
                          ? Colors.grey
                          : Colors.black,
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // End Date (disabled if currently working)
          const Text('End Date'),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: currentlyWorking
                ? null
                : () => _selectDate(context, exp, 'endDate'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: currentlyWorking
                      ? Colors.grey.shade200
                      : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(8),
                color: currentlyWorking ? Colors.grey.shade50 : Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    exp['endDate']?.toString().isEmpty ?? true
                        ? 'MM/YYYY'
                        : exp['endDate'],
                    style: TextStyle(
                      color: currentlyWorking
                          ? Colors.grey.shade400
                          : (exp['endDate']?.toString().isEmpty ?? true
                                ? Colors.grey
                                : Colors.black),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: currentlyWorking
                        ? Colors.grey.shade300
                        : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Job Description
          Text('Job Description', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 6),
          TextFormField(
             initialValue: exp['description'],
            maxLines: 4,
            minLines: 4,
            decoration: InputDecoration(
              hintText: 'Describe your responsibilities and achievements',
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

  /// Date picker for YYYY-MM-DD format (API requirement)
  Future<void> _selectDate(
    BuildContext context,
    Map<String, dynamic> exp,
    String dateField,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );

    if (picked != null) {
      // Format as YYYY-MM-DD (ISO 8601 date format required by API)
      final year = picked.year.toString();
      final month = picked.month.toString().padLeft(2, '0');
      final day = picked.day.toString().padLeft(2, '0');
      final formattedDate = '$year-$month-$day';

      exp[dateField] = formattedDate;
      Get.find<EditCandidateProfileController>().experienceList.refresh();
    }
  }
}
