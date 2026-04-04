import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:giveandtake/core/theme/input_decoration_extensions.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../create_job/presentation/controller/create_job_controller.dart';
import '../../../create_job/presentation/widgets/searchable_widgets.dart';

import '../../../recruiter_account/presentation/controller/company_image_controller.dart';
import '../../../recruiter_account/presentation/controller/description_controller.dart';
import '../../../recruiter_account/presentation/controller/image_controller.dart';
import '../../../recruiter_account/presentation/controller/recruiter_controller.dart';
import '../../../recruiter_account/presentation/controller/upload_elevator_pitch.dart';

import '../../../recruiter_account/presentation/widgets/bio.dart';

import '../../data/model/single_Company_response_model.dart';
import '../../data/model/update_company_response_model.dart';
import '../controller/company_account_controller.dart';
import '../widget/custom_text_field.dart';

import '../widget/month_added_widget.dart';
import 'company_details_screen.dart';

class CompanyEditAccountPage extends StatefulWidget {
  final SingleCompanyResponseModel companyData;

  CompanyEditAccountPage({super.key, required this.companyData});

  @override
  State<CompanyEditAccountPage> createState() => _CompanyEditAccountPageState();
}

class _CompanyEditAccountPageState extends State<CompanyEditAccountPage> {
  final CompanyAccountController controller =
      Get.find<CompanyAccountController>();

  final recruiterController = Get.find<RecruiterController>();

  final CreateJobPostingController jobController = Get.put(
    CreateJobPostingController(Get.find()),
  );

  final CompanyImageController bannerPickerController = Get.put(
    CompanyImageController(),
  );

  final ImageController imagePickerController = Get.put(ImageController());
  final aboutUsController = TextEditingController();
  final companyNameController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final postalCodeController = TextEditingController();
  final emailController = TextEditingController();

  final TextEditingController _descriptionTController = TextEditingController();

  final TextEditingController _linkedINTEController = TextEditingController();

  final TextEditingController _twitterTEController = TextEditingController();

  final TextEditingController _upworkTEController = TextEditingController();

  final TextEditingController _facebookTEController = TextEditingController();

  final TextEditingController _instaTEController = TextEditingController();

  final TextEditingController _tiktokTEController = TextEditingController();

  final TextEditingController _fiverrTEController = TextEditingController();

  final TextEditingController _comapanyTEController = TextEditingController();

  final FocusNode _linkedINFocusNode = FocusNode();

  final FocusNode _twitterFocusNode = FocusNode();

  final FocusNode _upworkFocusNode = FocusNode();

  final FocusNode _facebookFocusNode = FocusNode();

  final FocusNode _instaFocusNode = FocusNode();

  final FocusNode _tiktokFocusNode = FocusNode();

  final FocusNode _fiverrFocusNode = FocusNode();

  final FocusNode _companyFocusNode = FocusNode();

  late int zipCode = int.tryParse(postalCodeController.text) ?? 0;

  final DescriptionController descriptionController = Get.put(
    DescriptionController(),
  );

  final CompanyImageController companyImageController = Get.put(
    CompanyImageController(),
  );

  // final ElevatorPitchController elevatorPitchController = Get.put(
  //   ElevatorPitchController(),
  // );

  @override
  void initState() {
    super.initState();
    final company = widget.companyData.companies.first;
    // final honor = widget.companyData.honors.first;
    final List<Honor> awards = widget.companyData.honors;

    // Fill text fields
    controller.companyNameController.text = company.cname ;
    controller.postalCodeController.text = company.zipcode ;
    controller.emailController.text = company.cemail ;
    controller.industryController.text = company.industry ;
    // controller.awardFields = honor.title.map((e) => {'title': e}).toList();

    // About Us
    String cleanAboutUs(String? html) {
      if (html == null || html.isEmpty) return '';
      String text = html
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .replaceAll('&#39;', "'")
          .replaceAll(RegExp(r'<br\s*/?>'), '\n');
      text = text.replaceAll(RegExp(r'<[^>]*>'), '');
      return text.replaceAll(RegExp(r'\s+'), ' ').trim();
    }

    _descriptionTController.text = cleanAboutUs(company.aboutUs);

    // Country & City
    jobController.selectedCountry.value = company.country ;
    jobController.selectedCity.value = company.city ;

    // Social Links
    final socialMap = {
      "linkedin": _linkedINTEController,
      "twitter": _twitterTEController,
      "upwork": _upworkTEController,
      "facebook": _facebookTEController,
      "instagram": _instaTEController,
      "tiktok": _tiktokTEController,
      "fiverr": _fiverrTEController,
      "website": _comapanyTEController, // or "company"
    };

    for (var link in company.sLink) {
      final label = link.label.toLowerCase() ;
      if (socialMap.containsKey(label)) {
        socialMap[label]!.text = link.url ;
      }
    }

    // CRITICAL: Load existing banner & logo URLs
    if (company.banner.isNotEmpty) {
      bannerPickerController.existingImageUrl.value = company.banner;
    }
    if (company.clogo.isNotEmpty) {
      imagePickerController.existingImageUrl.value = company.clogo;
    }

    // === SERVICES ===
    controller.serviceControllers.clear();
    if (company.service != null && company.service.isNotEmpty) {
      for (var service in company.service) {
        controller.serviceControllers.add(TextEditingController(text: service));
      }
    } else {
      controller.serviceControllers.add(TextEditingController());
    }

    // === RECRUITERS ===
    controller.employeeControllers.clear();
    controller.employeeIdMap.clear();
    if (company.employeesId != null && company.employeesId.isNotEmpty) {
      for (var email in company.employeesId) {
        controller.employeeControllers.add(TextEditingController(text: email));
      }
    }
    if (controller.employeeControllers.isEmpty) {
      controller.employeeControllers.add(TextEditingController());
    }

    // === AWARDS & HONORS ===
    controller.awardFields.clear();

    if (awards.isNotEmpty) {
      for (var award in awards) {
        controller.awardFields.add({
          'title': TextEditingController(text: award.title ?? ''),
          'issuer': TextEditingController(
            text: award.programeName ?? '',
          ), // ← Use programeName
          'date': TextEditingController(
            text: award.programeDate != null
                ? '${award.programeDate!.month.toString().padLeft(2, '0')}${award.programeDate!.year}'
                : '',
          ),
          'description': TextEditingController(text: award.description ?? ''),
        });
      }
    } else {
      controller.addAwardField(); // add one empty field
    }

    controller.awardFields.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B7FD0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),

        title: const Text(
          "Edit Company Account",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(width: 48), // Balances the leading icon
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              // const SizedBox(height: 51),
              // Text(
              //   " Edit Company Account",
              //   style: TextStyle(
              //     color: AppColors.textBlack,
              //     fontSize: 18,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              const SizedBox(height: 28),

              Text(
                'Company Banner',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Color(0xFF999999)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: bannerPickerController.showPickerOptions,
                    child: Obx(() {
                      return Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xFFD9D9D9),
                        ),
                        child: Center(
                          child:
                              bannerPickerController.selectedImage.value != null
                              ? Image.file(
                                  bannerPickerController.selectedImage.value!,
                                  fit: BoxFit.cover,
                                )
                              : bannerPickerController
                                    .existingImageUrl
                                    .value
                                    .isNotEmpty
                              ? Image.network(
                                  bannerPickerController.existingImageUrl.value,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 150,
                                  errorBuilder: (_, __, ___) =>
                                      const Text('Failed to load banner'),
                                )
                              : const Text('Company banner'),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Company Logo",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF000000),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: imagePickerController.showPickerOptions,
                        child: Obx(() {
                          return Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xFFD9D9D9),
                            ),
                            child: Center(
                              child:
                                  imagePickerController.selectedImage.value !=
                                      null
                                  ? Image.file(
                                      imagePickerController
                                          .selectedImage
                                          .value!,
                                      fit: BoxFit.cover,
                                    )
                                  : imagePickerController
                                        .existingImageUrl
                                        .value
                                        .isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        imagePickerController
                                            .existingImageUrl
                                            .value,
                                        width: 130,
                                        height: 130,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Text('Failed to load logo'),
                                      ),
                                    )
                                  : const Text('Company logo'),
                            ),
                          );
                        }),
                      ),

                      SizedBox(height: 10),
                    ],
                  ),

                  SizedBox(width: 15),

                  Bio(
                    descriptionTController: _descriptionTController,
                    descriptionController: descriptionController,
                  ),
                ],
              ),

              const SizedBox(height: 8),
              CustomTextField(
                label: 'Company Name',
                controller: controller.companyNameController,

                isRequired: true,
                hintText: "Enter your company name",
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Country dropdown
                  Expanded(
                    child: Obx(
                      () => SearchableDropdownField(
                        label: "Country",
                        hintText: "Select country",
                        items: jobController.filteredCountries,
                        value: jobController.selectedCountry.value,
                        onChanged: (value) {
                          jobController.selectedCountry.value = value;
                          jobController.fetchCities(
                            value,
                          ); // load cities for this country
                        },
                        isRequired: true,
                        enabled: !jobController.isLoadingCountries.value,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // City dropdown
                  Expanded(
                    child: Obx(
                      () => SearchableDropdownField(
                        label: "City",
                        hintText: "Select city",
                        items: jobController.filteredCities,
                        value: jobController.selectedCity.value,
                        onChanged: (value) {
                          jobController.selectedCity.value = value;
                        },
                        isRequired: true,
                        enabled: jobController.citiesList.isNotEmpty,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: "Postal Code",
                      controller: controller.postalCodeController, // ✅ bind
                      hintText: "Enter postal code",
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      label: "Email",
                      controller: controller.emailController, // ✅ bind
                      hintText: "Enter your email",
                      // isRequired: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color(0xFF999999),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Social Links',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Add URLs for your social and professional profiles (optional)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF999999),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'LinkedIn URL',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6),
                                TextFormField(
                                  controller: _linkedINTEController,
                                  focusNode: _linkedINFocusNode,
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.next,
                                  decoration: context.primaryInputDecoration
                                      .copyWith(
                                        hintText: "Enter URL here",
                                        hintStyle: TextStyle(
                                          color: Color(0xFF787878),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                  // validator: Validators.name,
                                ),

                                SizedBox(height: 12),
                                Text(
                                  'Twitter URL',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6),
                                TextFormField(
                                  controller: _twitterTEController,
                                  focusNode: _twitterFocusNode,
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.next,
                                  decoration: context.primaryInputDecoration
                                      .copyWith(
                                        hintText: "Enter URL here",
                                        hintStyle: TextStyle(
                                          color: Color(0xFF787878),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                  // validator: Validators.name,
                                ),

                                SizedBox(height: 12),
                                Text(
                                  'Upwork URL',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6),
                                TextFormField(
                                  controller: _upworkTEController,
                                  focusNode: _upworkFocusNode,
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.next,
                                  decoration: context.primaryInputDecoration
                                      .copyWith(
                                        hintText: "Enter URL here",
                                        hintStyle: TextStyle(
                                          color: Color(0xFF787878),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                  // validator: Validators.name,
                                ),

                                SizedBox(height: 12),
                                Text(
                                  'Facebook URL',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6),
                                TextFormField(
                                  controller: _facebookTEController,
                                  focusNode: _facebookFocusNode,
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.next,
                                  decoration: context.primaryInputDecoration
                                      .copyWith(
                                        hintText: "Enter URL here",
                                        hintStyle: TextStyle(
                                          color: Color(0xFF787878),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                  // validator: Validators.name,
                                ),

                                SizedBox(height: 12),
                                Text(
                                  'TikTok URL',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6),
                                TextFormField(
                                  controller: _tiktokTEController,
                                  focusNode: _tiktokFocusNode,
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.next,
                                  decoration: context.primaryInputDecoration
                                      .copyWith(
                                        hintText: "Enter URL here",
                                        hintStyle: TextStyle(
                                          color: Color(0xFF787878),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                  // validator: Validators.name,
                                ),

                                SizedBox(height: 12),
                                Text(
                                  'Instagram URL',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6),
                                TextFormField(
                                  controller: _instaTEController,
                                  focusNode: _instaFocusNode,
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.next,
                                  decoration: context.primaryInputDecoration
                                      .copyWith(
                                        hintText: "Enter URL here",
                                        hintStyle: TextStyle(
                                          color: Color(0xFF787878),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                  // validator: Validators.name,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Fiverr URL',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6),
                                TextFormField(
                                  controller: _fiverrTEController,
                                  focusNode: _fiverrFocusNode,
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.next,
                                  decoration: context.primaryInputDecoration
                                      .copyWith(
                                        hintText: "Enter URL here",
                                        hintStyle: TextStyle(
                                          color: Color(0xFF787878),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                  // validator: Validators.name,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Company Website URL',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6),
                                TextFormField(
                                  controller: _comapanyTEController,
                                  focusNode: _companyFocusNode,
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.next,
                                  decoration: context.primaryInputDecoration
                                      .copyWith(
                                        hintText: "Enter URL here",
                                        hintStyle: TextStyle(
                                          color: Color(0xFF787878),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                  // validator: Validators.name,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              CustomTextField(
                label: 'Industry',
                hintText: "Select Industry",
                isRequired: true,
                readOnly: true,
                controller:
                    controller.industryController, // create this controller
                onTap: () async {
                  await recruiterController.fetchCategory();
                  recruiterController.searchText.value = "";

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // needed to react to keyboard
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (context) {
                      final bottomPadding = MediaQuery.of(
                        context,
                      ).viewInsets.bottom;

                      return Padding(
                        // 🟦 pushes bottom sheet above keyboard
                        padding: EdgeInsets.only(bottom: bottomPadding),

                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            constraints: const BoxConstraints(
                              maxHeight: 350, // dropdown height
                            ),
                            child: Column(
                              children: [
                                // 🔎 SEARCH FIELD
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: "Search Industry",
                                    prefixIcon: Icon(Icons.search),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    recruiterController.searchText.value =
                                        value;
                                  },
                                ),

                                const SizedBox(height: 12),

                                // 📋 FILTERED LIST
                                Expanded(
                                  child: Obx(() {
                                    final filtered = recruiterController
                                        .category
                                        .where(
                                          (item) =>
                                              item.name.toLowerCase().contains(
                                                recruiterController
                                                    .searchText
                                                    .value
                                                    .toLowerCase(),
                                              ),
                                        )
                                        .toList();

                                    if (filtered.isEmpty) {
                                      return const Center(
                                        child: Text("No results found"),
                                      );
                                    }

                                    return ListView.builder(
                                      itemCount: filtered.length,
                                      itemBuilder: (_, index) {
                                        final item = filtered[index];
                                        return ListTile(
                                          title: Text(item.name),
                                          onTap: () {
                                            controller.industryController.text =
                                                item.name;
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
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service field expands
                  Expanded(
                    child: CustomTextField(
                      label: "Service",
                      hintText: "Add Service",
                      controller: controller.serviceControllers[0],
                      // isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Add More button (fixed size, gray background, black text)
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: controller.addServiceField,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFFFFFFFF,
                      ), // gray background
                      foregroundColor: Colors.black, // text/icon color
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      elevation: 0, // flat style
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: const BorderSide(
                          color: Colors.grey, // border color
                          width: 1, // border width
                        ),
                      ),
                    ),
                    child: const Text(
                      "Add More +",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              // Dynamic service fields
              Obx(
                () => Column(
                  children: List.generate(
                    controller.serviceControllers.length,
                    (index) {
                      if (index == 0)
                        return const SizedBox.shrink(); // skip first field
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: "",
                                hintText: "Enter service",
                                controller:
                                    controller.serviceControllers[index],
                                // isRequired: true,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () =>
                                  controller.removeServiceField(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "View your company recruiters",
                  style: TextStyle(
                    color: AppColors.textBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.fetchUsers(); // ← This WILL fire
                      },
                      child: AbsorbPointer(
                        // ← Prevents keyboard from opening
                        child: CustomTextField(
                          label: "Add Profiles of Recruiters",
                          hintText: "Tap to select recruiter",
                          controller: controller.employeeControllers[0],
                          // isRequired: true,
                          readOnly: true, // keep it
                          // Remove onTap from here — it won't work reliably
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Add More button
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: controller.addEmployee,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFFFF),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: const BorderSide(
                          color: Colors.grey, // border color
                          width: 1, // border width
                        ),
                      ),
                    ),
                    child: const Text(
                      "Add More +",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              // Dynamic employee fields
              Obx(
                () => Column(
                  children: List.generate(
                    controller.employeeControllers.length,
                    (index) {
                      if (index == 0)
                        return const SizedBox.shrink(); // skip first field
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Expanded(
                                child: GestureDetector(
                                  onTap: () => controller.fetchUsers(),
                                  child: AbsorbPointer(
                                    child: CustomTextField(
                                      label: index == 0
                                          ? "Add Profiles of Recruiters"
                                          : "Recruiter ${index + 1}",
                                      hintText: "Tap to select recruiter",
                                      controller:
                                          controller.employeeControllers[index],
                                      readOnly: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () =>
                                  controller.removeEmployeeField(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Award Description*",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Award & Honors",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      "Highlight your achievements and recognitions.",
                      style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                    ),

                    const SizedBox(height: 20),

                    // Dynamic Award Cards
                    Obx(
                      () => Column(
                        children: List.generate(controller.awardFields.length, (
                          index,
                        ) {
                          final fields = controller.awardFields[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header: Award Title + Remove Button
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Award ${index + 1}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      onPressed: () =>
                                          controller.removeAwardField(index),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                                const Divider(),

                                CustomTextField(
                                  label: "Award Title",
                                  hintText: "e.g. Employee of the Year",
                                  controller: fields['title'],
                                  isRequired: true,
                                ),
                                const SizedBox(height: 12),

                                CustomTextField(
                                  label: "Program Name",
                                  hintText: "e.g. Company Recognition Program",
                                  controller: fields['issuer'],
                                  isRequired: true,
                                ),
                                const SizedBox(height: 12),

                                // Program Date - Month/Year Picker
                                const Text(
                                  "Program Date",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () async {
                                    int? initMonth, initYear;
                                    final text = fields['date']!.text;
                                    if (text.length == 6) {
                                      initMonth = int.tryParse(
                                        text.substring(0, 2),
                                      );
                                      initYear = int.tryParse(
                                        text.substring(2),
                                      );
                                    }

                                    final result =
                                        await showDialog<Map<String, int>>(
                                          context: context,
                                          builder: (_) => MonthYearPickerDialog(
                                            initialMonth: initMonth,
                                            initialYear: initYear,
                                          ),
                                        );

                                    if (result != null) {
                                      final month = result['month']!
                                          .toString()
                                          .padLeft(2, '0');
                                      final year = result['year'].toString();
                                      // fields['date']?.text = "$month/$year";
                                      fields['date']?.text =
                                          month + year; // e.g. 122025
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: fields['date'],
                                      decoration: InputDecoration(
                                        hintText: "MMYYYY",
                                        suffixIcon: const Icon(
                                          Icons.calendar_today_outlined,
                                          size: 20,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade400,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      validator: (val) {
                                        if (val == null || val.isEmpty)
                                          return "Required";
                                        if (!RegExp(r'^\d{6}$').hasMatch(val))
                                          return "Format: MMYYYY";
                                        final m = int.tryParse(
                                          val.substring(0, 2),
                                        );
                                        if (m == null || m < 1 || m > 12)
                                          return "Invalid month";
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                CustomTextField(
                                  label: "Award Short Description",
                                  hintText:
                                      "Briefly describe the award and what you achieved",
                                  controller: fields['description'],
                                  isRequired: true,
                                  maxLines: 4,
                                ),
                                const SizedBox(height: 16),

                                // Add Another Award Button
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    onPressed: controller.addAwardField,
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      size: 18,
                                    ),
                                    label: const Text("Add Another Award"),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.primaryWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Main "Add Award" Button
                    ElevatedButton.icon(
                      onPressed: controller.addAwardField,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text("Add Award"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!controller.formKey.currentState!.validate())
                          return;
                        if (controller.isLoading.value) return;

                        try {
                          // Validate country & city
                          final country =
                              jobController.selectedCountry.value ?? '';
                          final city = jobController.selectedCity.value ?? '';
                          if (country.isEmpty || city.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "Please select country and city",
                            );
                            return;
                          }

                          final zipCode = int.tryParse(
                            controller.postalCodeController.text.trim(),
                          );
                          if (zipCode == null) {
                            Get.snackbar("Error", "Invalid postal code");
                            return;
                          }

                          // Validate banner & logo
                          if (bannerPickerController.selectedImage.value ==
                                  null &&
                              bannerPickerController
                                  .existingImageUrl
                                  .value
                                  .isEmpty) {
                            Get.snackbar(
                              "Error",
                              "Please upload a company banner",
                            );
                            return;
                          }
                          if (imagePickerController.selectedImage.value ==
                                  null &&
                              imagePickerController
                                  .existingImageUrl
                                  .value
                                  .isEmpty) {
                            Get.snackbar(
                              "Error",
                              "Please upload a company logo",
                            );
                            return;
                          }

                          // Get awards JSON
                          final awardsJson = jsonEncode(controller.getAwards());

                          // Call updateCompany
                          await controller.updateCompany(
                            widget.companyData.companies.first.id,
                            bannerPickerController.selectedImage.value, // File?
                            imagePickerController.selectedImage.value, // File?
                            controller.companyNameController.text.trim(),
                            country,
                            city,
                            zipCode,
                            controller.emailController.text.trim(),
                            _descriptionTController.text.trim(),
                            controller.industryController.text.trim(),
                            _linkedINTEController.text.trim(),
                            _twitterTEController.text.trim(),
                            _upworkTEController.text.trim(),
                            _facebookTEController.text.trim(),
                            _tiktokTEController.text.trim(),
                            _instaTEController.text.trim(),
                            _fiverrTEController.text.trim(),
                            _comapanyTEController.text.trim(),
                            "", // services (handled internally by getServices())
                            "", // recruiters (handled by employeeIdMap)
                            awardsJson,
                          );

                          Get.snackbar(
                            "Success",
                            "Company updated successfully!",
                          );
                          Get.off(() => CompanyDetailsPage());
                        } catch (e) {
                          debugPrint("Save Error: $e");
                          Get.snackbar("Error", "Failed to update company: $e");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2B7FD0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  Container(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2B7FD0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
