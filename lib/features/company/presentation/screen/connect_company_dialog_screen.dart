import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/features/company/presentation/controller/company_account_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../widget/custom_text_field.dart';

class RecruiterDialogContent extends StatefulWidget {
  RecruiterDialogContent({super.key});

  @override
  State<RecruiterDialogContent> createState() => _RecruiterDialogContentState();
}

class _RecruiterDialogContentState extends State<RecruiterDialogContent> {
  final CompanyAccountController controller = Get.find();
  //  Map<TextEditingController, String> employeeIdMap = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        "View your Company Recruiters",
        style: TextStyle(
          color: AppColors.textBlack,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      content: SizedBox(
        width: 400, // Center dialog width
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First recruiter field
              GestureDetector(
                onTap: controller.fetchUsers,
                child: AbsorbPointer(
                  child: CustomTextField(
                    label: "Add Profiles of Recruiters",
                    hintText: "Tap to select recruiter",
                    controller: controller.employeeControllers[0],
                    isRequired: true,
                    readOnly: true,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Add more button
              ElevatedButton(
                onPressed: controller.addEmployee,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
                child: const Text("Add More +"),
              ),

              const SizedBox(height: 16),

              // Dynamic recruiter list
              Obx(
                () => Column(
                  children: List.generate(
                    controller.employeeControllers.length,
                    (index) {
                      if (index == 0) return const SizedBox.shrink();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: controller.fetchUsers,
                                child: AbsorbPointer(
                                  child: CustomTextField(
                                    label: "Recruiter ${index + 1}",
                                    hintText: "Tap to select recruiter",
                                    controller:
                                        controller.employeeControllers[index],
                                    readOnly: true,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () =>
                                  controller.removeEmployeeField(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // -------- ACTION BUTTONS --------
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
        ),

        // Add Button → PATCH API call
        ElevatedButton(
          onPressed: () async {
            final employeeIds = controller.getSelectedEmployeeIds();
            if (employeeIds.isEmpty) {
              Get.snackbar("Error", "Select at least one recruiter");
              return;
            }
            await controller.connectRecruiter(employeeIds);
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
