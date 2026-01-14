import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/elevator_resume_controller.dart';

class AwardsFormSection extends StatelessWidget {
  final int index;
  const AwardsFormSection({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ElevatorResumeController>();

    return Obx(() {
      final award = controller.awardsList[index];
      final String? selectedDate = award['year'];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (index == 0) ...[
            const Text(
              'Awards & Honours',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
          ],
          if (index > 0) ...[Divider(thickness: 2), const SizedBox(height: 16)],
          TextField(
            decoration: const InputDecoration(
              labelText: 'Award Title*',
              hintText: 'Write here',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              award['title'] = value;
            },
            controller: TextEditingController(text: award['title'] ?? '')
              ..selection = TextSelection.collapsed(
                offset: (award['title'] ?? '').length,
              ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Program Name*',
                    hintText: 'Write here',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    award['programName'] = value;
                  },
                  controller:
                      TextEditingController(text: award['programName'] ?? '')
                        ..selection = TextSelection.collapsed(
                          offset: (award['programName'] ?? '').length,
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, award),
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Program Date*',
                        hintText: 'Select date',
                        suffixIcon: const Icon(Icons.calendar_today, size: 20),
                        border: const OutlineInputBorder(),
                      ),
                      controller: TextEditingController(
                        text: selectedDate ?? '',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Award Short Description*'),
          const SizedBox(height: 8),
          TextField(
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Write here',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              award['description'] = value;
            },
            controller: TextEditingController(text: award['description'] ?? '')
              ..selection = TextSelection.collapsed(
                offset: (award['description'] ?? '').length,
              ),
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
      // Format as YYYY-MM-DD (ISO 8601 date format required by API)
      final year = picked.year.toString();
      final month = picked.month.toString().padLeft(2, '0');
      final day = picked.day.toString().padLeft(2, '0');
      final formattedDate = '$year-$month-$day';

      award['year'] = formattedDate;
      Get.find<ElevatorResumeController>().awardsList.refresh();
    }
  }
}
