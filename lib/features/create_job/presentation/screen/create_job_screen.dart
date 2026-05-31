import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../company/presentation/widget/coustom_dropdown_widgets.dart';
import '../../../company/presentation/widget/custom_text_field.dart';
import '../controller/category_controller.dart';
import '../controller/create_job_controller.dart';
import '../widgets/job_create_widgets.dart';
import '../widgets/searchable_widgets.dart';

class CreateJobPostingScreen extends StatelessWidget {
  final CreateJobPostingController controller = Get.put(
    CreateJobPostingController(Get.find()),
  );

  final CategoryController categoryController = Get.put(
    CategoryController(Get.find()),
  );
  

  CreateJobPostingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Create Job Posting",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(() {
        // Only the initial loading gate reacts here; the form itself is built
        // outside this Obx so typing in a TextField never rebuilds the fields
        // (which would dismiss the keyboard on every keystroke).
        if (controller.isLoadingCountries.value ||
            categoryController.isLoading.value) {
          // || categoryController.isLoading.value
          return const Center(child: CircularProgressIndicator());
        }

        return _buildForm();
      }),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _progressIndicator(),
          const SizedBox(height: 20),
          const Text(
            "Keep candidates updated at every stage of their application journey with a single click.",
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
          const SizedBox(height: 24),
          const Text(
            "Job Details",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                // Scoped Obx: rebuilds only this dropdown when the
                // selected category changes, not the whole form.
                child: Obx(() {
                  return SearchableDropdownField(
                    label: "Job Category",
                    hintText: 'Select job category',
                    items: categoryController.categories
                        .map((c) => c.name)
                        .toList(),
                    value: categoryController.selectedCategory.value,
                    onChanged: (value) {
                      categoryController.selectedCategory.value = value;
                      // Update roles based on selected category
                      categoryController.updateRoles(value);
                    },
                  );
                }),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(() {
                  return SearchableDropdownField(
                    label: "Job Role",
                    hintText: 'Select role',
                    items: categoryController.roles,
                    value: categoryController.selectedRole.value,
                    onChanged: (value) {
                      categoryController.selectedRole.value = value;
                      // Only auto-fill Job Title if user hasn't typed manually
                      if (!controller.jobTitleManuallyEdited.value) {
                        controller.jobTitleController.text = value;
                      }
                    },
                    enabled: categoryController.roles.isNotEmpty,
                  );
                }),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Job Title
          ///
          CustomTextField(
            label: "Job Title",
            hintText: "Enter job title",
            controller: controller.jobTitleController,
            isRequired: true,
            // onChanged: (text) {
            //   // Mark as manually edited when user types
            //   controller.jobTitleManuallyEdited.value = true;
            // },
          ),

          // CustomTextField(
          //   label: "Job Title",
          //   hintText: "Enter job title",
          //   controller: controller.jobTitleController,
          //   isRequired: true,
          // ),
          CustomTextField(
            label: "Department (Optional)",
            hintText: "Enter department",
            controller: controller.departmentController,
            isRequired: false,
          ),

          const SizedBox(height: 16),

          /// Country + City Section
          CountryCitySelector(controller: controller),
          const SizedBox(height: 16),

          ///Job Category=Role selection

          // JobCategoryRoleSelector(controller:   controller),
          // const SizedBox(height: 16),

          /// Employment Type
          Row(
            children: [
              Expanded(
                child: CustomDropdownJobField(
                  label: "Employment Type",
                  hintText: 'Select employment type',
                  items: [
                    "Full-time",
                    "Part-time",
                    "Internship",
                    "Contract",
                    "Temporary",
                    "Freelance",
                    "Volunteer",
                  ],
                  isRequired: true,
                  rxValue: controller.selectedEmploymentType,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomDropdownJobField(
                  label: "Experience Level",
                  hintText: 'Select experience level',
                  items: [
                    "Entry Level",
                    "Mid Level",
                    "Senior Level",
                    "Executive",
                  ],
                  isRequired: true,
                  rxValue: controller.selectedEmploymentType,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Compensation
          CustomTextField(
            label: "Compensation (Optional)",
            hintText: "Enter compensation details",
            controller: controller.compensationController,
          ),

          const SizedBox(height: 20),
          _bottomButtons(),
        ],
      ),
    );
  }

  Widget _progressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _stepItem("Job Details", true),
        _stepItem("Job Description", false),
        _stepItem("Application\nRequirements", false),
        _stepItem("Custom\nQuestions", false),
        _stepItem("Finish", false),
      ],
    );
  }

  Widget _stepItem(String title, bool active) {
    return Column(
      children: [
        Icon(
          Icons.circle,
          size: 12,
          color: active ? Colors.blue : Colors.grey.shade300,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            color: active ? Colors.blue : Colors.grey,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _bottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => Get.snackbar("Next", "Proceeding to next step..."),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Next"),
        ),
      ],
    );
  }
}
