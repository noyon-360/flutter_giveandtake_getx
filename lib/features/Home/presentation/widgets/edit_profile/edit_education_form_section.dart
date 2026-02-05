import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/edit_candidate_profile_controller.dart';
import 'searchable_dropdown.dart';

class EditEducationFormSection extends StatelessWidget {
  final int index;

  const EditEducationFormSection({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditCandidateProfileController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Obx(() {
        // Access safely
        if (index >= controller.educationList.length) return const SizedBox();
        
        final edu = controller.educationList[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Institution Name*'),
            const SizedBox(height: 8),
            _buildTextField(
              hint: 'Type your University/College/High School',
              initialValue: edu['institution'],
              onChanged: (val) {
                edu['institution'] = val;
                // No refresh needed for text field unless other widgets depend on it
              },
            ),

            const SizedBox(height: 16),
            _buildLabel('Qualification'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller.degrees.contains(edu['degree']) 
                      ? edu['degree'] 
                      : null, // Ensure value exists in items
                  hint: const Text(
                    'Select a qualification',
                    style: TextStyle(color: Colors.grey),
                  ),
                  items: controller.degrees.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    edu['degree'] = val;
                    controller.educationList.refresh();
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),
            _buildLabel('Field Of Study'),
            const SizedBox(height: 8),
            _buildTextField(
              hint: 'e.g. Computer Science/Medicine/Civil Engineering',
              initialValue: edu['fieldOfStudy'],
              onChanged: (val) => edu['fieldOfStudy'] = val,
            ),

            const SizedBox(height: 16),
            _buildLabel('Country'),
            const SizedBox(height: 8),
            SearchableDropdown(
              hint: 'Select Country',
              items: controller.countries.toList(),
              value: edu['country'],
              onChanged: (val) {
                edu['country'] = val;
                edu['city'] = null;
                controller.educationList.refresh();
              },
            ),

            const SizedBox(height: 16),
            _buildLabel('City'),
            const SizedBox(height: 8),
            SearchableDropdown(
              hint: 'Select City',
              items: controller.cities.toList(),
              value: edu['city'],
              onChanged: (val) {
                edu['city'] = val;
                controller.educationList.refresh();
              },
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: edu['presentlyAttendHere'] == true,
                    onChanged: (val) {
                      edu['presentlyAttendHere'] = val;
                      controller.educationList.refresh();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Currently Studying',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 16),
            _buildLabel('Start Date'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectDate(context, edu, 'startDate'),
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
                      edu['startDate']?.toString().isEmpty ?? true
                          ? 'MM/YYYY'
                          : edu['startDate'],
                      style: TextStyle(
                        color: edu['startDate']?.toString().isEmpty ?? true
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

            const SizedBox(height: 16),
            _buildLabel('Graduation Date'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: (edu['presentlyAttendHere'] == true)
                  ? null
                  : () => _selectDate(context, edu, 'graduationDate'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: (edu['presentlyAttendHere'] == true)
                        ? Colors.grey.shade200
                        : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: (edu['presentlyAttendHere'] == true) 
                      ? Colors.grey.shade50 
                      : Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      edu['graduationDate']?.toString().isEmpty ?? true
                          ? 'MM/YYYY'
                          : edu['graduationDate'],
                      style: TextStyle(
                        color: (edu['presentlyAttendHere'] == true)
                            ? Colors.grey.shade400
                            : (edu['graduationDate']?.toString().isEmpty ?? true
                                ? Colors.grey
                                : Colors.black),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: (edu['presentlyAttendHere'] == true) 
                          ? Colors.grey.shade300 
                          : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),

            if (index > 0) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => controller.removeEducation(index),
                  child: const Text(
                    'Remove',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    String? initialValue,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      onChanged: onChanged,
    );
  }

  /// Date picker for YYYY-MM-DD format (API requirement)
  Future<void> _selectDate(
    BuildContext context,
    Map<String, dynamic> edu,
    String dateField,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );

    if (picked != null) {
      final year = picked.year.toString();
      final month = picked.month.toString().padLeft(2, '0');
      final day = picked.day.toString().padLeft(2, '0');
      final formattedDate = '$year-$month-$day';

      edu[dateField] = formattedDate;
      Get.find<EditCandidateProfileController>().educationList.refresh();
    }
  }
}
