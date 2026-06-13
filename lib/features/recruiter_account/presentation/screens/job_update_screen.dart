import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:giveandtake/core/common/widgets/app_scaffold.dart';
import 'package:giveandtake/features/recruiter_account/presentation/widgets/application_requirements.dart';

import '../../../../core/theme/input_decoration_extensions.dart';
import '../../data/models/get_currency_response_model.dart';
import '../controller/country_city_controller.dart';
import '../controller/job_controller/career_stage_controller.dart';
import '../controller/job_controller/employment_type_controller.dart';
import '../controller/job_controller/experience_level_controller.dart';
import '../controller/job_controller/job_posting_expiration_controller.dart';
import '../controller/job_controller/location_type_controller.dart';
import '../controller/job_posting_controller.dart';
import '../widgets/country_city_searchable_dropdown.dart';
import '../widgets/currency_picker_sheet.dart';
import '../widgets/job_description_editor.dart';
import '../widgets/recuired_item.dart';

class JobUpdateScreen extends StatefulWidget {
  const JobUpdateScreen({super.key});

  @override
  State<JobUpdateScreen> createState() => _JobUpdateScreenState();
}

class _JobUpdateScreenState extends State<JobUpdateScreen> {
  final controller = Get.put(JobPostingController());

  // final TextEditingController titleCtrl = TextEditingController(text: "Data Protection Officer");
  final RxBool isPublishNow = true.obs;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    controller.populateFieldsFromSingleJob();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch currencies if not already fetched
    // Load currencies if not already loaded
    if (controller.currencies.isEmpty) {
      controller.loadCurrenciesIfEmpty();
    }

    TextEditingController jobTitleTEController = TextEditingController(
      text: controller.selectedRole.value,
    );
    final FocusNode jobTitleFocusNode = FocusNode();

    TextEditingController departmentTEController = TextEditingController(
      text: controller.department.value,
    );
    final FocusNode departmentFocusNode = FocusNode();

    TextEditingController vacanciesTEController = TextEditingController(
      text: controller.vacancies.value.isNotEmpty
          ? controller.vacancies.value
          : '1',
    );

    final FocusNode vacanciesFocusNode = FocusNode();

    TextEditingController compensationTEController = TextEditingController(
      text: controller.compensation.value.isNotEmpty
          ? controller.compensation.value
          : '',
    );
    final FocusNode compensationFocusNode = FocusNode();

    TextEditingController companyWebTEController = TextEditingController(
      text: controller.companyWebsite.value.isNotEmpty
          ? controller.companyWebsite.value
          : '',
    );
    final FocusNode companyWebFocusNode = FocusNode();

    final LocationController countryCityController = Get.put(
      LocationController(),
    );

    // Listen to selectedRole changes and auto-fill + update controller.jobTitle
    ever(controller.selectedRole, (String role) {
      if (role.isNotEmpty) {
        jobTitleTEController.text = role;
        controller.jobTitle.value = role; //save it to controller
      }
    });

    // Also set controller.vacancies.value if empty
    if (controller.vacancies.value.isEmpty) {
      controller.vacancies.value = '1';
    }

    final EmploymentTypeController employeeController = Get.put(
      EmploymentTypeController(),
    );
    final ExperienceLevelController experienceLevelController = Get.put(
      ExperienceLevelController(),
    );
    final LocationTypeController locationTypeController = Get.put(
      LocationTypeController(),
    );
    final CareerStageController careerStageController = Get.put(
      CareerStageController(),
    );
    final JobPostingExpirationController jobPostingExpirationController =
        Get.put(JobPostingExpirationController());
    jobPostingExpirationController.calculateDeadline(
      controller.selectedDate.value,
    );

    // Reactive list of extra question controllers (after the first one)
    final RxList<TextEditingController> extraQuestionControllers =
        <TextEditingController>[].obs;

    // First question controller (always present)
    final TextEditingController firstQuestionController = TextEditingController(
      text: controller.customQuestion.isNotEmpty
          ? controller.customQuestion[0]
          : '',
    );

    // Initialize extra questions if they exist
    if (extraQuestionControllers.isEmpty &&
        controller.customQuestion.length > 1) {
      for (int i = 1; i < controller.customQuestion.length; i++) {
        extraQuestionControllers.add(
          TextEditingController(text: controller.customQuestion[i]),
        );
      }
    }

    // Function to add a new extra question
    void addQuestion() {
      extraQuestionControllers.add(TextEditingController());
    }

    return AppScaffold(
      appBar: AppBar(title: Text("Edit Job")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Job Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // ---------------- Job Category ----------------
            const Text(
              'Job Category *',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 6),

            Obx(() {
              return GestureDetector(
                onTap: () {
                  _showSearchableBottomSheet(
                    context,
                    title: 'Select Job Category',
                    items: controller.categories.map((c) => c.name).toList(),
                    onSelect: (value) {
                      controller.updateRoles(value);
                    },
                  );
                },
                child: AbsorbPointer(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: controller.selectedCategory.value.isEmpty
                        ? null
                        : controller.selectedCategory.value,
                    hint: const Text(
                      'Select category',
                      style: TextStyle(color: Colors.grey),
                    ),
                    decoration: _dropdownDecoration(),
                    items: controller.categories
                        .map(
                          (cat) => DropdownMenuItem(
                            value: cat.name,
                            child: Text(
                              cat.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (_) {},
                  ),
                ),
              );
            }),

            const SizedBox(height: 10),

            // ---------------- Role ----------------
            const Text(
              'Role *',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 6),

            Obx(() {
              return GestureDetector(
                onTap: () {
                  if (controller.roles.isEmpty) {
                    Get.snackbar(
                      'Select Category First',
                      'Please select a job category to see roles.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }
                  _showSearchableBottomSheet(
                    context,
                    title: 'Select Role',
                    items: controller.roles,
                    onSelect: (value) {
                      controller.selectedRole.value = value;
                    },
                  );
                },
                child: AbsorbPointer(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: controller.selectedRole.value.isEmpty
                        ? null
                        : controller.selectedRole.value,
                    hint: const Text(
                      'Select role',
                      style: TextStyle(color: Colors.grey),
                    ),
                    decoration: _dropdownDecoration(),
                    items: controller.roles
                        .map(
                          (role) => DropdownMenuItem(
                            value: role,
                            child: Text(role, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                    onChanged: (_) {},
                  ),
                ),
              );
            }),

            const SizedBox(height: 10),

            // ---------------- Job Title ----------------
            const Text(
              'Job Title *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: jobTitleTEController,
              focusNode: jobTitleFocusNode,
              onChanged: (value) => controller.jobTitle.value = value,
              textInputAction: TextInputAction.next,
              decoration: context.primaryInputDecoration.copyWith(
                hintText: "Enter job title",
                hintStyle: const TextStyle(
                  color: Color(0xFF787878),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            SizedBox(height: 10),
            const Text(
              'Department *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: departmentTEController,
              focusNode: departmentFocusNode,
              onChanged: (value) => controller.department.value = value,
              textInputAction: TextInputAction.next,
              decoration: context.primaryInputDecoration.copyWith(
                hintText: "Enter department",
                hintStyle: const TextStyle(
                  color: Color(0xFF787878),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            SizedBox(height: 10),
            CountryCitySearchableDropdown(controller: countryCityController),

            SizedBox(height: 10),
            // Number of Vacancies Field
            const Text(
              'Number of Vacancies *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),

            //implement the vacancies textfield
            SizedBox(
              height: 50,
              child: TextFormField(
                controller: vacanciesTEController,
                focusNode: vacanciesFocusNode,
                onChanged: (value) => controller.vacancies.value = value,
                keyboardType: TextInputType.number,
                decoration: context.primaryInputDecoration.copyWith(
                  hintText: vacanciesTEController.text,
                  suffixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Increment Button
                      GestureDetector(
                        onTap: () {
                          int value =
                              int.tryParse(vacanciesTEController.text) ?? 0;
                          if (value < 50) {
                            value++;
                            vacanciesTEController.text = value.toString();
                            controller.vacancies.value = value
                                .toString(); // update the observable
                          }
                        },
                        child: Container(
                          height: 17,
                          width: 22,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_drop_up,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 3),
                      //Removed SizedBox, now only 1-pixel border gap
                      GestureDetector(
                        onTap: () {
                          int value =
                              int.tryParse(vacanciesTEController.text) ?? 0;
                          if (value > 1) {
                            value--;
                            vacanciesTEController.text = value.toString();
                            controller.vacancies.value = value
                                .toString(); // update the observable
                          }
                        },
                        child: Container(
                          height: 17,
                          width: 22,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_drop_down,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  hintStyle: const TextStyle(
                    color: Color(0xFF787878),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),
            const Text(
              "Maximum 50",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            SizedBox(height: 10),

            const Text(
              'Employment Type *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 6),

            Obx(
              () => DropdownButtonFormField<String>(
                isExpanded: true,
                value: employeeController.selectedEmploymentType.value.isEmpty
                    ? null
                    : employeeController.selectedEmploymentType.value,
                decoration: context.primaryInputDecoration.copyWith(
                  hintText: 'Select employment type',
                  hintStyle: const TextStyle(
                    color: Color(0xFF787878),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                items: employeeController.employmentTypes
                    .map(
                      (type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          type,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  employeeController.selectedEmploymentType.value = value ?? '';
                },
              ),
            ),

            SizedBox(height: 10),

            const Text(
              'Experience Level*',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 6),
            Obx(
              () => DropdownButtonFormField<String>(
                isExpanded: true,
                // Guard against a saved value (e.g. "mid") that isn't one of the
                // dropdown items — otherwise DropdownButton asserts and crashes.
                value:
                    experienceLevelController.experienceLevels.contains(
                      experienceLevelController.selectedExperienceLevel.value,
                    )
                    ? experienceLevelController.selectedExperienceLevel.value
                    : null,
                decoration: InputDecoration(
                  hintText: 'Select experience level',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                items: experienceLevelController.experienceLevels
                    .map(
                      (type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          type,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  experienceLevelController.selectedExperienceLevel.value =
                      value ?? '';
                },
              ),
            ),

            SizedBox(height: 10),
            const Text(
              'Location Type*',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),

            SizedBox(height: 6),

            Obx(
              () => DropdownButtonFormField<String>(
                isExpanded: true,
                value: locationTypeController.selectedLocationType.value.isEmpty
                    ? null
                    : locationTypeController.selectedLocationType.value,
                decoration: InputDecoration(
                  hintText: 'Select location type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                items: locationTypeController.locationTypes
                    .map(
                      (type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          type,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  locationTypeController.selectedLocationType.value =
                      value ?? '';
                },
              ),
            ),

            SizedBox(height: 10),
            const Text(
              'Career Stage*',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),

            SizedBox(height: 6),

            Obx(
              () => DropdownButtonFormField<String>(
                isExpanded: true,
                value: careerStageController.selectedCareerStage.value.isEmpty
                    ? null
                    : careerStageController.selectedCareerStage.value,
                decoration: InputDecoration(
                  hintText: 'Select career stage',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                items: careerStageController.careerStages
                    .map(
                      (type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          type,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  careerStageController.selectedCareerStage.value = value ?? '';
                },
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Currency*',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),

            Obx(() {
              return GestureDetector(
                onTap: () async {
                  if (controller.currencies.isEmpty) {
                    Get.snackbar(
                      'No Currencies Found',
                      'Please fetch currencies from backend',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  final selected = await showCurrencyPickerSheet(
                    context,
                    currencies: controller.currencies,
                    selectedCurrency: controller.selectedCurrency.value,
                  );

                  if (selected != null) {
                    controller.selectedCurrency.value = selected;

                    // Automatically focus the compensation field
                    compensationFocusNode.requestFocus();
                  }
                },
                child: AbsorbPointer(
                  child: DropdownButtonFormField<GetCurrencyResponseModel>(
                    isExpanded: true,
                    value: controller.selectedCurrency.value,
                    hint: const Text('Select currency'),
                    decoration: _dropdownDecoration(),
                    items: controller.currencies.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(
                          '${currency.currencyName} (${currency.symbol})',
                        ),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                ),
              );
            }),

            SizedBox(height: 10),
            Text(
              'Compensation (Optional)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 6),

            Obx(() {
              final selectedCurrency = controller.selectedCurrency.value;

              return TextFormField(
                controller: compensationTEController,
                focusNode: compensationFocusNode,
                onChanged: (value) => controller.compensation.value = value,
                keyboardType: TextInputType.number,
                decoration: context.primaryInputDecoration.copyWith(
                  prefixText: selectedCurrency?.symbol != null
                      ? '${selectedCurrency!.symbol}   ' // add 2 spaces
                      : '',
                  prefixStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: "e.g., 50,000",
                  hintStyle: const TextStyle(
                    color: Color(0xFF787878),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }),

            SizedBox(height: 10),
            Text(
              'Job Posting Expiration (Days)*',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 6),

            Obx(
              () => DropdownButtonFormField<String>(
                isExpanded: true,
                value:
                    jobPostingExpirationController
                        .selectedJobPostingExpiration
                        .value
                        .isEmpty
                    ? null
                    : jobPostingExpirationController
                          .selectedJobPostingExpiration
                          .value,
                decoration: context.primaryInputDecoration.copyWith(
                  hintText:
                      jobPostingExpirationController.jobPostingExpiration[2],
                  hintStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                items: jobPostingExpirationController.jobPostingExpiration
                    .map(
                      (type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          type,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  jobPostingExpirationController
                          .selectedJobPostingExpiration
                          .value =
                      value ?? '';
                },
              ),
            ),

            SizedBox(height: 10),
            const Text(
              'Company Website (Optional)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: companyWebTEController,
              focusNode: companyWebFocusNode,
              onChanged: (value) => controller.companyWebsite.value = value,
              textInputAction: TextInputAction.next,
              decoration: context.primaryInputDecoration.copyWith(
                hintText: "https://example.com",
                hintStyle: const TextStyle(
                  color: Color(0xFF787878),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const SizedBox(height: 10),

            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 760;

                /// LEFT SIDE — Job Description Editor
                Widget left = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Job Description',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Job Description',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Rich-text job description
                    JobDescriptionEditor(
                      controller: controller.jobDescriptionQuillController,
                    ),

                    const SizedBox(height: 8),

                    // Character / Word Count
                    Obx(() {
                      final charCount = controller.characterCount.value;
                      final wordCount = controller.wordCount.value;
                      const wordMin = 20;
                      const charMax = 2000;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Character count: $charCount/$charMax'),
                          const SizedBox(height: 6),
                          Text('Word count: $wordCount/$wordMin minimum'),
                        ],
                      );
                    }),
                  ],
                );

                /// RIGHT SIDE — Tip + Publish Toggle + Calendar
                Widget right = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //TIP FIRST
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      color: Colors.grey.shade50,
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TIP',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'To help candidates understand the job expectations, please only cite the actual skills, experience, qualifications and/or certifications required for this role.',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    //Publish Now switch
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Publish Now',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Switch(
                            value: controller.publishNow.value,
                            onChanged: (v) => controller.togglePublishNow(v),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 16),

                    //Calendar when PublishNow == false
                    Obx(() {
                      if (controller.publishNow.value)
                        return const SizedBox.shrink();

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SizedBox(
                            width: isWide ? 300 : double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Schedule Publish',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                CalendarDatePicker(
                                  initialDate: controller.selectedDate.value,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                  onDateChanged: (date) {
                                    controller.updateSelectedDate(date);

                                    //Update expiration date too
                                    jobPostingExpirationController
                                        .calculateDeadline(date);
                                  },
                                ),
                                const SizedBox(height: 8),

                                //Show Publish and Expire Date
                                Obx(() {
                                  final publishDate =
                                      controller.selectedDate.value;
                                  final expireDate =
                                      jobPostingExpirationController
                                          .finalDeadlineDate
                                          .value;

                                  final publishStr = DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(publishDate);

                                  final expireStr = expireDate != null
                                      ? DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(expireDate)
                                      : "Not set";

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Publish Date: $publishStr'),
                                      Text('Expire Date: $expireStr'),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                );

                /// LAYOUT
                Widget mainContent = isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: left),
                          const SizedBox(width: 24),
                          SizedBox(width: 320, child: right),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [left, const SizedBox(height: 16), right],
                      );

                /// FINAL LAYOUT
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [mainContent],
                );
              },
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Application Requirements",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "What personal info would you like to gather about each applicant?",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 24),

                // Resume option (show only if visible)
                Obx(() {
                  if (!controller.resumeVisible.value)
                    return const SizedBox.shrink();
                  return RequirementItem(
                    label: "Resume",
                    //onChanged: (value) => controller.resumeRequired.value = value,
                    selectedStatus: controller.resumeStatus,
                    onDelete: () => controller.removeRequirement('resume'),
                  );
                }),

                SizedBox(height: 25),

                // Valid visa option
                Obx(() {
                  if (!controller.visaVisible.value)
                    return const SizedBox.shrink();
                  return RequirementItem(
                    label: "Have you got a valid visa for this location?",

                    //onChanged: (value) => controller.validVisaRequired.value = value,
                    selectedStatus: controller.visaStatus,
                    onDelete: () => controller.removeRequirement('visa'),
                  );
                }),
                SizedBox(height: 50),
              ],
            ),

            const SizedBox(height: 20),

            Obx(
              () => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add Custom Questions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // First mandatory question
                    _buildQuestionField(
                      firstQuestionController,
                      "Ask a question",
                    ),

                    // Extra questions
                    Column(
                      children: List.generate(extraQuestionControllers.length, (
                        index,
                      ) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: _buildQuestionField(
                            extraQuestionControllers[index],
                            "Ask a question",
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 16),

                    // Add question button
                    TextButton.icon(
                      onPressed: addQuestion,
                      icon: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B7FD0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                      label: const Text(
                        "Add a question",
                        style: TextStyle(
                          color: Color(0xFF2B7FD0),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2B7FD0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      //minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2B7FD0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "cancle",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionField(TextEditingController controller, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF2B7FD0),
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Write Here",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------
  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  void _showSearchableBottomSheet(
    BuildContext context, {
    required String title,
    required List<String> items,
    required Function(String) onSelect,
  }) {
    final searchController = TextEditingController();
    final filteredItems = RxList<String>(List.from(items));

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (query) {
                        filteredItems.assignAll(
                          items
                              .where(
                                (item) => item.toLowerCase().contains(
                                  query.toLowerCase(),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                  Obx(
                    () => Expanded(
                      child: ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final value = filteredItems[index];
                          return ListTile(
                            title: Text(value),
                            onTap: () {
                              onSelect(value);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF787878), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF787878), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF787878), width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey),
    );
  }
}
