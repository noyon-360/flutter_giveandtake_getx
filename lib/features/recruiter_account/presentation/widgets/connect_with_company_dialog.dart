import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/recruiter_controller.dart';

class ConnectCompanyDialog extends StatelessWidget {
  final RecruiterController controller = Get.find<RecruiterController>();

  ConnectCompanyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize search query if not already
    controller.companySearchQuery ??= ''.obs;

    _submit(){
      controller.connectCompany(controller.selectedCompany.value.toString());
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 505,
          height: 606,
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.companies.isEmpty) {
              return const Center(child: Text('No company found'));
            }

            // Filter companies based on search query
            final filteredCompanies = controller.companies.where((c) {
              final query = controller.companySearchQuery?.value.toLowerCase();
              return c.cname.toLowerCase().contains(query!);
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// --- Header ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Connect with a Company',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select a company to connect with as an employee.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),

                /// --- Search Bar ---
                TextField(
                  onChanged: (value) =>
                      controller.companySearchQuery!.value = value,
                  decoration: InputDecoration(
                    hintText: 'Search Company by Name...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                /// --- Available company count ---
                Text(
                  '${filteredCompanies.length} companies available',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),

                /// --- Company list ---
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCompanies.length,
                    itemBuilder: (context, index) {
                      final company = filteredCompanies[index];

                      return Obx(() {
                        final isSelected =
                            company.id == controller.selectedCompany.value;

                        return InkWell(
                          onTap: () =>
                              controller.selectedCompany.value = company.id,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF2B7FD0).withOpacity(0.1)
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF2B7FD0)
                                    : Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(company.clogo),
                                  radius: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    company.cname,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? const Color(0xFF2B7FD0)
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check,
                                    color: Color(0xFF2B7FD0),
                                  ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),

                /// --- Action Buttons ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (controller.selectedCompany.value != null) {
                          _submit();
                        } else {
                          Get.snackbar(
                            'Error',
                            'Please select a company first.',
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B7FD0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Connect',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
