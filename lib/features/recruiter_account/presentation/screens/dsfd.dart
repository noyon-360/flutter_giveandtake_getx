// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:html_editor_enhanced/html_editor.dart';
// import 'package:intl/intl.dart';
// import 'package:karlfive/core/common/widgets/app_scaffold.dart';
// import 'package:karlfive/features/recruiter_account/presentation/controller/job_edit_controller.dart';
// import 'package:karlfive/features/recruiter_account/presentation/widgets/country_city_searchable_dropdown.dart';
// import 'package:karlfive/features/recruiter_account/presentation/widgets/requirement_item.dart';
// import '../../../../core/theme/input_decoration_extensions.dart';
// import '../widgets/recuired_item.dart';
//
// class JobUpdateScreen extends StatelessWidget {
//   const JobUpdateScreen({super.key});
//
//   // Helper widgets for View Mode
//   Widget title(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 16, bottom: 6),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//       ),
//     );
//   }
//
//   Widget readonlyValue(String? value) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(value ?? "—", style: const TextStyle(fontSize: 16)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Use JobEditController, not JobPostingController
//     final controller = Get.find<JobEditController>();
//     final htmlController = HtmlEditorController();
//
//     return AppScaffold(
//       appBar: AppBar(
//           title: const Text("Job Details"),
//           actions: [
//           Obx(() => TextButton(
//       onPressed: controller.toggleEditMode,
//       child: Text(
//           controller.isEditMode.value ? "Cancel" : "Edit",
//           ",
//           style: const TextStyle(color: Colors.white),
//     ),
//     )),
//     ],
//     ),
//     body: Obx(() {
//     final job = controller.job.value;
//     if (job == null || controller.isLoading.value) {
//     return const Center(child: CircularProgressIndicator());
//     }
//
//     // ==================== VIEW MODE ====================
//     if (!controller.isEditMode.value) {
//     return SingleChildScrollView(
//     padding: const EdgeInsets.all(16),
//     child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//     title("Job Title"), readonlyValue(job.title),
//     title("Department"), readonlyValue(job.department),
//     title("Category"), readonlyValue(job.name),
//     title("Role"), readonlyValue(job.role),
//     title("Location"), readonlyValue(job.location),
//     title("Employment Type"), readonlyValue(job.employementType),
//     title("Experience Level"), readonlyValue(job.experience),
//     title("Location Type"), readonlyValue(job.locationType),
//     title("Career Stage"), readonlyValue(job.careerStage),
//     title("Vacancies"), readonlyValue(job.vacancy?.toString()),
//     title("Compensation"), readonlyValue(job.compensation),
//     title("Job Description"),
//     Container(
//     width: double.infinity,
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//     border: Border.all(color: Colors.grey.shade300),
//     borderRadius: BorderRadius.circular(8),
//     color: Colors.grey.shade50,
//     ),
//     child: Text(
//     job.description ?? "No description provided",
//     style: const TextStyle(fontSize: 15),
//     ),
//     ),
//     title("Publish Date"),
//     readonlyValue(job.publishDate != null
//     ? DateFormat('dd MMM yyyy').format(job.publishDate!)
//         : "Published Immediately"),
//     const SizedBox(height: 40),
//     ],
//     ),
//     );
//     }
//
//     // ==================== EDIT MODE ====================
//     return SingleChildScrollView(
//     padding: const EdgeInsets.all(16),
//     child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//     const Text("Edit Job", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//     const SizedBox(height: 20),
//
//     // Job Title
//     const Text("Job Title *", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
//     TextFormField(
//     initialValue: controller.jobTitle.value,
//     onChanged: (v) => controller.jobTitle.value = v,
//     decoration: context.primaryInputDecoration.copyWith(hintText: "Enter job title"),
//     ),
//     const SizedBox(height: 16),
//
//     const Text("Department*", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
//     TextFormField(
//     initialValue: controller.department.value,
//     onChanged: (v) => controller.department.value = v,
//     decoration: context.primaryInputDecoration.copyWith(hintText: "Enter department"),
//     ),
//     const SizedBox(height: 16),
//
//     // Category
//     const Text("Category *"),
//     DropdownButtonFormField<String>(
//     value: controller.selectedCategory.value.isEmpty ? null : controller.selectedCategory.value,
//     hint: const Text("Select category"),
//     decoration: _dropdownDecoration(),
//     items: controller.recruiterController.category
//         .map((c) => DropdownMenuItem(value: c.name, child: Text(c.name)))
//         .toList(),
//     onChanged: (v) => v != null ? controller.updateRoles(v) : null,
//     ),
//     const SizedBox(height: 16),
//
//     // Role
//     const Text("Role *"),
//     DropdownButtonFormField<String>(
//     value: controller.selectedRole.value.isEmpty ? null : controller.selectedRole.value,
//     hint: const Text("Select role"),
//     decoration: _dropdownDecoration(),
//     items: controller.roles
//         .map((r) => DropdownMenuItem(value: r, child: Text(r)))
//         .toList(),
//     onChanged: (v) => controller.selectedRole.value = v ?? '',
//     ),
//     const SizedBox(height: 16),
//
//     // Location
//     CountryCitySearchableDropdown(
//     onCityChanged: (city) => controller.selectedCity.value = city,
//     onCountryChanged: (country) => controller.selectedCountry.value = country,
//     initialCity: controller.selectedCity.value,
//     initialCountry: controller.selectedCountry.value,
//     ),
//     const SizedBox(height: 16),
//
//     // Vacancies
//     const Text("Number of Vacancies *"),
//     TextFormField(
//     initialValue: controller.vacancies.value,
//     keyboardType: TextInputType.number,
//     onChanged: (v) => controller.vacancies.value = v,
//     decoration: context.primaryInputDecoration.copyWith(hintText: "1"),
//     ),
//     const SizedBox(height: 16),
//
//     // Compensation
//     const Text("Compensation (Optional)"),
//     TextFormField(
//     initialValue: controller.compensation.value,
//     onChanged: (v) => controller.compensation.value = v,
//     decoration: context.primaryInputDecoration.copyWith(hintText: "e.g. 50,000"),
//     ),
//     const SizedBox(height: 16),
//
//     // Employment Type, Experience, Location Type, Career Stage
//     _buildDropdown("Employment Type *", controller.selectedEmploymentType, [
//     "Full-time", "Part-time", "Contract", "Freelance", "Internship"
//     ]),
//     const SizedBox(height: 16),
//     _buildDropdown("Experience Level *", controller.selectedExperienceLevel, [
//     "Entry Level", "Mid Level", "Senior Level", "Executive"
//     ]),
//     const SizedBox(height: 16),
//     _buildDropdown("Location Type *", controller.selectedLocationType, [
//     "On-site", "Remote", "Hybrid"
//     ]),
//     const SizedBox(height: 16),
//     _buildDropdown("Career Stage *", controller.selectedCareerStage, [
//     "Student", "Early Career", "Mid Career", "Experienced", "Manager", "Executive"
//     ]),
//     const SizedBox(height: 24),
//
//     // Job Description
//     const Text("Job Description *", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//     const SizedBox(height: 8),
//     Container(
//     decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
//     child: HtmlEditor(
//     controller: htmlController,
//     htmlEditorOptions: HtmlEditorOptions(
//     hint: "Describe the job...",
//     initialText: controller.jobDescriptionHtml.value,
//     ),
//     callbacks: Callbacks(onChangeContent: (content) {
//     controller.jobDescriptionHtml.value = content ?? '';
//     }),
//     ),
//     ),
//     const SizedBox(height: 30),
//
//     // Application Requirements
//     const Text("Application Requirements", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//     Obx(() => controller.resumeVisible.value
//     ? RequirementItem(
//     label: "Resume",
//     selectedStatus: controller.resumeStatus,
//     onDelete: () => controller.removeRequirement('resume'),
//     )
//         : const SizedBox.shrink()),
//     const SizedBox(height: 12),
//     Obx(() => controller.visaVisible.value
//     ? RequirementItem(
//     label: "Valid visa for this job location?",
//     selectedStatus: controller.visaStatus,
//     onDelete: () => controller.removeRequirement('visa'),
//     )
//         : const SizedBox.shrink()),
//     const SizedBox(height: 30),
//
//     // Custom Questions
//     const Text("Custom Questions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//     const SizedBox(height: 12),
//     ...controller.customQuestions.mapIndexed((i, q) => Padding(
//     padding: const EdgeInsets.only(bottom: 12),
//     child: TextFormField(
//     initialValue: q,
//     decoration: InputDecoration(
//     hintText: "Add a question...",
//     border: Border.all(color: Colors.grey),
//     borderRadius: BorderRadius.circular(8),
//     ),
//     maxLines: 2,
//     onChanged: (v) => controller.customQuestions[i] = v,
//     ),
//     )),
//     TextButton.icon(
//     onPressed: () => controller.customQuestions.add(''),
//     icon: const Icon(Icons.add),
//     label: const Text("Add Question"),
//     ),
//     const SizedBox(height: 40),
//
//     // Save Button
//     SizedBox(
//     width: double.infinity,
//     child: ElevatedButton(
//     style: ElevatedButton.styleFrom(
//     backgroundColor: const Color(0xFF2B7FD0),
//     padding: const EdgeInsets.symmetric(vertical: 16),
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//     ),
//     onPressed: () async {
//     await controller.saveJob();
//     },
//     child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 18)),
//     ),
//     ),
//     const SizedBox(height: 40),
//     ],
//     ),
//     );
//     }),
//     );
//   }
//
//   Widget _buildDropdown(String label, RxString obs, List<String> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label),
//         const SizedBox(height: 6),
//         Obx(() => DropdownButtonFormField<String>(
//           value: obs.value.isEmpty ? null : obs.value,
//           hint: Text("Select $label".toLowerCase()),
//           decoration: _dropdownDecoration(),
//           items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//           onChanged: (v) => obs.value = v ?? '',
//         )),
//       ],
//     );
//   }
//
//   InputDecoration _dropdownDecoration() {
//     return InputDecoration(
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.grey)),
//       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2B7FD0))),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
//     );
//   }
// }