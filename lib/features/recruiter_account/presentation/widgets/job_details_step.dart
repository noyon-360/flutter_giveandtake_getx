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
import '../controller/job_posting _controller.dart';
import 'country_city_searchable_dropdown.dart';

class JobDetailsStep extends StatelessWidget {
   JobDetailsStep({super.key});
  final controller = Get.find<JobPostingController>();

  @override
  Widget build(BuildContext context) {

    // Fetch currencies if not already fetched
    // Load currencies if not already loaded
    if (controller.currencies.isEmpty) {
      controller.loadCurrenciesIfEmpty();
    }

    TextEditingController _jobTitleTEController = TextEditingController();
    final FocusNode _jobTitleFocusNode = FocusNode();

    TextEditingController _departmentTEController = TextEditingController();
    final FocusNode _departmentFocusNode = FocusNode();

    TextEditingController _vacanciesTEController = TextEditingController(text: '1');
    final FocusNode _vacanciesFocusNode = FocusNode();

    TextEditingController _compensationTEController = TextEditingController();
    final FocusNode _compensationFocusNode = FocusNode();

    final LocationController countryCityController = Get.put(LocationController());

    // Listen to selectedRole changes and update Job Title if empty
    ever(controller.selectedRole, (String role) {
      if (_jobTitleTEController.text.isEmpty && role.isNotEmpty) {
        _jobTitleTEController.text = role;
      }
    });

    final EmploymentTypeController employeeController = Get.put(EmploymentTypeController());
    final ExperienceLevelController experienceLevelController = Get.put(ExperienceLevelController());
    final LocationTypeController locationTypeController = Get.put(LocationTypeController());
    final CareerStageController careerStageController = Get.put(CareerStageController());
    final JobPostingExpirationController jobPostingExpirationController = Get.put(JobPostingExpirationController());

    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                        child: Text(
                          role,
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

            // ---------------- Job Title ----------------
            const Text(
              'Job Title *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _jobTitleTEController,
              focusNode: _jobTitleFocusNode,
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

            SizedBox(height: 10,),
            const Text(
              'Department *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _departmentTEController,
              focusNode: _departmentFocusNode,
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

            SizedBox(height: 10,),
            CountryCitySearchableDropdown(controller: countryCityController),

            SizedBox(height: 10,),
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
                        int value = int.tryParse(_vacanciesTEController.text) ?? 0;
                        if (value < 50) {
                          _vacanciesTEController.text = "${value + 1}";
                        }
                      },
                      child: Container(
                        height: 17,
                        width: 22,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(width: 1, color: Colors.grey.shade300),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.arrow_drop_up, size: 16, color: Colors.black),
                        ),
                      ),
                    ),

                    SizedBox(height: 3,),
                    //Removed SizedBox, now only 1-pixel border gap
                    GestureDetector(
                      onTap: () {
                        int value = int.tryParse(_vacanciesTEController.text) ?? 0;
                        if (value > 1) {
                          _vacanciesTEController.text = "${value - 1}";
                        }
                      },
                      child: Container(
                        height: 17,
                        width: 22,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(width: 1, color: Colors.grey.shade300),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.arrow_drop_down, size: 16, color: Colors.black),
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
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 10,),

            const Text(
              'Employment Type *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6,),

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

            SizedBox(height: 10,),

            const Text(
              'Experience Level*',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6,),
            Obx(
                  () => DropdownButtonFormField<String>(
                isExpanded: true,
                value: experienceLevelController.selectedExperienceLevel.value.isEmpty
                    ? null
                    : experienceLevelController.selectedExperienceLevel.value,
                decoration: InputDecoration(
                  hintText: 'Select experience level',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                items: experienceLevelController.experienceLevel
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
              ),
            ),

            SizedBox(height: 10,),
            const Text(
              'Location Type*',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 6,),

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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                items: locationTypeController.locationType
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
              ),
            ),


            SizedBox(height: 10,),
            const Text(
              'Career Stage*',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 6,),

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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                items: careerStageController.careerStage
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

              final selected = await showModalBottomSheet<GetCurrencyResponseModel>(
                context: context,
                isScrollControlled: true,
                builder: (ctx) {
                  final searchController = TextEditingController();
                  final filteredCurrencies = RxList<GetCurrencyResponseModel>(controller.currencies);

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
                            filteredCurrencies.assignAll(controller.currencies
                                .where((c) => c.currencyName.toLowerCase().contains(value.toLowerCase())
                                || c.symbol.toLowerCase().contains(value.toLowerCase())
                                || c.code.toLowerCase().contains(value.toLowerCase()))
                                .toList());
                          },
                        ),
                        Obx(() => Expanded(
                          child: ListView.builder(
                            itemCount: filteredCurrencies.length,
                            itemBuilder: (_, index) {
                              final c = filteredCurrencies[index];
                              return ListTile(
                                title: Text('${c.currencyName} (${c.symbol})'),
                                onTap: () => Navigator.pop(ctx, c),
                              );
                            },
                          ),
                        )),
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
                decoration: _dropdownDecoration(),
                items: controller.currencies.map((currency) {
                  return DropdownMenuItem(
                    value: currency,
                    child: Text('${currency.currencyName} (${currency.symbol})'),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
            ),
          );
        }),

        SizedBox(height: 10,),
          Text('Compensation (Optional)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
          SizedBox(height: 6,),

            Obx(() {
              final selectedCurrency = controller.selectedCurrency.value;

              return TextFormField(
                controller: _compensationTEController,
                focusNode: _compensationFocusNode,
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
            
            SizedBox(height: 10,),
            Text('Job Posting Expiration (Days)*', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
            SizedBox(height: 6,),

            Obx(
                  () => DropdownButtonFormField<String>(
                isExpanded: true,
                value: jobPostingExpirationController.selectedJobPostingExpiration.value.isEmpty
                    ? null
                    : jobPostingExpirationController.selectedJobPostingExpiration.value,
                decoration: context.primaryInputDecoration.copyWith(
                  hintText: jobPostingExpirationController.jobPostingExpiration[2],
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
                      ),
                    ),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  jobPostingExpirationController.selectedJobPostingExpiration.value = value ?? '';
                },
              ),
            ),


            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: controller.nextStep,
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
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
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF787878), width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
                       filteredItems.assignAll(items.where((item) {
                         final currency = item as GetCurrencyResponseModel;
                         return currency.currencyName
                             .toLowerCase()
                             .contains(query) ||
                             currency.symbol.toLowerCase().contains(query) ||
                             currency.code.toLowerCase().contains(query);
                       }).toList());
                     } else {
                       filteredItems.assignAll(items.where((item) {
                         return item.toString().toLowerCase().contains(query);
                       }).toList());
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
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (query) {
                        filteredItems.assignAll(
                          items
                              .where((item) => item.toLowerCase().contains(query.toLowerCase()))
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
