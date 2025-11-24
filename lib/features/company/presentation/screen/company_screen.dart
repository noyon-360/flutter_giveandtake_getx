import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_buttoms.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../create_job/presentation/controller/create_job_controller.dart';
import '../../../create_job/presentation/widgets/searchable_widgets.dart';
import '../../../recruiter_account/data/models/get_category_response_model.dart';
import '../../../recruiter_account/presentation/controller/company_image_controller.dart';
import '../../../recruiter_account/presentation/controller/description_controller.dart';
import '../../../recruiter_account/presentation/controller/image_controller.dart';
import '../../../recruiter_account/presentation/controller/recruiter_controller.dart';
import '../../../recruiter_account/presentation/screens/video_upload_screen.dart';
import '../../../recruiter_account/presentation/widgets/bio.dart';
import '../../../recruiter_account/presentation/widgets/video_player_widget.dart';
import '../controller/company_account_controller.dart';
import '../widget/custom_text_field.dart';
import '../widget/upload_card_widget.dart';
import '../widget/upload_video_widget.dart';
import 'company_details_screen.dart';

class CreateCompanyAccountPage extends StatelessWidget {
  final CompanyAccountController controller = Get.put(
    CompanyAccountController(),
  );
  final recruiterController = Get.find<RecruiterController>();

  final CreateJobPostingController jobController = Get.put(
    CreateJobPostingController(Get.find()),
  );
  final CompanyImageController bannerPickerController = Get.put(
    CompanyImageController(),
  );

  final ImageController imagePickerController = Get.put(ImageController());
  final TextEditingController _descriptionTController = TextEditingController();
  final DescriptionController descriptionController = Get.put(
    DescriptionController(),
  );

  CreateCompanyAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,

      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const SizedBox(height: 51),
              Text(
                "Create Company Account",
                style: TextStyle(
                  color: AppColors.textBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                "Sign-up and pitch your way into a new role",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 28),

              // const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload company elevator pitch",
                    style: TextStyle(
                      color: AppColors.textBlack,
                      fontSize: 18,
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
                          const SizedBox(
                            height: 18,
                            width: 18,
                            child: Image(
                              image: AssetImage('assets/icons/gallery.png'),
                            ),
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
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  // same as container
                                  child: Image.file(
                                    bannerPickerController.selectedImage.value!,
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit
                                        .cover, // makes image fill the container
                                  ),
                                )
                              : const Text(
                                  'company banner',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
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
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      // same as container
                                      child: Image.file(
                                        imagePickerController
                                            .selectedImage
                                            .value!,
                                        height: 130,
                                        width: 130,
                                        fit: BoxFit
                                            .cover, // makes image fill the container
                                      ),
                                    )
                                  : const Text(
                                      'Company logo',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
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

              // Upload Elevator Pitch
              // VideoUploadCardWidget(
              //   title: "Upload your Video pitch",
              //   subtitle: "Drop your video here or click to browswer",
              //   buttonText: "Upload Elevator Pitch",
              //   fileType:
              //       "Upload your Video pitch \n Drop your video here or click to browswer \n Choose File",
              //   // isChecked: true,
              //   // onChanged: (value) {},
              //   onTap: () {
              //     Get.to(() => VideoUploadScreen());
              //   },
              // ),

              // const SizedBox(height: 24),

              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     "Company Banner",
              //     style: TextStyle(
              //       color: AppColors.textBlack,
              //       fontSize: 18,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 8),

              // // Company Banner
              // UploadCardWidget(
              //   title: "Upload banner",
              //   subtitle:
              //       "Upload and crop a banner image to enhance your resume profile.",
              //   buttonText: "Upload Banner",
              //   fileType:
              //       "Drop your file here \n Supports JPG, PNG • Max 10MB • Will be cropped to 300px height \n Choose File",
              // ),
              // const SizedBox(height: 24),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     "Company Logo",
              //     style: TextStyle(
              //       color: AppColors.textBlack,
              //       fontSize: 18,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 8),

              // // Company Logo
              // UploadCardWidget(
              //   title: "",
              //   subtitle: "",
              //   buttonText: "Upload Logo",
              //   fileType: "Drop your file here\nChoose Logo",
              // ),

              // const SizedBox(height: 24),

              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     "About Us",
              //     style: TextStyle(
              //       color: AppColors.buttonText,
              //       fontSize: 18,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 8),
              CustomTextField(
                maxLines: 5,
                controller: controller.aboutUsController, // ✅ bind
                label: 'About Us',

                isRequired: false,
                hintText: "Write here",
              ),
              const SizedBox(height: 8),
              CustomTextField(
                label: 'Company Name',

                isRequired: true,
                hintText: "Enter Your Country Name",
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
                      hintText: "Enter Code",
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    // child: CustomTextField(
                    //   label: 'Email',
                    //   controller: controller.emailController,
                    //   isRequired: true,
                    //   keyboardType: TextInputType.emailAddress,
                    //   hintText: "Enter your email",
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return "Email is required";
                    //     }
                    //     final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    //     if (!regex.hasMatch(value)) {
                    //       return "Enter a valid email address";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    child: CustomTextField(
                      label: "Email",
                      controller: controller.emailController, // ✅ bind
                      hintText: "Enter Your Email",
                      isRequired: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomTextField(
                label: 'Contact Number',
                controller: controller.contactNumberController, // ✅ bind

                isRequired: true,
                hintText: "+49 97 23917 3740",
              ),

              // CustomTextField(
              //   label: 'Contact Number',
              //   controller: controller.contactNumberController,
              //   isRequired: true,
              //   hintText: "+49 97 23917 3740",
              //   keyboardType: TextInputType.phone,
              //   validator: (value) {
              //     if (value == null || value.trim().isEmpty) {
              //       return "Contact number is required";
              //     }
              //     final regex = RegExp(
              //       r'^[+0-9\s]+$',
              //     ); // allow +, numbers, spaces
              //     if (!regex.hasMatch(value)) {
              //       return "Enter a valid phone number";
              //     }
              //     if (value.replaceAll(RegExp(r'[^0-9]'), '').length < 8) {
              //       return "Phone number must be at least 8 digits";
              //     }
              //     return null;
              //   },
              // ),
              const SizedBox(height: 8),
              CustomTextField(
                label: 'Website URL',
                controller: controller.websiteController, // ✅ bind

                isRequired: true,
                hintText: "Enter Here",
              ),
              const SizedBox(height: 8),
              CustomTextField(
                label: 'Linkedin URL',
                controller: controller.linkedInController, // ✅ bind

                isRequired: true,
                hintText: "Enter Here",
              ),
              const SizedBox(height: 8),
              CustomTextField(
                label: 'Twitter-X URL',
                controller: controller.twitterController, // ✅ bind

                isRequired: true,
                hintText: "Enter Here",
              ),
              const SizedBox(height: 8),
              CustomTextField(
                label: 'Upwork URL',
                controller: controller.upworkController, // ✅ bind

                isRequired: true,
                hintText: "Enter Here",
              ),
              const SizedBox(height: 8),

              // CustomTextField(
              //   label: 'Other Business Website',

              //   isRequired: true,
              //   hintText: "Enter Here",
              // ),
              // const SizedBox(height: 8),
              // CustomTextField(
              //   label: 'Industry',

              //   isRequired: true,
              //   hintText: "Select Industry",
              // ),
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
                  "View your Company recruiters",
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
                    child: CustomTextField(
                      label: "Add Profiles of Recruiters",
                      hintText: "Add Here",
                      controller: controller.employeeControllers[0],
                      isRequired: true,
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
                              child: CustomTextField(
                                label: "Recruiter ${index + 1}",
                                hintText: "Enter recruiter profile",
                                controller:
                                    controller.employeeControllers[index],
                                isRequired: true,
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Award Description*",
                  style: TextStyle(
                    color: AppColors.textBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 7),

              Obx(() {
                final showFields = controller.awardFields.isNotEmpty;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Award & Honors",
                        style: TextStyle(
                          color: const Color(0xFF0A0A0A),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Highlight your achievements and recognitions.",
                        style: TextStyle(
                          color: const Color(0xFF2A2A2A),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 12),

                      const SizedBox(height: 12),

                      // Dynamic Award Fields inside the same container
                      Column(
                        children: List.generate(controller.awardFields.length, (
                          index,
                        ) {
                          final fields = controller.awardFields[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextField(
                                  label: "Award Title",
                                  hintText: "e.g.Employee of the Year",
                                  controller: fields['title'],
                                  isRequired: true,
                                ),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  label: "Program Name",
                                  hintText: "e.g. Company Recognition Program",
                                  controller: fields['issuer'],
                                  isRequired: true,
                                ),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  label: "Program Date",
                                  hintText: "MMYYYY",
                                  controller: fields['date'],
                                  isRequired: true,
                                ),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  label: "Award Short Description",
                                  hintText: "Briefly describe the award",
                                  controller: fields['description'],
                                  isRequired: true,
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        controller.removeAwardField(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[100],
                                      foregroundColor: Colors.red[800],
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    child: const Text("Remove Award"),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),

                      // Add Award Button always at bottom
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: controller.addAwardField,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFFFFFFF,
                            ), // white background
                            foregroundColor: Colors.black, // text color
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
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
                          child: const Text("Add Award"),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Save Button
              PrimaryButton(
                text: "Save",
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    controller.saveForm();
                    Get.to(
                      () => CompanyDetailsPage(),
                      transition: Transition.rightToLeft,
                    );
                  }
                },
                width: double.infinity, // optional
                height: 45, // optional
              ),
            ],
          ),
        ),
      ),
    );
  }
}
