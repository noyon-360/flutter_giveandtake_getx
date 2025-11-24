import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';
import 'package:karlfive/features/company/domain/repo/company_repo.dart';

import '../../data/model/all_user_response_model.dart';

class CompanyAccountController extends BaseController {
  final CompanyRepository _companyRepo;

  CompanyAccountController(this._companyRepo);
  var recruiters = <AllUserResponseModel>[].obs;

  // Form Key
  final formKey = GlobalKey<FormState>();

  // Text Controllers (normal fields)
  final aboutUsController = TextEditingController();
  final companyNameController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final postalCodeController = TextEditingController();
  final emailController = TextEditingController();
  final contactNumberController = TextEditingController();
  final websiteController = TextEditingController();
  final linkedInController = TextEditingController();
  final twitterController = TextEditingController();
  final upworkController = TextEditingController();
  final otherWebsiteController = TextEditingController();
  final awardTitleController = TextEditingController();
  final issuerController = TextEditingController();
  final issueDateController = TextEditingController();
  final awardDescriptionController = TextEditingController();
  final addMoreLinksController = TextEditingController();
  final otherWebsiteController2 = TextEditingController();
  final TextEditingController industryController = TextEditingController();

  // Observables
  var elevatorVideoPath = RxnString();

  // 🔥 Dynamic services list (controllers for each field)
  var serviceControllers = <TextEditingController>[].obs;
  var employeeControllers = <TextEditingController>[].obs;
  var awardFields = <Map<String, TextEditingController>>[].obs;

  // Employees, Awards, Links
  var employees = <String>[].obs;
  var awards = <Map<String, String>>[].obs;
  var additionalLinks = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Start with one service field
    serviceControllers.add(TextEditingController());
    employeeControllers.add(TextEditingController());
  }

  // --- Service Management ---
  void addServiceField() {
    serviceControllers.add(TextEditingController());
  }

  void removeServiceField(int index) {
    if (serviceControllers.length > 1) {
      serviceControllers[index].dispose();
      serviceControllers.removeAt(index);
    }
  }

  List<String> getServices() {
    return serviceControllers
        .map((c) => c.text.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  // --- Awards ---
  // void addAward() {
  //   if (awardTitleController.text.isNotEmpty &&
  //       issuerController.text.isNotEmpty &&
  //       issueDateController.text.isNotEmpty &&
  //       awardDescriptionController.text.isNotEmpty) {
  //     awards.add({
  //       'title': awardTitleController.text,
  //       'issuer': issuerController.text,
  //       'date': issueDateController.text,
  //       'description': awardDescriptionController.text,
  //     });
  //     awardTitleController.clear();
  //     issuerController.clear();
  //     issueDateController.clear();
  //     awardDescriptionController.clear();
  //   }
  // }

  void addAwardField() {
    awardFields.add({
      'title': TextEditingController(),
      'issuer': TextEditingController(),
      'date': TextEditingController(),
      'description': TextEditingController(),
    });
  }

  // Remove award fields
  void removeAwardField(int index) {
    final fields = awardFields[index];
    fields['title']?.dispose();
    fields['issuer']?.dispose();
    fields['date']?.dispose();
    fields['description']?.dispose();
    awardFields.removeAt(index);
  }

  List<Map<String, String>> getAwards() {
    return awardFields.map((fields) {
      return {
        'title': fields['title']?.text ?? "",
        'issuer': fields['issuer']?.text ?? "",
        'date': fields['date']?.text ?? "",
        'description': fields['description']?.text ?? "",
      };
    }).toList();
  }

  // --- Employees ---
  void addEmployee() {
    employeeControllers.add(TextEditingController());
  }

  // Remove employee field
  void removeEmployeeField(int index) {
    if (employeeControllers.length > 1) {
      employeeControllers[index].dispose();
      employeeControllers.removeAt(index);
    }
  }

  // Get employee values
  List<String> getEmployees() {
    return employeeControllers
        .map((c) => c.text.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  // --- Video Upload ---
  void uploadElevatorVideo() {
    elevatorVideoPath.value = "dummy_video_path.mp4";
  }

  // --- Links ---
  void addMoreLinks() {
    if (addMoreLinksController.text.isNotEmpty) {
      additionalLinks.add(addMoreLinksController.text.trim());
      addMoreLinksController.clear();
      Get.snackbar(
        'Success',
        'Link added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        'Please enter a valid link',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeLink(int index) {
    additionalLinks.removeAt(index);
  }

  // --- Save Form ---
  void saveForm() {
    if (formKey.currentState!.validate()) {
      Get.snackbar(
        'Success',
        'Company profile saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    // Dispose all text controllers
    aboutUsController.dispose();
    companyNameController.dispose();
    countryController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    websiteController.dispose();
    linkedInController.dispose();
    twitterController.dispose();
    upworkController.dispose();
    otherWebsiteController.dispose();
    awardTitleController.dispose();
    issuerController.dispose();
    issueDateController.dispose();
    awardDescriptionController.dispose();
    addMoreLinksController.dispose();
    otherWebsiteController2.dispose();

    // Dispose service controllers
    for (var c in serviceControllers) {
      c.dispose();
    }

    for (var c in employeeControllers) {
      c.dispose();
    }

    super.onClose();
  }

  Future<void> fetchUsers() async {
    setLoading(true);
    setError('');

    final result = await _companyRepo.fetchAllUsers();

    result.fold(
      (fail) {
        setError(fail.message);
        setLoading(false);
      },
      (success) {
        setLoading(false);

        if (success.data == null || success.data.isEmpty) {
          setError("No users found");
          recruiters.clear();
          return;
        }

        // Just store all users
        recruiters.clear();
        recruiters.addAll(success.data);

        // Show in BottomSheet
        _showUserBottomSheet();
      },
    );
  }

  // BottomSheet to select any user
  void _showUserBottomSheet() {
    final searchController = TextEditingController();

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      Container(
        height: Get.height * 0.8, // 80% of screen
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Select Recruiter",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Search Bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search by name or email...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (_) => recruiters.refresh(),
            ),
            const SizedBox(height: 16),

            // User List - This takes remaining space
            Expanded(
              child: Obx(() {
                final query = searchController.text.toLowerCase();

                // FILTER: Only recruiters + search match
                final filtered = recruiters.where((user) {
                  final name = (user.name ?? "").toLowerCase();
                  final email = (user.email ?? "").toLowerCase();
                  final role = (user.role ?? "").toLowerCase();

                  return role == "recruiter" &&
                      (name.contains(query) || email.contains(query));
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          query.isEmpty
                              ? "No recruiters found"
                              : "No recruiter matches '$query'",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final user = filtered[index];
                    final displayText = "${user.name} (${user.email})";

                    final isAlreadyAdded = employeeControllers.any(
                      (c) => c.text.contains(user.email),
                    );

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        enabled: !isAlreadyAdded,
                        leading: CircleAvatar(
                          backgroundImage: user.avatarUrl.isNotEmpty
                              ? NetworkImage(user.avatarUrl)
                              : null,
                          child: user.avatarUrl.isEmpty
                              ? Text(
                                  user.name.isNotEmpty
                                      ? user.name[0].toUpperCase()
                                      : "R",
                                )
                              : null,
                        ),
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        trailing: isAlreadyAdded
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : const Icon(Icons.add_circle_outline),
                        onTap: isAlreadyAdded
                            ? null
                            : () {
                                final emptyCtrl = employeeControllers
                                    .firstWhere(
                                      (c) => c.text.isEmpty,
                                      orElse: () => employeeControllers.last,
                                    );
                                emptyCtrl.text = displayText;
                                Get.back();
                                Get.snackbar(
                                  "Added",
                                  "$displayText added as recruiter",
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
