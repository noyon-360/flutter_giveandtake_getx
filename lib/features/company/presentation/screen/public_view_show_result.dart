import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/features/recruiter_account/presentation/screens/recruiter_public_view.dart';

import '../controller/company_details_controller.dart';
import '../widget/user_card_widget.dart';
import 'public_view_seach_screen.dart';
import '../../../public_view/screens/public_view_candidate_screens.dart';

class PublicViewShowResultScreen extends StatelessWidget {
  PublicViewShowResultScreen({super.key});

  final controller = Get.find<CompanyDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Search Results",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              /// Result Count
              Obx(() {
                final count = controller.filteredSearchInfo.length;
                final immediateCount = controller.immediateCount;
                return Text(
                  "$count users found · $immediateCount immediate",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),

              //  Obx(() => Text(
              //       "${controller.users.length} user found · ${controller.isImmediate.value ? 1 : 0} immediate",
              //       style: const TextStyle(
              //           fontSize: 14, fontWeight: FontWeight.w500),
              //     )),
              const SizedBox(height: 12),

              /// Search Field
              TextField(
                onChanged: (val) {
                  controller.searchQuery.value = val;
                  controller.searchUsers(val);
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// Filter Row
              Row(
                children: [
                  /// Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Obx(
                      () => DropdownButton<String>(
                        value: controller.selectedRole.value,
                        underline: const SizedBox(),
                        items:
                            ["All Roles", "candidate", "recruiter", "company"]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            controller.updateRole(val);
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Immediate Button
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        controller.toggleImmediate();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: controller.isImmediate.value
                              ? Colors.green.shade50
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: controller.isImmediate.value
                                ? Colors.green
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 18,
                              color: controller.isImmediate.value
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Immediate (${controller.isImmediate.value ? 'only' : 'off'})",
                              style: TextStyle(
                                color: controller.isImmediate.value
                                    ? Colors.green
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// User List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final users = controller.filteredSearchInfo;

                  if (users.isEmpty) {
                    return const Center(child: Text("No users found"));
                  }

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (_, index) {
                      final user = users[index];
                      return UserCard(
                        user: user,
                        onTap: () {
                          final slug = user.slug;

                          if (slug == null || slug.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'This user has no public profile',
                            );
                            return;
                          }

                          final role = user.role.toLowerCase();

                          if (role == 'candidate') {
                            Get.to(() => PublicViewCandidateScreen(slug: slug));
                          } else if (role == 'recruiter') {
                            Get.to(() => RecruiterPublicViewScreen(slug: slug));
                          } else {
                            Get.to(() => PublicViewSeachScreen(slug: slug));
                          }
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
