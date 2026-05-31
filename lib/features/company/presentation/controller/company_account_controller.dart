import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutx_core/core/debug_print.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/base/base_controller.dart';
import 'package:giveandtake/core/contracts/web/recruiter_company_contract.dart';
import 'package:giveandtake/features/company/data/model/manage_job_response_model.dart';
import 'package:giveandtake/features/company/data/model/recruiter_added_response_model.dart';
import 'package:giveandtake/features/company/data/model/single_Company_response_model.dart';
import 'package:giveandtake/features/company/domain/repo/company_repo.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/recruiter_controller.dart';

import '../../../../core/network/services/auth_storage_service.dart';
import '../../../../core/network/services/multiple_form_data_manager.dart';
import '../../data/model/all_user_response_model.dart';
import '../../data/model/recruiter_added_request_model.dart';
import '../screen/company_details_screen.dart';
import '../screen/company_screen.dart';
import '../screen/employee_screen.dart';

class CompanyAccountController extends BaseController {
  final CompanyRepository _companyRepo;
  final AuthStorageService _authStorageService;

  CompanyAccountController(this._companyRepo, this._authStorageService);
  var recruiters = <AllUserResponseModel>[].obs;
  final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();

  final Rxn<SingleCompanyResponseModel> userInfo =
      Rxn<SingleCompanyResponseModel>();
  final manageJobList = <ManageJobResponseModel>[].obs;
  final Rxn<RecruiterAddedResponseModel> selectedRecruiter =
      Rxn<RecruiterAddedResponseModel>();

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
  Map<TextEditingController, String> employeeIdMap = {};

  // Employees, Awards, Links
  var employees = <String>[].obs;
  var awards = <Map<String, String>>[].obs;
  var additionalLinks = <String>[].obs;
  final selectedCompany = RxnString();
  var selectedCity = RxnString();

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
    return awardFields
        .map((fields) {
          final rawDate = fields['date']?.text.trim() ?? "";

          String isoDate = "";
          if (rawDate.length == 6) {
            final month = rawDate.substring(0, 2);
            final year = rawDate.substring(2);
            isoDate =
                "$year-$month-01T00:00:00.000Z"; // e.g., 202512 → 2025-12-01T00:00:00.000Z
          }

          return {
            "title": fields['title']?.text.trim() ?? "",
            "programeName":
                fields['issuer']?.text.trim() ??
                "", // ← programeName (not programName)
            "programeDate": isoDate,
            "description": fields['description']?.text.trim() ?? "",
          };
        })
        .where(
          (award) =>
              award["title"]!.isNotEmpty || award["description"]!.isNotEmpty,
        )
        .toList();
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
  // void onClose() {
  //   // Dispose all text controllers
  //   aboutUsController.dispose();
  //   companyNameController.dispose();
  //   countryController.dispose();
  //   cityController.dispose();
  //   postalCodeController.dispose();
  //   emailController.dispose();
  //   contactNumberController.dispose();
  //   websiteController.dispose();
  //   linkedInController.dispose();
  //   twitterController.dispose();
  //   upworkController.dispose();
  //   otherWebsiteController.dispose();
  //   awardTitleController.dispose();
  //   issuerController.dispose();
  //   issueDateController.dispose();
  //   awardDescriptionController.dispose();
    
  //   addMoreLinksController.dispose();
  //   otherWebsiteController2.dispose();

  //   // Dispose service controllers
  //   for (var c in serviceControllers) {
  //     c.dispose();
  //   }

  //   for (var c in employeeControllers) {
  //     c.dispose();
  //   }

  //   super.onClose();
  // }

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

                                // Display name in the text field
                                emptyCtrl.text = user.name;

                                // Store ID in the map
                                employeeIdMap[emptyCtrl] = user.id;

                                Get.back();
                                Get.snackbar(
                                  "Added",
                                  "${user.name} added as recruiter",
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

  Future<void> createCompanyScreen(
    File banner,
    File clogo,
    String cname,
    String country,
    String city,
    int zipCode,
    String cemail,
    String aboutUs,
    String industry,
    String linkedIn,
    String twitter,
    String upwork,
    String facebook,
    String tiktok,
    String instagram,
    String fiverr,
    String companyWebsite,
    String services,
    String recruiters,
  ) async {
    setLoading(true);
    setError('');

    if (Get.isRegistered<RecruiterController>() &&
        !Get.find<RecruiterController>().successVideoUploaded.value) {
      setError('Upload elevator pitch before creating a company profile.');
      Get.snackbar(
        'Elevator Pitch Required',
        'Please upload your elevator pitch before creating the company profile.',
      );
      setLoading(false);
      return;
    }

    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found.');
      setLoading(false);
      return;
    }

    final payload = CompanyPayloadBuilder.build(
      CompanyAccountInput(
        userId: userId,
        cname: cname,
        cemail: cemail,
        aboutUs: aboutUs,
        industry: industry,
        country: country,
        city: city,
        zipcode: zipCode.toString(),
        service: getServices(),
        employeesId: _resolveEmployeeIds(),
        awardsAndHonors: _buildCompanyHonors(),
        socialLinks: _buildCompanySocialLinks(
          linkedIn: linkedIn,
          twitter: twitter,
          upwork: upwork,
          facebook: facebook,
          tiktok: tiktok,
          instagram: instagram,
          fiverr: fiverr,
          companyWebsite: companyWebsite,
        ),
        clogo: clogo,
        banner: banner,
      ),
    );

    final result = await _companyRepo.createCompany(await payload.toFormData());

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("Create Company Failed: ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("Company Created: ${success.message}");
        Get.snackbar("Success", "Company created successfully!");
        Get.off(() => CompanyDetailsPage());
        setLoading(false);
      },
    );
  }

  Future<void> updateCompany(
    String companyId,
    File? banner,
    File? clogo,
    String cname,
    String country,
    String city,
    int zipCode,
    String cemail,
    String aboutUs,
    String industry,
    String linkedIn,
    String twitter,
    String upwork,
    String facebook,
    String tiktok,
    String instagram,
    String fiverr,
    String companyWebsite,
    String services,
    String recruiters,
    String awardsJson,
  ) async {
    setLoading(true);
    setError('');

    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found.');
      setLoading(false);
      return;
    }

    final payload = CompanyPayloadBuilder.build(
      CompanyAccountInput(
        userId: userId,
        cname: cname,
        cemail: cemail,
        aboutUs: aboutUs,
        industry: industry,
        country: country,
        city: city,
        zipcode: zipCode.toString(),
        service: getServices(),
        employeesId: _resolveEmployeeIds(),
        awardsAndHonors: _buildCompanyHonors(),
        socialLinks: _buildCompanySocialLinks(
          linkedIn: linkedIn,
          twitter: twitter,
          upwork: upwork,
          facebook: facebook,
          tiktok: tiktok,
          instagram: instagram,
          fiverr: fiverr,
          companyWebsite: companyWebsite,
        ),
        clogo: clogo,
        banner: banner,
      ),
    );

    final result = await _companyRepo.updateCompanyInfo(
      companyId,
      await payload.toFormData(),
    );

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log('Update Company: ${fail.message}');
        setLoading(false);
      },
      (success) async {
        DPrint.log('Update Company: ${success.message}');
        Get.to(() => CompanyDetailsPage());
        setLoading(false);
        Get.snackbar('Success', success.message);
      },
    );
  }

  List<String> _resolveEmployeeIds() {
    final ids = <String>{};
    for (final controller in employeeControllers) {
      final mappedId = employeeIdMap[controller];
      if (mappedId != null && mappedId.isNotEmpty) {
        ids.add(mappedId);
        continue;
      }

      final rawText = controller.text.trim();
      if (rawText.length >= 20 && !rawText.contains('@')) {
        ids.add(rawText);
      }
    }
    return ids.toList();
  }

  List<CompanyHonorInput> _buildCompanyHonors() {
    return awardFields.map((fields) {
      return CompanyHonorInput(
        title: fields['title']?.text.trim() ?? '',
        programeName: fields['issuer']?.text.trim() ?? '',
        programeDate: fields['date']?.text.trim() ?? '',
        description: fields['description']?.text.trim() ?? '',
      );
    }).where((item) {
      return item.title.trim().isNotEmpty ||
          item.programeName.trim().isNotEmpty ||
          item.description.trim().isNotEmpty;
    }).toList();
  }

  List<WebSocialLinkInput> _buildCompanySocialLinks({
    required String linkedIn,
    required String twitter,
    required String upwork,
    required String facebook,
    required String tiktok,
    required String instagram,
    required String fiverr,
    required String companyWebsite,
  }) {
    final links = <WebSocialLinkInput>[];

    void addLink(String label, String value) {
      if (value.trim().isEmpty) return;
      links.add(WebSocialLinkInput(label: label, url: value.trim()));
    }

    addLink('LinkedIn', linkedIn);
    addLink('Twitter', twitter);
    addLink('Upwork', upwork);
    addLink('Facebook', facebook);
    addLink('TikTok', tiktok);
    addLink('Instagram', instagram);
    addLink('Fiverr', fiverr);
    addLink('Website', companyWebsite);

    return links;
  }

  Future<void> _legacyCreateCompanyScreen(
    File banner,
    File clogo,
    String cname,
    String country,
    String city,
    int zipCode,
    String cemail,
    String aboutUs,
    String industry,
    String linkedIn,
    String twitter,
    String upwork,
    String facebook,
    String tiktok,
    String instagram,
    String fiverr,
    String companyWebsite,
    String services, // comma-separated
    String recruiters, // emails only, comma-separated
  ) async {
    setLoading(true);
    setError('');

    if (Get.isRegistered<RecruiterController>() &&
        !Get.find<RecruiterController>().successVideoUploaded.value) {
      setError('Upload elevator pitch before creating a company profile.');
      Get.snackbar(
        'Elevator Pitch Required',
        'Please upload your elevator pitch before creating the company profile.',
      );
      setLoading(false);
      return;
    }

    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found.');
      setLoading(false);
      return;
    }

    _multiFormDataManager.clear();

    // FILES - MUST MATCH EXACTLY
    _multiFormDataManager.addImageFile(banner, key: "banner");
    _multiFormDataManager.addImageFile(
      clogo,
      key: "clogo",
    ); // NOT "logo" → MUST BE "clogo"

    // TEXT FIELDS - MUST MATCH EXACTLY WHAT BACKEND EXPECTS
    _multiFormDataManager.addTextData("cname", cname);
    _multiFormDataManager.addTextData("cemail", cemail);
    _multiFormDataManager.addTextData("aboutUs", aboutUs);
    _multiFormDataManager.addTextData("industry", industry);
    _multiFormDataManager.addTextData("country", country);
    _multiFormDataManager.addTextData("city", city);
    _multiFormDataManager.addTextData(
      "zipcode",
      zipCode.toString(),
    ); // ← zipcode, not zipCode
    _multiFormDataManager.addTextData("userId", userId);

    // Services & Recruiters
    final serviceList = getServices();
    if (serviceList.isNotEmpty) {
      _multiFormDataManager.addTextData("service", jsonEncode(serviceList));
    }

    final employeeIds = employeeControllers
        .where((c) => employeeIdMap.containsKey(c))
        .map((c) => employeeIdMap[c]!)
        .toList();

    if (employeeIds.isNotEmpty) {
      _multiFormDataManager.addTextData("employeesId", jsonEncode(employeeIds));
    } else {
      _multiFormDataManager.addTextData("employeesId", jsonEncode([]));
    }

    // Awards as JSON string

    final awardsList = getAwards();

    if (awardsList.isNotEmpty) {
      _multiFormDataManager.addTextData(
        "AwardsAndHonors", // ← EXACT FIELD NAME FROM BACKEND
        jsonEncode(awardsList),
      );
    } else {
      _multiFormDataManager.addTextData("AwardsAndHonors", "[]");
    }

    // SOCIAL LINKS - EXACTLY LIKE RECRUITER API (sLink[0][label], sLink[0][url])
    List<Map<String, String>> sLinks = [];
    if (linkedIn.isNotEmpty) sLinks.add({"label": "LinkedIn", "url": linkedIn});
    if (twitter.isNotEmpty) sLinks.add({"label": "Twitter", "url": twitter});
    if (upwork.isNotEmpty) sLinks.add({"label": "Upwork", "url": upwork});
    if (facebook.isNotEmpty) sLinks.add({"label": "Facebook", "url": facebook});
    if (tiktok.isNotEmpty) sLinks.add({"label": "TikTok", "url": tiktok});
    if (instagram.isNotEmpty) {
      sLinks.add({"label": "Instagram", "url": instagram});
    }
    if (fiverr.isNotEmpty) sLinks.add({"label": "Fiverr", "url": fiverr});
    if (companyWebsite.isNotEmpty) {
      sLinks.add({"label": "Website", "url": companyWebsite});
    }

    if (sLinks.isNotEmpty) {
      _multiFormDataManager.addTextData("sLink", jsonEncode(sLinks));
    }

    final formData = await _multiFormDataManager.toFormDataAsync();

    print("Final Fields: ${formData.fields}");

    final result = await _companyRepo.createCompany(formData);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("Create Company Failed: ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("Company Created: ${success.message}");
        Get.snackbar("Success", "Company created successfully!");
        Get.off(() => CompanyDetailsPage());
        setLoading(false);
      },
    );
  }

  Future<void> _legacyUpdateCompany(
    String companyId,
    File? banner,
    File? clogo,
    String cname,
    String country,
    String city,
    int zipCode,
    String cemail,
    String aboutUs,
    String industry,
    String linkedIn,
    String twitter,
    String upwork,
    String facebook,
    String tiktok,
    String instagram,
    String fiverr,
    String companyWebsite,
    String services, // comma-separated
    String recruiters, // emails only, comma-separated
    String awardsJson, // JSON string
  ) async {
    setLoading(true);
    setError('');

    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found.');
      setLoading(false);
      return;
    }

    _multiFormDataManager.clear();

    // FILES - MUST MATCH EXACTLY
    if (banner != null) {
      _multiFormDataManager.addImageFile(banner, key: "banner");
    }
    if (clogo != null) {
      _multiFormDataManager.addImageFile(clogo, key: "clogo");
    } // NOT "logo" → MUST BE "clogo"

    // TEXT FIELDS - MUST MATCH EXACTLY WHAT BACKEND EXPECTS
    _multiFormDataManager.addTextData("cname", cname);
    _multiFormDataManager.addTextData("cemail", cemail);
    _multiFormDataManager.addTextData("aboutUs", aboutUs);
    _multiFormDataManager.addTextData("industry", industry);
    _multiFormDataManager.addTextData("country", country);
    _multiFormDataManager.addTextData("city", city);
    _multiFormDataManager.addTextData(
      "zipcode",
      zipCode.toString(),
    ); // ← zipcode, not zipCode
    _multiFormDataManager.addTextData("userId", userId);

    // Services & Recruiters
    final serviceList = getServices();
    if (serviceList.isNotEmpty) {
      _multiFormDataManager.addTextData("service", jsonEncode(serviceList));
    }

    final employeeIds = employeeControllers
        .where((c) => employeeIdMap.containsKey(c))
        .map((c) => employeeIdMap[c]!)
        .toList();

    if (employeeIds.isNotEmpty) {
      _multiFormDataManager.addTextData("employeesId", jsonEncode(employeeIds));
    } else {
      _multiFormDataManager.addTextData("employeesId", jsonEncode([]));
    }

    // Awards as JSON string
    _multiFormDataManager.addTextData("AwardsAndHonors", awardsJson);
    // SOCIAL LINKS - EXACTLY LIKE RECRUITER API (sLink[0][label], sLink[0][url])
    List<Map<String, String>> sLinks = [];
    if (linkedIn.isNotEmpty) sLinks.add({"label": "LinkedIn", "url": linkedIn});
    if (twitter.isNotEmpty) sLinks.add({"label": "Twitter", "url": twitter});
    if (upwork.isNotEmpty) sLinks.add({"label": "Upwork", "url": upwork});
    if (facebook.isNotEmpty) sLinks.add({"label": "Facebook", "url": facebook});
    if (tiktok.isNotEmpty) sLinks.add({"label": "TikTok", "url": tiktok});
    if (instagram.isNotEmpty) {
      sLinks.add({"label": "Instagram", "url": instagram});
    }
    if (fiverr.isNotEmpty) sLinks.add({"label": "Fiverr", "url": fiverr});
    if (companyWebsite.isNotEmpty) {
      sLinks.add({"label": "Website", "url": companyWebsite});
    }

    if (sLinks.isNotEmpty) {
      _multiFormDataManager.addTextData("sLink", jsonEncode(sLinks));
    }

    final formRequest = await _multiFormDataManager.toFormDataAsync();

    // final result = await _companyRepo.updateCompanyInfo(userId, formRequest);
    final result = await _companyRepo.updateCompanyInfo(companyId, formRequest);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log('Update Company: ${fail.message}');
        setLoading(false);
      },
      (success) async {
        DPrint.log('Update Company: ${success.message}');
        // await fetchProfile(); // refresh profile
        Get.to(() => CompanyDetailsPage());
        setLoading(false);
        Get.snackbar('Success', success.message);
      },
    );
  }

  Future<void> manageJobs() async {
    setLoading(true);
    setError("");

    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      setError('User ID not found.');
      setLoading(false);
      return;
    }

    // Step 1: Fetch company profile to get companyId
    final companyResult = await _companyRepo.fetchCompanyInfo(userId);

    String? companyId;
    companyResult.fold(
      (fail) => setError("Failed to load company"),
      (success) =>
          companyId = success.data?.companies.first.id, // assuming id field
    );

    if (companyId == null) {
      setError("No company found for this user");
      setLoading(false);
      return;
    }

    // Step 2: Now fetch jobs using companyId
    final result = await _companyRepo.fetchManageJobs(
      companyId!,
    ); // ← pass companyId

    result.fold(
      (fail) {
        setError(fail.message);
        setLoading(false);
      },
      (success) {
        if (success.data != null) {
          manageJobList.value = success.data!;
        }
        setLoading(false);
      },
    );
  }

  Future<void> connectRecruiter(List<String> employeeIds) async {
    setLoading(true);
    setError("");

    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      setError('User not authenticated');
      Get.snackbar('Error', 'User not authenticated');
      setLoading(false);
      return;
    }

    final request = RecruiterAddedRequestModel(
      companyId: userId, // Now sending userId
      employeeIds: employeeIds,
    );

    final result = await _companyRepo.connectRecruiter(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("connect recruiter failed: ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("connect recruiter success: ${success.message}");

        // Clear selected recruiters after success
        employeeControllers.clear();
        employeeIdMap.clear();
        employeeControllers.add(TextEditingController()); // keep one empty

        setLoading(false);

        // Close the "Add Company Recruiters" dialog if it is still open.
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        Get.snackbar(
          "Success",
          "Recruiter added successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to the internal recruiter screen.
        Get.to(() => const CompanyEmployeesScreen());
      },
    );
  }

  List<String> getSelectedEmployeeIds() {
    return employeeControllers
        .where((controller) => employeeIdMap.containsKey(controller))
        .map((controller) => employeeIdMap[controller]!)
        .where(
          (id) => id.isNotEmpty && id.length >= 20,
        ) // valid ObjectId length
        .toList();
  }

  /// Called from AppDrawer → Elevator Pitch & Resume, or after login for company role.
  /// Fetches the company profile and decides which screen to open:
  ///   - non-empty companies list → [CompanyDetailsPage] (company dashboard)
  ///   - empty companies list     → [CreateCompanyAccountPage] (setup)
  ///
  /// [clearStack] – set to `true` when called after login so that the
  /// LoginScreen is removed from the navigation history.
  Future<void> navigateFromElevatorPitch({bool clearStack = false}) async {
    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      return;
    }

    // Show loading overlay
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final result = await _companyRepo.fetchCompanyInfo(userId);

    // Close loading overlay
    if (Get.isDialogOpen ?? false) Get.back();

    result.fold(
      (fail) {
        // On error assume profile not set up yet
        if (clearStack) {
          Get.offAll(() => const CreateCompanyAccountPage());
        } else {
          Get.to(() => const CreateCompanyAccountPage());
        }
      },
      (success) {
        final companies = success.data.companies;
        DPrint.log("Company data: $companies");
        // Company profile exists if the companies list is non-empty
        final hasCompany = companies.isNotEmpty;

        if (clearStack) {
          Get.offAll(
            () => hasCompany
                ? CompanyDetailsPage()
                : const CreateCompanyAccountPage(),
          );
        } else {
          if (hasCompany) {
            Get.to(() => CompanyDetailsPage());
          } else {
            Get.to(() => const CreateCompanyAccountPage());
          }
        }
      },
    );
  }
}
