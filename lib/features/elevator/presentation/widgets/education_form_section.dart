import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/elevator_resume_controller.dart';
import '../screens/elevator_resume_screen.dart';

class EducationFormSection extends StatelessWidget {
  final int index;
  const EducationFormSection({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ElevatorResumeController>();

    // Helper to access the specific education map from the list
    // keys: institution, city, state, degree, fieldOfStudy, gradMonth, gradYear, presentlyAttendHere, startDate?
    // The screenshot introduces: Qualification (degree), Country, Start Date, Graduation Date (MM/YYYY)

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Institution Name*'),
          const SizedBox(height: 8),
          Obx(
            () {
              // Get all universities from all countries for searching
              final allUniversities = <String>[];
              for (var universities in controller.universitiesByCountry.values) {
                allUniversities.addAll(universities);
              }
              allUniversities.sort();

              return SearchableDropdown(
                hint: 'Select University/College/High School',
                items: allUniversities,
                value: controller.educationList[index]['institution'],
                onChanged: (val) =>
                    controller.updateEducationField(index, 'institution', val),
              );
            },
          ),

          const SizedBox(height: 16),
          _buildLabel('Qualification'),
          const SizedBox(height: 8),
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller.educationList[index]['degree'],
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
                  onChanged: (val) =>
                      controller.updateEducationField(index, 'degree', val),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          _buildLabel('Field Of Study'),
          const SizedBox(height: 8),
          _buildTextField(
            hint: 'e.g. Computer Science/Medicine/Civil Engineering',
            onChanged: (val) =>
                controller.updateEducationField(index, 'fieldOfStudy', val),
          ),

          const SizedBox(height: 16),
          _buildLabel('Country'),
          const SizedBox(height: 8),
          Obx(
            () => SearchableDropdown(
              hint: 'Select Country',
              items: controller.countries.toList(),
              value: controller.educationList[index]['country'],
              onChanged: (val) {
                controller.updateEducationField(index, 'country', val);
                controller.updateEducationField(index, 'city', null);
              },
            ),
          ),

          const SizedBox(height: 16),
          _buildLabel('City'),
          const SizedBox(height: 8),
          Obx(
            () => SearchableDropdown(
              hint: 'Select City',
              items: controller.cities.toList(),
              value: controller.educationList[index]['city'],
              onChanged: (val) {
                controller.updateEducationField(index, 'city', val);
              },
            ),
          ),

          const SizedBox(height: 16),
          Obx(() {
            final isChecked =
                controller.educationList[index]['presentlyAttendHere'] == true;
            return Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: isChecked,
                    onChanged: (val) => controller.updateEducationField(
                      index,
                      'presentlyAttendHere',
                      val,
                    ),
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
            );
          }),

          const SizedBox(height: 16),
          _buildLabel('Start Date'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _selectDate(context, index, 'startDate'),
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
                    controller.educationList[index]['startDate']
                                ?.toString()
                                .isEmpty ??
                            true
                        ? 'MM/YYYY'
                        : controller.educationList[index]['startDate'],
                    style: TextStyle(
                      color:
                          controller.educationList[index]['startDate']
                                  ?.toString()
                                  .isEmpty ??
                              true
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
          Obx(() {
            final isChecked =
                controller.educationList[index]['presentlyAttendHere'] == true;
            return GestureDetector(
              onTap: isChecked
                  ? null
                  : () => _selectDate(context, index, 'graduationDate'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isChecked
                        ? Colors.grey.shade200
                        : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: isChecked ? Colors.grey.shade50 : Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.educationList[index]['graduationDate']
                                  ?.toString()
                                  .isEmpty ??
                              true
                          ? 'MM/YYYY'
                          : controller.educationList[index]['graduationDate'],
                      style: TextStyle(
                        color: isChecked
                            ? Colors.grey.shade400
                            : (controller.educationList[index]['graduationDate']
                                          ?.toString()
                                          .isEmpty ??
                                      true
                                  ? Colors.grey
                                  : Colors.black),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: isChecked ? Colors.grey.shade300 : Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          }),

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
      ),
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
    required Function(String) onChanged,
  }) {
    return TextField(
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
    int index,
    String dateField,
  ) async {
    final controller = Get.find<ElevatorResumeController>();
    final edu = controller.educationList[index];
    
    DateTime? initialDate = DateTime.now();
    DateTime firstDate = DateTime(1990);
    DateTime lastDate = DateTime.now().add(const Duration(days: 365 * 10));

    // If selecting graduation date, ensure it's not before start date
    if (dateField == 'graduationDate' && edu['startDate'] != null) {
      try {
        final startDateStr = edu['startDate'] as String;
        final parts = startDateStr.split('-');
        if (parts.length == 3) {
          final startDate = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
          firstDate = startDate; // Graduation date must be >= start date
          initialDate = startDate;
        }
      } catch (e) {
        print('Error parsing start date: $e');
      }
    }

    // If selecting start date, ensure it's not after graduation date
    if (dateField == 'startDate' && edu['graduationDate'] != null) {
      try {
        final gradDateStr = edu['graduationDate'] as String;
        final parts = gradDateStr.split('-');
        if (parts.length == 3) {
          final gradDate = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
          lastDate = gradDate; // Start date must be <= graduation date
          initialDate = gradDate;
        }
      } catch (e) {
        print('Error parsing graduation date: $e');
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      // Validate: if setting graduation date, make sure it's not before start date
      if (dateField == 'graduationDate' && edu['startDate'] != null) {
        try {
          final startDateStr = edu['startDate'] as String;
          final parts = startDateStr.split('-');
          if (parts.length == 3) {
            final startDate = DateTime(
              int.parse(parts[0]),
              int.parse(parts[1]),
              int.parse(parts[2]),
            );
            if (picked.isBefore(startDate)) {
              Get.snackbar(
                'Invalid Date',
                'Graduation date cannot be before start date',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }
          }
        } catch (e) {
          print('Error validating graduation date: $e');
        }
      }

      // Validate: if setting start date, make sure it's not after graduation date
      if (dateField == 'startDate' && edu['graduationDate'] != null) {
        try {
          final gradDateStr = edu['graduationDate'] as String;
          final parts = gradDateStr.split('-');
          if (parts.length == 3) {
            final gradDate = DateTime(
              int.parse(parts[0]),
              int.parse(parts[1]),
              int.parse(parts[2]),
            );
            if (picked.isAfter(gradDate)) {
              Get.snackbar(
                'Invalid Date',
                'Start date cannot be after graduation date',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }
          }
        } catch (e) {
          print('Error validating start date: $e');
        }
      }

      // Format as YYYY-MM-DD (ISO 8601 date format required by API)
      final year = picked.year.toString();
      final month = picked.month.toString().padLeft(2, '0');
      final day = picked.day.toString().padLeft(2, '0');
      final formattedDate = '$year-$month-$day';

      controller.updateEducationField(
        index,
        dateField,
        formattedDate,
      );
    }
  }
}
