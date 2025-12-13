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
import '../controller/job_controller/job_posting_expiration_controller.dart';
import '../controller/job_controller/location_type_controller.dart';
import '../widgets/recuired_item.dart';

class JobDetailEditScreen extends StatefulWidget {
  final String jobId;

  const JobDetailEditScreen({super.key, required this.jobId});

  @override
  State<JobDetailEditScreen> createState() => _JobDetailEditScreenState();
}

class _JobDetailEditScreenState extends State<JobDetailEditScreen> {
  late JobEditController controller = Get.put(JobEditController());
  late LocationController locationController = LocationController();

  late EmploymentTypeController employeeController;
  late ExperienceLevelController experienceLevelController;
  late LocationTypeController locationTypeController;
  late CareerStageController careerStageController;
  late JobPostingExpirationController jobPostingExpirationController;


  @override
  void initState() {
    super.initState();

    jobPostingExpirationController = Get.put(JobPostingExpirationController());
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
                ? Row(children: [])
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



        List<String>? parts = job.location?.split(",");

        String? city = parts?.first;
        String? country = parts?.last;

        print("City: $city");
        print("Country: $country");


        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====== VIEW MODE ======
              if (!controller.isEditMode.value) ...[


                title("Job Title"),
                readonlyValue(job.title),
                title("Category"),
                readonlyValue(job.name),
                title("Role"),
                readonlyValue(job.role),
                Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          title("Country"),
                          Container(
                            width:double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.grey.shade300
                              )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(country!),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 6,),

                    Expanded(
                      child: Column(
                        children: [
                          title("City"),
                          Container(
                            width:double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: Colors.grey.shade300
                                )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(city!),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
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

                title("Company Website"),
                readonlyValue(
                  job.website_Url ?? "",
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


                // here add fetched country and city
                CountryCitySearchableDropdown(controller: locationController),

                // Add all other fields similarly...
                // (Vacancies, Compensation, Employment Type, etc.)
                // For brevity, I’ll skip repeating all — just follow the same pattern
                const Text("Number of Vacancies *"),
                TextFormField(
                  initialValue: controller.vacancies.value,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => controller.vacancies.value = v,
                  decoration: context.primaryInputDecoration.copyWith(
                    hintText: "1",
                  ),
                ),
                const SizedBox(height: 16),

                const Text("Compensation (Optional)"),
                TextFormField(
                  initialValue: controller.compensation.value,
                  onChanged: (v) => controller.compensation.value = v,
                  decoration: context.primaryInputDecoration.copyWith(
                    hintText: "e.g. 50,000",
                  ),
                ),
                const SizedBox(height: 16),

                _buildDropdown(
                  "Employment Type *",
                  employeeController.selectedEmploymentType,
                  employeeController.employmentTypes,
                ),
                _buildDropdown(
                  "Location Type *",
                  locationTypeController.selectedLocationType,
                  locationTypeController.locationTypes,
                ),

                _buildDropdown(
                  "Experience Level *",
                  experienceLevelController.selectedExperienceLevel,
                  experienceLevelController.experienceLevels,
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

                const SizedBox(height: 20),

                // ====================== PUBLISH DATE SECTION ======================
                const Text(
                  "Publish Settings",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                // Publish Now Switch
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Publish Now",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Switch(
                        value: controller.publishNow.value,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (bool value) {
                          controller.togglePublishNow(value);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Schedule Publish Calendar (only if NOT publish now)
                // Schedule Publish Calendar (only if NOT publish now)
                Obx(() {
                  if (controller.publishNow.value) {
                    return const SizedBox.shrink();
                  }

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Schedule Publish Date",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          SizedBox(
                            height: 340,
                            child: CalendarDatePicker(
                              initialDate: controller.safeInitialDate,
                              firstDate: DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                              ), // today at 00:00
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                              onDateChanged: (date) =>
                                  controller.updateSelectedPublishDate(date),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Obx(() {
                            final date = controller.selectedPublishDate.value;
                            if (date == null) return const SizedBox.shrink();

                            final formatted = DateFormat(
                              'dd MMMM yyyy',
                            ).format(date);
                            return Text(
                              "Job will be published on: $formatted",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.blueAccent,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 30),

                // Application Requirements
                const Text(
                  "Application Requirements",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Obx(
                  () => controller.resumeVisible.value
                      ? RequirementItem(
                          label: "Resume",
                          selectedStatus: controller.resumeStatus,
                          onDelete: () =>
                              controller.removeRequirement('resume'),
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => controller.visaVisible.value
                      ? RequirementItem(
                          label: "Valid visa for this job location?",
                          selectedStatus: controller.visaStatus,
                          onDelete: () => controller.removeRequirement('visa'),
                        )
                      : const SizedBox.shrink(),
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
                      decoration: InputDecoration(
                        hintText: "Enter question",
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(), // default border
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey,),
                        ),
                      ),
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

                const Text("Company Website)"),
                TextFormField(
                  initialValue: controller.companyWebsite.value,
                  onChanged: (v) => controller.companyWebsite.value = v,
                  decoration: context.primaryInputDecoration.copyWith(
                    hintText: "company website",
                  ),
                ),


                SizedBox(height: 30,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        controller.isEditMode(false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B7FD0),
                        minimumSize: const Size(160, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 30),
                    ElevatedButton(
                      onPressed: controller.saveJob,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B7FD0),
                        minimumSize: const Size(160, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),

                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 50,)
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
