import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/recruiter_controller.dart';

/// Full-page version of the old "Connect with a Company" dialog.
/// On success [RecruiterController.connectCompany] calls Get.back(), which pops
/// this page back to the recruiter dashboard.
class ConnectCompanyPage extends StatelessWidget {
  final RecruiterController controller = Get.find<RecruiterController>();

  ConnectCompanyPage({super.key});

  static const Color _primary = Color(0xFF2B7FD0);

  @override
  Widget build(BuildContext context) {
    // Initialize search query if not already
    controller.companySearchQuery ??= ''.obs;

    void submit() {
      controller.connectCompany(controller.selectedCompany.value.toString());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Connect with a Company',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.companies.isEmpty) {
            return const Center(child: Text('No company found'));
          }

          // Filter companies based on search query
          final query =
              controller.companySearchQuery?.value.toLowerCase() ?? '';
          final filteredCompanies = controller.companies
              .where((c) => c.cname.toLowerCase().contains(query))
              .toList();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select a company to connect with as an employee.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
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
                  child: filteredCompanies.isEmpty
                      ? const Center(child: Text('No matching company'))
                      : ListView.builder(
                          itemCount: filteredCompanies.length,
                          itemBuilder: (context, index) {
                            final company = filteredCompanies[index];

                            return Obx(() {
                              final isSelected =
                                  company.id == controller.selectedCompany.value;

                              return InkWell(
                                onTap: () => controller.selectedCompany.value =
                                    company.id,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? _primary.withOpacity(0.1)
                                        : Colors.white,
                                    border: Border.all(
                                      color: isSelected
                                          ? _primary
                                          : Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          company.clogo,
                                        ),
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
                                                ? _primary
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(Icons.check, color: _primary),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                ),

                const SizedBox(height: 8),

                /// --- Action Buttons ---
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: _primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: _primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.selectedCompany.value != null) {
                            submit();
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please select a company first.',
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Connect',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
