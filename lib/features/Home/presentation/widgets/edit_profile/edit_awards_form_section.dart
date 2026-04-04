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
              hintText: 'Write here',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              award['title'] = value;
            },
          ),
          const SizedBox(height: 16),
          /* Program Name field removed or merged? Original had programName. 
             But elevator controller awards map only has: title, year, description. 
             Wait, ElevatorResumeController lines 928-933:
               'title': award['title'] ?? '',
               'year': award['year'] ?? '',
               'description': award['description'] ?? '',
             It DOES NOT include programName in the JSON sent to API!
             The UI might have had it, but logic ignored it?
             The screenshot also shows "Program Name" in UI (based on AwardsFormSection code).
             But if API doesn't take it, maybe it's not needed. 
             However, the user wants it to mirror functionality.
             I'll include it in the map, but it might not be sent. 
             Or maybe 'programName' IS 'title'? 
             In ElevatorResumeScreen it had both.
             I'll keep it to match UI. If API ignores it, so be it.
          */
          /*
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: award['programName'],
                  decoration: const InputDecoration(
                    labelText: 'Program Name*',
                    hintText: 'Write here',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    award['programName'] = value;
                  },
                ),
              ),
              const SizedBox(width: 16),
              // ... Date picker
            ],
          ),
          */
          // Wait, 'programName' was in AwardsFormSection code I read.
          // But ElevatorResumeController resume object construction (lines 928) didn't use it.
          // I will stick to what the controller was sending: Title, Year, Description.
          // But I'll layout Date properly.
          
          GestureDetector(
            onTap: () => _selectDate(context, award),
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date (Year/Month)*', // Changed label to be generic
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
