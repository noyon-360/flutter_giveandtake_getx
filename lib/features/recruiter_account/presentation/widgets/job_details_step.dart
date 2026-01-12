import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';
import 'package:karlfive/features/recruiter_account/data/models/get_currency_response_model.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/job_controller/career_stage_controller.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/job_controller/job_posting_expiration_controller.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/job_controller/location_type_controller.dart';
import '../controller/country_city_controller.dart';
import '../controller/job_controller/employment_type_controller.dart';
import '../controller/job_controller/experience_level_controller.dart';
import '../controller/job_posting_controller.dart';
import 'country_city_searchable_dropdown.dart';

class JobDetailsStep extends StatefulWidget {
  const JobDetailsStep({super.key});

  @override
  State<JobDetailsStep> createState() => _JobDetailsStepState();
}

class _JobDetailsStepState extends State<JobDetailsStep> {
  final controller = Get.find<JobPostingController>();

  @override
  Widget build(BuildContext context) {
    // Fetch currencies if not already fetched
    // Load currencies if not already loaded
    if (controller.currencies.isEmpty) {
      controller.loadCurrenciesIfEmpty();
    }

    final _formKey = GlobalKey<FormState>();

    TextEditingController _jobTitleTEController = TextEditingController(
      text: controller.selectedRole.value,
    );

    final FocusNode _jobTitleFocusNode = FocusNode();

    TextEditingController _departmentTEController = TextEditingController(
      text: controller.department.value,
    );
    final FocusNode _departmentFocusNode = FocusNode();

    TextEditingController _vacanciesTEController = TextEditingController(
      text: controller.vacancies.value.isNotEmpty
          ? controller.vacancies.value
          : '1', // default
    );

    final FocusNode _vacanciesFocusNode = FocusNode();

    TextEditingController _compensationTEController = TextEditingController(
      text: controller.compensation.value.isNotEmpty
          ? controller.compensation.value
          : '',
    );
    final FocusNode _compensationFocusNode = FocusNode();

    TextEditingController _companyWebTEController = TextEditingController(text: controller.companyWebsite.value.isNotEmpty
        ? controller.companyWebsite.value
        : '',);
    final FocusNode _companyWebFocusNode = FocusNode();

    final LocationController countryCityController = Get.put(
      LocationController(),
    );

    // Listen to selectedRole changes and auto-fill + update controller.jobTitle
    ever(controller.selectedRole, (String role) {
      if (role.isNotEmpty) {
        _jobTitleTEController.text = role;
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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Job Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // ---------------- Job Category ----------------
              // const Text(
              //   'Job Category *',
              //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              // ),
              // const SizedBox(height: 6),

              Obx(() => _buildValidatedDropdown(
                label: 'Job Category',
                currentValue: controller.selectedCategory.value,
                //errorText: 'Category is required',
                child: GestureDetector(
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
                      hint: const Text('  Select category', style: TextStyle(color: Colors.grey)),
                      // Use custom decoration with error-aware borders
                      decoration: _dropdownDecoration().copyWith(
                        // Normal border (when no error)
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        // Red border when there's an error
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFC12222), width: 1.5),
                        ),
                        // Red border when focused and error
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFC12222), width: 2),
                        ),
                        // Optional: also style focused border normally
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey, width: 2), // or your app's primary color
                        ),
                      ),
                      items: controller.categories
                          .map((cat) => DropdownMenuItem(
                        value: cat.name,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(cat.name, overflow: TextOverflow.ellipsis),
                        ),
                      ))
                          .toList(),
                      onChanged: (_) {}, // Disabled due to AbsorbPointer
                      // Important: Add validator so Form knows when to show error state
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Category is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              )),
              //const SizedBox(height: 20),

              //const SizedBox(height: 10),

              // ---------------- Role ----------------
              // const Text(
              //   'Role *',
              //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              // ),
              // const SizedBox(height: 6),

              Obx(() => _buildValidatedDropdown(
                label: 'Role',
                currentValue: controller.selectedRole.value,
                // This will show below the field on error
                child: GestureDetector(
                  onTap: () {
                    if (controller.roles.isEmpty) {
                      Get.snackbar('Select Category First', 'Please select a job category to see roles.');
                      return;
                    }
                    _showSearchableBottomSheet(
                      context,
                      title: 'Select Role',
                      items: controller.roles,
                      onSelect: (value) {
                        controller.selectedRole.value = value;
                        if (controller.jobTitle.value.isEmpty ||
                            controller.jobTitle.value == controller.selectedRole.value) {
                          controller.jobTitle.value = value;
                          _jobTitleTEController.text = value;
                        }
                      },
                    );
                  },
                  child: AbsorbPointer(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: controller.selectedRole.value.isEmpty
                          ? null
                          : controller.selectedRole.value,
                      hint: const Text('  Select role', style: TextStyle(color: Colors.grey)),
                      decoration: _dropdownDecoration().copyWith(
                        // Normal borders
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
                          borderSide: const BorderSide(color: Colors.blue, width: 2), // or your primary color
                        ),
                        // Red borders for error state
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFC12222), width: 1.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFC12222), width: 2),
                        ),
                      ),
                      items: controller.roles
                          .map((role) => DropdownMenuItem(
                        value: role,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(role, overflow: TextOverflow.ellipsis),
                        ),
                      ))
                          .toList(),
                      onChanged: (_) {}, // Blocked by AbsorbPointer anyway
                      // Validation: triggers red border and errorText from _buildValidatedDropdown
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Role is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              )),

              //const SizedBox(height: 10),

              // ---------------- Job Title ----------------
              const Text(
                'Job Title *',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),


              TextFormField(
                controller: _jobTitleTEController,
                focusNode: _jobTitleFocusNode,
                onChanged: (value) => controller.jobTitle.value = value,
                textInputAction: TextInputAction.next,
                decoration: context.primaryInputDecoration.copyWith(
                  hintText: "Enter job title", // Keep your leading spaces in hint if desired
                  hintStyle: const TextStyle(
                    color: Color(0xFF787878),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  // Set horizontal content padding to 0 (or minimal) for the text area
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 14,
                  ),
                  // Add invisible prefix space for the input text/cursor indent
                  prefix: const SizedBox(width: 8), // Adjust this value as needed (e.g., 16-24 for more space)
                  errorStyle: const TextStyle(
                    height: 1.5,
                    color: Color(0xFFC12222),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Job title is required';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10),

              const Text(
                'Department *',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _departmentTEController,
                focusNode: _departmentFocusNode,
                onChanged: (value) => controller.department.value = value,
                textInputAction: TextInputAction.next,
                decoration: context.primaryInputDecoration.copyWith(
                  hintText: "Enter department",
                  hintStyle: const TextStyle(
                    color: Color(0xFF787878),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                    // Set horizontal content padding to 0 (or minimal) for the text area
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 14,
                    ),
                    // Add invisible prefix space for the input text/cursor indent
                    prefix: const SizedBox(width: 8),
                  errorStyle: const TextStyle(height: 1.5, color: Color(
                      0xFFC12222)),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Department is required';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10),
              FormField(
                validator: (_) {
                  if (countryCityController.selectedCountry.value == null ||
                      countryCityController.selectedCity.value == null) {
                    return 'Country and City are required';
                  }
                  return null;
                },
                builder: (state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CountryCitySearchableDropdown(controller: countryCityController),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            state.errorText!,
                            style: TextStyle(color: Color(0xFFC12222), fontSize: 12),
                          ),
                        ),
                    ],
                  );
                },
              ),

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
                  controller: _vacanciesTEController,
                  focusNode: _vacanciesFocusNode,
                  onChanged: (value) => controller.vacancies.value = value,
                  keyboardType: TextInputType.number,
                  decoration: context.primaryInputDecoration.copyWith(
                    hintText: _vacanciesTEController.text,
                    suffixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //Increment Button
                        GestureDetector(
                          onTap: () {
                            int value =
                                int.tryParse(_vacanciesTEController.text) ?? 0;
                            if (value < 50) {
                              value++;
                              _vacanciesTEController.text = value.toString();
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
                                int.tryParse(_vacanciesTEController.text) ?? 0;
                            if (value > 1) {
                              value--;
                              _vacanciesTEController.text = value.toString();
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
                    hintText: '  Select employment type',
                    hintStyle: const TextStyle(
                      color: Color(0xFF787878),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                      // Set horizontal content padding to 0 (or minimal) for the text area
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 14,
                      ),
                      // Add invisible prefix space for the input text/cursor indent
                      prefix: const SizedBox(width: 8),
                    // Optional: also tighten error spacing if needed
                    errorStyle: const TextStyle(height: 1.5, color: Color(
                        0xFFC12222)),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Employment type is required';
                    }
                    return null;
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
                  value: experienceLevelController.selectedExperienceLevel.value.isEmpty
                      ? null
                      : experienceLevelController.selectedExperienceLevel.value,
                  decoration: InputDecoration(
                    hintText: '  Select experience level',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                      // Set horizontal content padding to 0 (or minimal) for the text area
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 14,
                      ),
                      // Add invisible prefix space for the input text/cursor indent
                      prefix: const SizedBox(width: 8),
                    // Optional: also tighten error spacing if needed
                    errorStyle: const TextStyle(height: 1.5, color: Color(
                        0xFFC12222)),
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
                    experienceLevelController.selectedExperienceLevel.value = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Experience level is required';
                    }
                    return null;
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
                    hintText: '  Select location type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),

                      // Set horizontal content padding to 0 (or minimal) for the text area
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 14,
                      ),
                      // Add invisible prefix space for the input text/cursor indent
                      prefix: const SizedBox(width: 8),
                    // Optional: also tighten error spacing if needed
                    errorStyle: const TextStyle(height: 1.5, color: Color(
                        0xFFC12222)),
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
                    locationTypeController.selectedLocationType.value = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Location type is required';
                    }
                    return null;
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
                    hintText: '  Select career stage',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 14,
                    ),
                    // Add invisible prefix space for the input text/cursor indent
                    prefix: const SizedBox(width: 8),
                    // Optional: also tighten error spacing if needed
                    errorStyle: const TextStyle(height: 1.5, color: Color(
                        0xFFC12222)),
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
                  // Added validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Career stage is required';
                    }
                    return null; // Return null if validation passes
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

                    final selected = await showModalBottomSheet<GetCurrencyResponseModel>(
                          context: context,
                          isScrollControlled: true,
                          builder: (ctx) {
                            final searchController = TextEditingController();
                            final filteredCurrencies =
                                RxList<GetCurrencyResponseModel>(
                                  controller.currencies,
                                );

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                              ),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: searchController,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                      hintText: 'Search currency',
                                    ),
                                    onChanged: (value) {
                                      filteredCurrencies.assignAll(
                                        controller.currencies
                                            .where(
                                              (c) =>
                                                  c.currencyName
                                                      .toLowerCase()
                                                      .contains(
                                                        value.toLowerCase(),
                                                      ) ||
                                                  c.symbol.toLowerCase().contains(
                                                    value.toLowerCase(),
                                                  ) ||
                                                  c.code.toLowerCase().contains(
                                                    value.toLowerCase(),
                                                  ),
                                            )
                                            .toList(),
                                      );
                                    },
                                  ),
                                  Obx(
                                    () => Expanded(
                                      child: ListView.builder(
                                        itemCount: filteredCurrencies.length,
                                        itemBuilder: (_, index) {
                                          final c = filteredCurrencies[index];
                                          return ListTile(
                                            title: Text(
                                              '${c.currencyName} (${c.symbol})',
                                            ),
                                            onTap: () => Navigator.pop(ctx, c),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                    if (selected != null) {
                      controller.selectedCurrency.value = selected;

                      // Automatically focus the compensation field
                      _compensationFocusNode.requestFocus();
                    }
                  },
                  child: AbsorbPointer(
                    child: DropdownButtonFormField<GetCurrencyResponseModel>(
                      isExpanded: true,
                      value: controller.selectedCurrency.value,
                      hint: const Text('Select currency'),
                      decoration: _dropdownDecoration().copyWith(
                        contentPadding: const EdgeInsets.fromLTRB(8, 16, 12, 16),
                      ),
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
                  controller: _compensationTEController,
                  focusNode: _compensationFocusNode,
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
                  value: jobPostingExpirationController.selectedJobPostingExpiration.value.isEmpty
                      ? null
                      : jobPostingExpirationController.selectedJobPostingExpiration.value,
                  decoration: InputDecoration(
                    hintText: jobPostingExpirationController.jobPostingExpiration[2],
                    hintStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 14,
                    ),
                    // Invisible prefix space for better text/cursor alignment
                    prefix: const SizedBox(width: 8),
                    // Better error message styling
                    errorStyle: const TextStyle(
                      height: 1.5,
                      color: Color(0xFFC12222),
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
                    jobPostingExpirationController.selectedJobPostingExpiration.value = value ?? '';
                  },
                  // ← Added required validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Job posting expiration is required';
                    }
                    return null;
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
                controller: _companyWebTEController,
                focusNode: _companyWebFocusNode,
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

              const SizedBox(height: 40),

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
                      onPressed: () {Get.back();},
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
                    decoration: BoxDecoration(
                      color: Color(0xFF2B7FD0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.nextStep();
                        }
                        // Optional: Scroll to first error
                        else {
                          Get.snackbar('Validation Error', 'Please fill all required fields',
                              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                      ),
                      child: Text(
                        'Next',
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
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Dropdown Decoration ----------------
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFC12222), width: 1),
      ),
      // focusedBorder: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(8),
      //   borderSide: const BorderSide(color: Color(0xFF787878), width: 1),
      // ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 0,  // Reduce this value (default is often 16–20)
        vertical: 14,
      ),
      // Optional: also tighten error spacing if needed
      errorStyle: const TextStyle(height: 1.5, color: Color(
          0xFFC12222)),
    );
  }

  void showSearchableBottomSheet<T>(
    BuildContext context, {
    required String title,
    required List<T> items,
    required void Function(T) onSelect,
  }) {
    final TextEditingController searchController = TextEditingController();
    final RxList<T> filteredItems = RxList<T>(List.from(items));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                // Sheet title
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 4),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),

                // Search field
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search $title',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    final query = value.toLowerCase();

                    // Filter items based on type
                    if (T == GetCurrencyResponseModel) {
                      filteredItems.assignAll(
                        items.where((item) {
                          final currency = item as GetCurrencyResponseModel;
                          return currency.currencyName.toLowerCase().contains(
                                query,
                              ) ||
                              currency.symbol.toLowerCase().contains(query) ||
                              currency.code.toLowerCase().contains(query);
                        }).toList(),
                      );
                    } else {
                      filteredItems.assignAll(
                        items.where((item) {
                          return item.toString().toLowerCase().contains(query);
                        }).toList(),
                      );
                    }
                  },
                ),

                const SizedBox(height: 8),

                // List of filtered items
                Expanded(
                  child: Obx(() {
                    if (filteredItems.isEmpty) {
                      return const Center(child: Text('No items found'));
                    }
                    return ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return ListTile(
                          title: Text(
                            item is GetCurrencyResponseModel
                                ? '${item.currencyName} (${item.symbol})'
                                : item.toString(),
                          ),
                          onTap: () {
                            onSelect(item);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildValidatedDropdown({
    required String label,
    required String? currentValue,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label *',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 6),
        child,
        // Hidden validator field with tight error message
        SizedBox(
          height: 10, // Controls the space for error message
          child: TextFormField(
            initialValue: currentValue ?? '',
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
              errorStyle: TextStyle(
                fontSize: 12,
                height: 0.8, // Reduces vertical space taken by error text
                color: Color(0xFFC12222),
              ),
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
            style: const TextStyle(
              height: 0,
              color: Colors.transparent,
            ),
          ),
        ),
      ],
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
}
