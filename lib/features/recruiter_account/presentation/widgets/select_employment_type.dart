import 'package:flutter/material.dart';

import '../../../../core/theme/input_decoration_extensions.dart';
import '../controller/job_controller/employment_type_controller.dart';

class SelectEmploymentType extends StatelessWidget {
  const SelectEmploymentType({
    super.key,
    required this.employeeController,
  });

  final EmploymentTypeController employeeController;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: employeeController.selectedEmploymentType.value.isEmpty
          ? null
          : employeeController.selectedEmploymentType.value,
      decoration: context.primaryInputDecoration.copyWith(
        hintText: 'Select employment type',
        hintStyle: const TextStyle(
          color: Color(0xFF787878),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      items: employeeController.employmentTypes
          .map(
            (type) => DropdownMenuItem<String>(
          value: type,
          child: Text(
            type,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      )
          .toList(),
      onChanged: (value) {
        employeeController.selectedEmploymentType.value = value ?? '';
      },
    );
  }
}