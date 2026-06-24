import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/theme/input_decoration_extensions.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_buttoms.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../create_job/presentation/controller/create_job_controller.dart';
import '../../../create_job/presentation/widgets/searchable_widgets.dart';
import '../../../recruiter_account/presentation/controller/company_image_controller.dart';
import '../../../recruiter_account/presentation/controller/description_controller.dart';
import '../../../recruiter_account/presentation/controller/image_controller.dart';
import '../../../recruiter_account/presentation/controller/recruiter_controller.dart';
import '../../../recruiter_account/presentation/screens/video_upload_screen.dart';
import '../../../recruiter_account/presentation/widgets/bio.dart';
import '../../../recruiter_account/presentation/widgets/cropped_image_picker_card.dart';
import '../../../recruiter_account/presentation/widgets/video_player_widget.dart';
import '../controller/company_account_controller.dart';
import '../widget/custom_text_field.dart';
import '../widget/month_added_widget.dart';

class CreateCompanyAccountPage extends StatefulWidget {
  const CreateCompanyAccountPage({super.key});

  @override
  State<CreateCompanyAccountPage> createState() =>
      _CreateCompanyAccountPageState();
}

class _CreateCompanyAccountPageState extends State<CreateCompanyAccountPage> {
  // final CompanyAccountController controller = Get.put(
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

  final DescriptionController descriptionController = Get.put(
    DescriptionController(),
  );

  @override
  void initState() {
    super.initState();
    bannerPickerController.clearSelection();
    imagePickerController.clearSelection();
  }

  // void dispose() {
  //   _descriptionTController.dispose();
  //   _linkedINTEController.dispose();
  //   _twitterTEController.dispose();
  //   _upworkTEController.dispose();
  //   _facebookTEController.dispose();
  //   _instaTEController.dispose();
  //   _tiktokTEController.dispose();
  //   _fiverrTEController.dispose();
  //   _comapanyTEController.dispose();
  //   _linkedINFocusNode.dispose();
  //   _twitterFocusNode.dispose();
  //   _upworkFocusNode.dispose();
  //   _facebookFocusNode.dispose();
  //   _instaFocusNode.dispose();
  //   _tiktokFocusNode.dispose();
  //   _fiverrFocusNode.dispose();
  //   _companyFocusNode.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            // Get.to(()=>const HomeScreen()); // since you're using GetX
          },
        ),
        backgroundColor: Color(0xFF2B7FD0),
        title: const Text(
          'Create Company/Business Account',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final bool isLoading = controller.isLoading.value ||
            recruiterController.isLoading.value ||
            jobController.isLoadingCountries.value;

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              // const SizedBox(height: 51),
              // Text(
              //   "Create Company Account",
              //   style: TextStyle(
              //     color: AppColors.textBlack,
              //     fontSize: 18,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              // const Text(
              //   "Sign-up and pitch your way into a new role",
              //   style: TextStyle(color: Colors.grey, fontSize: 14),
              // ),
              // const SizedBox(height: 28),

              // const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload company elevator pitch",
                    style: TextStyle(
                      color: AppColors.textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Upload a 60-second elevator video pitch introducing your company and what should make candidates want to join you!",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              GestureDetector(
                onTap: () {
                  Get.to(VideoUploadScreen());
                },
                child: Obx(() {
                  if (recruiterController.successVideoUploaded.value &&
                      recruiterController.uploadedVideoPath.value.isNotEmpty) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color(0xFF191919),
                      ),
                      height: 200,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: VideoPlayerWidget(
                          videoPath:
                              recruiterController.uploadedVideoPath.value,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color(0xFF191919),
                      ),
                      height: 150,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.image_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            'Drop your files here',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          const SizedBox(height: 9.5),
                          const Text(
                            'Choose file',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  }
                }),
              ),
              SizedBox(height: 16),

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
                  child: Obx(() {
                    return CroppedImagePickerCard(
                      onTap: bannerPickerController.showPickerOptions,
                      file: bannerPickerController.selectedImage.value,
                      imageUrl: bannerPickerController.existingImageUrl.value,
                      height: 150,
                      borderRadius: 8,
                      editLabel: 'Change banner',
                      placeholderTitle: 'Company banner',
                      placeholderSubtitle: 'Cropped to 1584 x 396',
                    );
                  }),
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
                      Obx(() {
                        return CroppedImagePickerCard(
                          onTap: imagePickerController.showPickerOptions,
                          file: imagePickerController.selectedImage.value,
                          imageUrl: imagePickerController.existingImageUrl.value,
                          width: 130,
                          height: 130,
                          borderRadius: 8,
                          editLabel: 'Change',
                          placeholderTitle: 'Company logo',
                          placeholderSubtitle: 'Cropped to 250 x 250',
                        );
                      }),

                      SizedBox(height: 10),
                    ],
                  ),

                  SizedBox(width: 15),

                  Expanded(
                    child: Bio(
                      descriptionTController: _descriptionTController,
                      descriptionController: descriptionController,
                    ),
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
                      isRequired: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              SocialLink(
                linkedINTEController: _linkedINTEController,
                linkedINFocusNode: _linkedINFocusNode,
                twitterTEController: _twitterTEController,
                twitterFocusNode: _twitterFocusNode,
                upworkTEController: _upworkTEController,
                upworkFocusNode: _upworkFocusNode,
                facebookTEController: _facebookTEController,
                facebookFocusNode: _facebookFocusNode,
                tiktokTEController: _tiktokTEController,
                tiktokFocusNode: _tiktokFocusNode,
                instaTEController: _instaTEController,
                instaFocusNode: _instaFocusNode,
                fiverTEController: _fiverrTEController,
                fiverFocusNode: _fiverrFocusNode,
                companyTEController: _comapanyTEController,
                companyFocusNode: _companyFocusNode,
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
                      isRequired: true,
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
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          controller.fetchUsers();
                        });
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

              // Save Button
              PrimaryButton(
                text: "Save",
                onPressed: () async {
                  if (controller.formKey.currentState!.validate()) {
                    if (controller.isLoading.value) return;

                    try {
                      // Collect data
                      final services = controller.getServices();
                      final employees = controller
                          .getEmployees(); // This contains: "Eshitta Mondol (eshitta@example.com)"
                      final awards = controller.getAwards();

                      // ──────────────────────────────────────────────────────────────
                      // CRITICAL FIX: Extract only emails from "Name (email)" format
                      // ──────────────────────────────────────────────────────────────
                      final recruiterEmails = employees
                          .map((e) {
                            final match = RegExp(r'\(([^)]+)\)').firstMatch(e);
                            if (match != null)
                              return match.group(1)!; // extract email inside ()
                            return e.contains('@') ? e.trim() : null;
                          })
                          .where((email) => email != null && email.isNotEmpty)
                          .cast<String>()
                          .toList();

                      final cleanRecruiterIds = recruiterEmails.join(",");

                      // Safe awards JSON
                      final awardsJson = jsonEncode(
                        controller.getAwards(),
                      ); // always valid JSON

                      // Debug print (optional - remove later)
                      debugPrint("Recruiters being sent → $cleanRecruiterIds");
                      debugPrint("Awards JSON → $awardsJson");

                      // ──────────────────────────────────────────────────────────────
                      // Validate required fields
                      // ──────────────────────────────────────────────────────────────
                      if (bannerPickerController.selectedImage.value == null) {
                        Get.snackbar("Error", "Please upload a company banner");
                        return;
                      }
                      if (imagePickerController.selectedImage.value == null) {
                        Get.snackbar("Error", "Please upload a company logo");
                        return;
                      }

                      final zipCode = int.tryParse(
                        controller.postalCodeController.text.trim(),
                      );
                      if (zipCode == null) {
                        Get.snackbar("Error", "Invalid postal code");
                        return;
                      }

                      final country = jobController.selectedCountry.value ?? '';
                      final city = jobController.selectedCity.value ?? '';
                      if (country.isEmpty || city.isEmpty) {
                        Get.snackbar("Error", "Please select country and city");
                        return;
                      }

                      // ──────────────────────────────────────────────────────────────
                      // FINAL API CALL WITH FIXED DATA
                      // ──────────────────────────────────────────────────────────────
                      await controller.createCompanyScreen(
                        bannerPickerController.selectedImage.value!,
                        imagePickerController.selectedImage.value!,
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
                        services.join(", "),
                        cleanRecruiterIds, // ← NOW ONLY EMAILS: eshitta@example.com,john@doe.com
                      );

                      // Success navigation (only if API succeeds — already handled inside controller)
                      // Get.off(() => CompanyDetailsPage());
                    } catch (e) {
                      debugPrint("Save Error: $e");
                      Get.snackbar("Error", "Failed to create company: $e");
                    }
                  }
                },
                width: double.infinity,
                height: 45,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      if (isLoading)
        const AbsorbPointer(
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFF2B7FD0)),
          ),
        ),
    ],
  );
}),
);
}
}

class SocialLink extends StatelessWidget {
  const SocialLink({
    super.key,
    required TextEditingController linkedINTEController,
    required FocusNode linkedINFocusNode,
    required TextEditingController twitterTEController,
    required FocusNode twitterFocusNode,
    required TextEditingController upworkTEController,
    required FocusNode upworkFocusNode,
    required TextEditingController facebookTEController,
    required FocusNode facebookFocusNode,
    required TextEditingController tiktokTEController,
    required FocusNode tiktokFocusNode,
    required TextEditingController instaTEController,
    required FocusNode instaFocusNode,
    required TextEditingController fiverTEController,
    required FocusNode fiverFocusNode,
    required TextEditingController companyTEController,
    required FocusNode companyFocusNode,
  }) : _linkedINTEController = linkedINTEController,
       _linkedINFocusNode = linkedINFocusNode,
       _twitterTEController = twitterTEController,
       _twitterFocusNode = twitterFocusNode,
       _upworkTEController = upworkTEController,
       _upworkFocusNode = upworkFocusNode,
       _facebookTEController = facebookTEController,
       _facebookFocusNode = facebookFocusNode,
       _tiktokTEController = tiktokTEController,
       _tiktokFocusNode = tiktokFocusNode,
       _instaTEController = instaTEController,
       _instaFocusNode = instaFocusNode,
       _fiverrTEController = fiverTEController,
       _fiverrFocusNode = fiverFocusNode,
       _comapanyTEController = companyTEController,
       _companyFocusNode = companyFocusNode;

  final TextEditingController _linkedINTEController;
  final FocusNode _linkedINFocusNode;
  final TextEditingController _twitterTEController;
  final FocusNode _twitterFocusNode;
  final TextEditingController _upworkTEController;
  final FocusNode _upworkFocusNode;
  final TextEditingController _facebookTEController;
  final FocusNode _facebookFocusNode;
  final TextEditingController _tiktokTEController;
  final FocusNode _tiktokFocusNode;
  final TextEditingController _instaTEController;
  final FocusNode _instaFocusNode;
  final TextEditingController _fiverrTEController;
  final FocusNode _fiverrFocusNode;
  final TextEditingController _comapanyTEController;
  final FocusNode _companyFocusNode;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  border: Border.all(color: Color(0xFF999999), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Company Social Media Links',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      // SizedBox(height: 4),
                      // Text(
                      //   'Add URLs for your social and professional profiles (optional)',
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     color: Color(0xFF999999),
                      //   ),
                      // ),
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
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: context.primaryInputDecoration.copyWith(
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
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: context.primaryInputDecoration.copyWith(
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
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: context.primaryInputDecoration.copyWith(
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
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: context.primaryInputDecoration.copyWith(
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
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: context.primaryInputDecoration.copyWith(
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
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: context.primaryInputDecoration.copyWith(
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
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: context.primaryInputDecoration.copyWith(
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
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: context.primaryInputDecoration.copyWith(
                          hintText: "Enter URL here",
                          hintStyle: TextStyle(
                            color: Color(0xFF787878),
                            fontSize: 14,
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
    );
  }
}
