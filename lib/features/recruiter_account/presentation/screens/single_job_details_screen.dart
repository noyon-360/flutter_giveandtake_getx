import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/country_city_controller.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/job_edit_controller.dart';
import 'package:karlfive/features/recruiter_account/presentation/widgets/country_city_searchable_dropdown.dart';

import '../../../../core/theme/input_decoration_extensions.dart';
import '../controller/job_controller/career_stage_controller.dart';
import '../controller/job_controller/employment_type_controller.dart';
import '../controller/job_controller/experience_level_controller.dart';
import '../controller/job_controller/location_type_controller.dart';

class JobDetailEditScreen extends StatefulWidget {
  final String jobId;

  const JobDetailEditScreen({super.key, required this.jobId});

  @override
  State<JobDetailEditScreen> createState() => _JobDetailEditScreenState();
}

class _JobDetailEditScreenState extends State<JobDetailEditScreen> {
  late JobEditController controller = Get.put(JobEditController());
  late LocationController locationController = LocationController();

  // final EmploymentTypeController employeeController = Get.put(
  //   EmploymentTypeController(),
  // );
  // final ExperienceLevelController experienceLevelController = Get.put(
  //   ExperienceLevelController(),
  // );
  // final LocationTypeController locationTypeController = Get.put(
  //   LocationTypeController(),
  // );
  // final CareerStageController careerStageController = Get.put(
  //   CareerStageController(),
  // );

  late EmploymentTypeController employeeController;
  late ExperienceLevelController experienceLevelController;
  late LocationTypeController locationTypeController;
  late CareerStageController careerStageController;

  @override
  void initState() {
    super.initState();

    // Put all controllers safely
    controller = Get.put(JobEditController());
    locationController = Get.put(LocationController());
    employeeController = Get.find<EmploymentTypeController>();
    experienceLevelController = Get.find<ExperienceLevelController>();
    locationTypeController = Get.find<LocationTypeController>();
    careerStageController = Get.find<CareerStageController>();

    // SAFE WAY: Fetch job AFTER first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchJob(widget.jobId);
    });
  }

  @override
  Widget build(BuildContext context) {
    //controller.fetchJob(widget.jobId);

    final htmlController = HtmlEditorController();

    return AppScaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
        actions: [
          Obx(
            () => controller.isEditMode.value
                ? Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          controller.isEditMode(false);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: controller.saveJob,
                        child: const Text("Save"),
                      ),
                    ],
                  )
                : IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: controller.toggleEditMode,
                  ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.job.value == null) {
          return const Center(child: Text("Job not found"));
        }

        final job = controller.job.value!;

        // Helper widgets
        Widget title(String text) => Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 6),
          child: Text(
            text,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
        );

        Widget readonlyValue(String? text) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(text ?? "Not Provided"),
        );

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====== VIEW MODE ======
              if (!controller.isEditMode.value) ...[
                title("Job Title"),
                readonlyValue(job.title),
                title("Department"),
                readonlyValue(job.department),
                title("Category"),
                readonlyValue(job.name),
                title("Role"),
                readonlyValue(job.role),
                title("Location"),
                readonlyValue(job.location),
                title("Employment Type"),
                readonlyValue(job.employementType),
                title("Experience Level"),
                readonlyValue(job.experience),
                title("Location Type"),
                readonlyValue(job.locationType),
                title("Career Stage"),
                readonlyValue(job.careerStage),
                title("Vacancies"),
                readonlyValue(job.vacancy?.toString()),
                title("Compensation"),
                readonlyValue(job.compensation),
                title("Description"),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(job.description ?? "No description"),
                ),
                title("Publish Date"),
                readonlyValue(
                  job.publishDate != null
                      ? DateFormat('yyyy-MM-dd').format(job.publishDate!)
                      : "Immediately",
                ),
                const SizedBox(height: 50),
              ]
              // ====== EDIT MODE ======
              else ...[
                // Job Title
                // Job Title
                const Text(
                  "Job Title *",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                TextFormField(
                  initialValue: controller.jobTitle.value,
                  onChanged: (v) => controller.jobTitle.value = v,
                  decoration: context.primaryInputDecoration.copyWith(
                    hintText: "Enter job title",
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  "Department*",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                TextFormField(
                  initialValue: controller.department.value,
                  onChanged: (v) => controller.department.value = v,
                  decoration: context.primaryInputDecoration.copyWith(
                    hintText: "Enter department",
                  ),
                ),
                const SizedBox(height: 16),

                // Category
                const Text("Category *"),
                SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: controller.selectedCategory.value.isEmpty
                      ? null
                      : controller.selectedCategory.value,
                  hint: const Text("Select category"),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                  ),
                  items: controller.recruiterController.category
                      .map(
                        (c) => DropdownMenuItem(
                          value: c.name,
                          child: Text(c.name),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      controller.updateRoles(v);
                    }
                  },
                ),

                const SizedBox(height: 16),

                const Text("Role *"),
                DropdownButtonFormField<String>(
                  value: controller.selectedRole.value.isEmpty
                      ? null
                      : controller.selectedRole.value,
                  hint: const Text("Select role"),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                  ),
                  items: controller.roles
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) {
                    controller.selectedRole.value = v ?? '';
                  },
                ),
                const SizedBox(height: 16),

                CountryCitySearchableDropdown(controller: locationController),

                // Add all other fields similarly...
                // (Vacancies, Compensation, Employment Type, etc.)
                // For brevity, I’ll skip repeating all — just follow the same pattern

                const Text("Number of Vacancies *"),
                TextFormField(
                  initialValue: controller.vacancies.value,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => controller.vacancies.value = v,
                  decoration: context.primaryInputDecoration.copyWith(hintText: "1"),
                ),
                const SizedBox(height: 16),

                const Text("Compensation (Optional)"),
                TextFormField(
                  initialValue: controller.compensation.value,
                  onChanged: (v) => controller.compensation.value = v,
                  decoration: context.primaryInputDecoration.copyWith(hintText: "e.g. 50,000"),
                ),
                const SizedBox(height: 16),

                _buildDropdown(
                  "Employment Type *",
                  employeeController.selectedEmploymentType,
                  employeeController.employmentTypes,
                ),

                _buildDropdown(
                  "Experience Level *",
                  experienceLevelController.selectedExperienceLevel,
                  experienceLevelController.experienceLevels,
                ),

                _buildDropdown(
                  "Location Type *",
                  locationTypeController.selectedLocationType,
                  locationTypeController.locationTypes,
                ),

                _buildDropdown(
                  "Career Stage *",
                  careerStageController.selectedCareerStage,
                  careerStageController.careerStages,
                ),



                const SizedBox(height: 20),

                // Job Description Editor
                const Text(
                  "Job Description",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: HtmlEditor(
                    controller: htmlController,
                    htmlEditorOptions: HtmlEditorOptions(
                      hint: "Describe the job...",
                      initialText: controller.jobDescriptionHtml.value,
                    ),
                    callbacks: Callbacks(
                      onChangeContent: (content) {
                        controller.jobDescriptionHtml.value = content ?? '';
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Custom Questions (simplified)
                const Text(
                  "Custom Questions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...controller.customQuestions.map(
                  (q) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      initialValue: q,
                      onChanged: (v) {
                        final i = controller.customQuestions.indexOf(q);
                        controller.customQuestions[i] = v;
                      },
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => controller.customQuestions.add(''),
                  icon: const Icon(Icons.add),
                  label: const Text("Add Question"),
                ),

                const SizedBox(height: 40),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDropdown(String label, RxString obs, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        Obx(
          () => DropdownButtonFormField<String>(
            value: obs.value.isEmpty ? null : obs.value,
            hint: Text("Select $label".toLowerCase()),
            decoration: _dropdownDecoration(),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => obs.value = v ?? '',
          ),
        ),
      ],
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF2B7FD0)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    );
  }
}
