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

        // Access universitiesByCountry to make GetX track it
        final _ = controller.universitiesByCountry.values;

        // Get all universities from all countries for searching
        final allUniversities = <String>[];
        for (var universities in controller.universitiesByCountry.values) {
          allUniversities.addAll(universities);
        }
        allUniversities.sort();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Institution Name*'),
            const SizedBox(height: 8),
            SearchableDropdown(
              hint: 'Select University/College/High School',
              items: allUniversities,
              value: edu['institution'],
              onChanged: (val) {
                edu['institution'] = val;
                controller.educationList.refresh();
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
                      _formatDisplayDate(edu['startDate']),
                      style: TextStyle(
                        color: (_parseDate(edu['startDate'] as String?) == null)
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
                      _formatDisplayDate(edu['graduationDate']),
                      style: TextStyle(
                        color: (edu['presentlyAttendHere'] == true)
                            ? Colors.grey.shade400
                            : (_parseDate(edu['graduationDate'] as String?) == null
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
    final controller = Get.find<EditCandidateProfileController>();
    final startDateStr = edu['startDate'] as String?;
    final gradDateStr = edu['graduationDate'] as String?;

    DateTime? initialDate = DateTime.now();
    DateTime firstDate = DateTime(1990);
    DateTime lastDate = DateTime.now().add(const Duration(days: 365 * 10));

    // Parse existing dates
    final startDate = _parseDate(startDateStr);
    final gradDate = _parseDate(gradDateStr);

    // If selecting graduation date, ensure it can't be before start date
    if (dateField == 'graduationDate' && startDate != null) {
      firstDate = startDate;
      initialDate = gradDate ?? DateTime.now();
    } else if (dateField == 'startDate' && gradDate != null) {
      // If selecting start date when grad date exists, limit last date to grad date
      lastDate = gradDate;
      initialDate = startDate ?? DateTime.now();
    } else if (dateField == 'startDate') {
      initialDate = startDate ?? DateTime.now();
    } else if (dateField == 'graduationDate') {
      initialDate = gradDate ?? DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      final formattedDate = _formatDateToApi(picked);
      edu[dateField] = formattedDate;
      controller.educationList.refresh();
    }
  }

  /// Parse date string to DateTime
  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      // Try YYYY-MM-DD format first
      if (dateStr.contains('-')) {
        return DateTime.parse(dateStr);
      }
      // Fallback for other formats
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Format DateTime to MM/YYYY display format
  String _formatDateToDisplay(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Format DateTime to YYYY-MM-DD API format
  String _formatDateToApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Format date string for display (MM/YYYY)
  String _formatDisplayDate(dynamic dateValue) {
    if (dateValue == null || (dateValue is String && dateValue.isEmpty)) {
      return 'MM/YYYY';
    }
    try {
      final date = _parseDate(dateValue.toString());
      if (date != null) {
        return _formatDateToDisplay(date);
      }
      return dateValue.toString();
    } catch (e) {
      return 'MM/YYYY';
    }
  }
}
