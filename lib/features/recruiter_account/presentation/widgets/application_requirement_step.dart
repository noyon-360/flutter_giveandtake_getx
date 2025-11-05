import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';
import '../controller/country_city_controller.dart';
import '../controller/job_controller/employment_type_controller.dart';
import '../controller/job_posting _controller.dart';
import 'country_city_searchable_dropdown.dart';

class JobDetailsStep extends StatelessWidget {
  JobDetailsStep({super.key});
  final EmploymentTypeController employeeController = Get.put(EmploymentTypeController());

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobPostingController>();

    TextEditingController _jobTitleTEController = TextEditingController();
    final FocusNode _jobTitleFocusNode = FocusNode();

    TextEditingController _departmentTEController = TextEditingController();
    final FocusNode _departmentFocusNode = FocusNode();

    TextEditingController _vacanciesTEController = TextEditingController(text: '1');
    final FocusNode _vacanciesFocusNode = FocusNode();

    final LocationController countryCityController = Get.put(LocationController());

    // Listen to selectedRole changes and update Job Title if empty
    ever(controller.selectedRole, (String role) {
      if (_jobTitleTEController.text.isEmpty && role.isNotEmpty) {
        _jobTitleTEController.text = role;
      }
    });



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
                      // ⬆️ Increment Button
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
            const SizedBox(height: 6),
            Obx(
                  () => InkWell(
                onTap: () {
                  _showEmploymentTypeBottomSheet(context);
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    hintText: 'Select employment type',
                    hintStyle: const TextStyle(
                      color: Color(0xFF787878),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ),
                  child: Text(
                    employeeController.selectedEmploymentType.value.isEmpty
                        ? 'Select employment type'
                        : employeeController.selectedEmploymentType.value,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
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

  // ---------------- Searchable Bottom Sheet ----------------
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


  void _showEmploymentTypeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: employeeController.employmentTypes.length,
          itemBuilder: (context, index) {
            final type = employeeController.employmentTypes[index];
            return ListTile(
              title: Text(
                type,
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                employeeController.selectedEmploymentType.value = type;
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
