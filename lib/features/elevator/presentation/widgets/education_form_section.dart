import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/elevator_resume_controller.dart';
import 'package:intl/intl.dart';

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
          _buildTextField(
            hint: 'Type your University/College/High School',
            onChanged: (val) => controller.updateEducationField(index, 'institution', val),
            // Need to ensure controller has this method or similar 
          ),

          const SizedBox(height: 16),
          _buildLabel('Qualification'),
           const SizedBox(height: 8),
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: controller.educationList[index]['degree'],
                hint: const Text('Select a qualification', style: TextStyle(color: Colors.grey)),
                items: controller.degrees.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (val) => controller.updateEducationField(index, 'degree', val),
              ),
            ),
          )),

          const SizedBox(height: 16),
          _buildLabel('Field Of Study'),
          const SizedBox(height: 8),
          _buildTextField(
            hint: 'e.g. Computer Science/Medicine/Civil Engineering',
            onChanged: (val) => controller.updateEducationField(index, 'fieldOfStudy', val),
          ),

          const SizedBox(height: 16),
          _buildLabel('Country'),
           const SizedBox(height: 8),
          Obx(() => Container(
             padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: controller.educationList[index]['country'],
                hint: const Text('Select Country'),
                items: controller.countries.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (val) => controller.updateEducationField(index, 'country', val),
              ),
            ),
          )),

          const SizedBox(height: 16),
          _buildLabel('City'),
           const SizedBox(height: 8),
          Obx(() => Container(
             padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: controller.educationList[index]['city'],
                 hint: const Text('Select country first'), // Logic should update hint if country selected?
                 // For now static hint is okay as per design
                items: controller.cities.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (val) => controller.updateEducationField(index, 'city', val),
              ),
            ),
          )),

          const SizedBox(height: 16),
          Obx(() {
            final isChecked = controller.educationList[index]['presentlyAttendHere'] == true;
            return Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: isChecked,
                    onChanged: (val) => controller.updateEducationField(index, 'presentlyAttendHere', val),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Currently Studying', style: TextStyle(fontSize: 14)),
              ],
            );
          }),

          const SizedBox(height: 16),
           _buildLabel('Start Date'),
          const SizedBox(height: 8),
           _buildTextField(
            hint: 'MM/YYYY',
            onChanged: (val) => controller.updateEducationField(index, 'startDate', val),
          ),

          const SizedBox(height: 16),
           _buildLabel('Graduation Date'),
          const SizedBox(height: 8),
           _buildTextField(
            hint: 'MM/YYYY',
            onChanged: (val) => controller.updateEducationField(index, 'graduationDate', val),
          ),
          
          if (index > 0) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                 onPressed: () => controller.removeEducation(index),
                child: const Text('Remove', style: TextStyle(color: Colors.red)),
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

  Widget _buildTextField({required String hint, required Function(String) onChanged}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
}
