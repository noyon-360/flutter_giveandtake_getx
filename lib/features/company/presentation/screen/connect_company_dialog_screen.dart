import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/features/company/presentation/controller/company_account_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../widget/custom_text_field.dart';

class RecruiterDialogContent extends StatefulWidget {
  const RecruiterDialogContent({super.key});

  @override
  State<RecruiterDialogContent> createState() => _RecruiterDialogContentState();
}

class _RecruiterDialogContentState extends State<RecruiterDialogContent> {
  final CompanyAccountController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.ensureEmployeeController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2B7FD0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Company Recruiters",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final busy = controller.isLoading.value;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "View your Company Recruiters",
                      style: TextStyle(
                        color: AppColors.textBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Select one or more recruiter profiles to add to your company.",
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    const SizedBox(height: 22),
                    _RecruiterField(index: 0, busy: busy),
                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      onPressed: busy ? null : controller.addEmployee,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text("Add More"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Column(
                      children: List.generate(
                        controller.employeeControllers.length,
                        (index) {
                          if (index == 0) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _RecruiterField(
                                    index: index,
                                    busy: busy,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  onPressed: busy
                                      ? null
                                      : () => controller.removeEmployeeField(
                                            index,
                                          ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: busy ? null : () => Get.back(),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: busy
                              ? null
                              : () async {
                                  final employeeIds =
                                      controller.getSelectedEmployeeIds();
                                  if (employeeIds.isEmpty) {
                                    Get.snackbar(
                                      "Error",
                                      "Select at least one recruiter",
                                    );
                                    return;
                                  }
                                  await controller.connectRecruiter(
                                    employeeIds,
                                  );
                                },
                          child: const Text("Add"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (busy)
                Positioned.fill(
                  child: Container(
                    color: Colors.white.withOpacity(0.6),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _RecruiterField extends StatelessWidget {
  const _RecruiterField({required this.index, required this.busy});

  final int index;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompanyAccountController>();
    controller.ensureEmployeeController();

    return GestureDetector(
      onTap: busy ? null : controller.fetchUsers,
      child: AbsorbPointer(
        child: CustomTextField(
          label: index == 0
              ? "Add Profiles of Recruiters"
              : "Recruiter ${index + 1}",
          hintText: "Tap to select recruiter",
          controller: controller.employeeControllers[index],
          isRequired: index == 0,
          readOnly: true,
        ),
      ),
    );
  }
}
