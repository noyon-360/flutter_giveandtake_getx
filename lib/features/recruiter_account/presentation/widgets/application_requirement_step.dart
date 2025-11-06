import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/job_posting_controller.dart';

class ApplicationRequirementStep extends StatelessWidget {
  const ApplicationRequirementStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobPostingController>();
    print('Current step: ${controller.currentStep.value}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Application Requirements",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "What personal info would you like to gather about each applicant?",
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 24),

        // Resume option (show only if visible)
        Obx(() {
          if (!controller.resumeVisible.value) return const SizedBox.shrink();
          return _RequirementItem(
            label: "Resume",
            value: controller.resumeRequired,
            onChanged: (value) => controller.resumeRequired.value = value,
            selectedStatus: controller.resumeStatus,
            onDelete: () => controller.removeRequirement('resume'),
          );
        }),

        SizedBox(height: 25,),

        // Valid visa option
        Obx(() {
          if (!controller.visaVisible.value) return const SizedBox.shrink();
          return _RequirementItem(
            label: "Valid visa for this job location?",
            value: controller.validVisaRequired,
            onChanged: (value) => controller.validVisaRequired.value = value,
            selectedStatus: controller.visaStatus,
            onDelete: () => controller.removeRequirement('visa'),
          );
        }),

        const SizedBox(height: 40),

        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF2B7FD0)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(),
                  child: Text(
                    'Cancle',
                    style: TextStyle(
                      color: Color(0xFF2B7FD0),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(width: 20),

            Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(color: Color(0xFF2B7FD0), borderRadius: BorderRadius.circular(8)),
              child: ElevatedButton(
                onPressed: () {controller.nextStep();},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                ),
                child: Text('Next', style: TextStyle(
                  color: Colors.white,fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),),
              ),
            ),
          ],
        ),
        SizedBox(height: 50),
      ],
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final String label;
  final RxBool value;
  final void Function(bool) onChanged;
  final RxString selectedStatus;
  final VoidCallback onDelete;

  const _RequirementItem({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.selectedStatus,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              // Rounded box instead of Checkbox
              GestureDetector(
                onTap: () => onChanged(!value.value),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: value.value ? Color(0xFF2B7FD0) : Colors.grey,
                      width: 2,
                    ),
                    color: value.value ? Color(0xFF2B7FD0) : Colors.transparent,
                  ),
                  child: value.value
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedStatus.value.isEmpty ? null : selectedStatus.value,
              hint: const Text("Set status", style: TextStyle(color: Colors.black),),
              items: const [
                DropdownMenuItem(value: "Required", child: Text("Required")),
                DropdownMenuItem(value: "Optional", child: Text("Optional")),
              ],
              onChanged: (val) {
                if (val != null) selectedStatus.value = val;
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_forever_rounded, color: Colors.grey,),
          color: Colors.grey,
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Remove requirement'),
                content: Text('Remove "$label" from application requirements?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onDelete();
                    },
                    child: const Text('Remove'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ));

  }
}
