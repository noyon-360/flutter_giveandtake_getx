import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/edit_candidate_profile_controller.dart';

class EditAwardsFormSection extends StatelessWidget {
  final int index;
  const EditAwardsFormSection({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditCandidateProfileController>();

    return Obx(() {
      if (index >= controller.awardsList.length) return const SizedBox();
      final award = controller.awardsList[index];
      final String? selectedDate = award['year'];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (index > 0) ...[const Divider(thickness: 2), const SizedBox(height: 16)],
          
          TextFormField(
            initialValue: award['title'],
            decoration: const InputDecoration(
              labelText: 'Award Title*',
              hintText: 'Enter award title',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              award['title'] = value;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: award['issuer'],
            decoration: const InputDecoration(
              labelText: 'Issuing Organization',
              hintText: 'Enter organization name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              award['issuer'] = value;
            },
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _selectDate(context, award),
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Award Date',
                  hintText: 'MM/YYYY',
                  suffixIcon: const Icon(Icons.calendar_today, size: 20),
                  border: const OutlineInputBorder(),
                ),
                controller: TextEditingController(
                  text: _formatDisplayDate(award['year']),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          const Text('Award Short Description*'),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: award['description'],
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Write here',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              award['description'] = value;
            },
          ),
          if (index > 0) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  controller.removeAward(index);
                },
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ],
      );
    });
  }

  /// Parse date string to DateTime
  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      if (dateStr.contains('-')) {
        return DateTime.parse(dateStr);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Format DateTime to MM/YYYY display format
  String _formatDateToDisplay(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Format date string for display
  String _formatDisplayDate(dynamic dateValue) {
    if (dateValue == null || (dateValue is String && dateValue.isEmpty)) {
      return 'Select date';
    }
    try {
      final date = _parseDate(dateValue.toString());
      if (date != null) {
        return _formatDateToDisplay(date);
      }
      return dateValue.toString();
    } catch (e) {
      return 'Select date';
    }
  }

  /// Date picker for YYYY-MM-DD format (API requirement)
  Future<void> _selectDate(
    BuildContext context,
    Map<String, dynamic> award,
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

      award['year'] = formattedDate;
      Get.find<EditCandidateProfileController>().awardsList.refresh();
    }
  }
}
