import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';
import 'package:karlfive/features/recruiter_account/data/models/get_recruiter_response_model.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/company_image_controller.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/recruiter_page.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/video_upload_screen.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../controller/country_city_controller.dart';
import '../controller/description_controller.dart';
import '../controller/image_controller.dart';
import '../controller/recruiter_controller.dart';
import '../controller/upload_elevator_pitch.dart';
import '../widgets/country_city_searchable_dropdown.dart';
import '../widgets/select_company.dart';

class EditProfilePage extends StatefulWidget {
  final FetchRecruiterResponseModel recruiterResponseModel;

  const EditProfilePage({super.key, required this.recruiterResponseModel});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _biocontroller = TextEditingController();
  late TextEditingController _firstNameTEController = TextEditingController();
  late TextEditingController _surNameTEController = TextEditingController();
  final TextEditingController _linkedINTEController = TextEditingController();
  final TextEditingController _twitterTEController = TextEditingController();
  final TextEditingController _upworkTEController = TextEditingController();
  final TextEditingController _facebookTEController = TextEditingController();
  final TextEditingController _instaTEController = TextEditingController();
  final TextEditingController _tiktokTEController = TextEditingController();

  final RecruiterController reCruiController = Get.find<RecruiterController>();

  final ImageController imagePickerController = Get.put(ImageController());
  final CompanyImageController companyImageController = Get.put(CompanyImageController());

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _surNameFocusNode = FocusNode();
  final FocusNode _linkedINFocusNode = FocusNode();
  final FocusNode _twitterFocusNode = FocusNode();
  final FocusNode _upworkFocusNode = FocusNode();
  final FocusNode _facebookFocusNode = FocusNode();
  final FocusNode _instaFocusNode = FocusNode();
  final FocusNode _tiktokFocusNode = FocusNode();

  late LocationController controller = Get.put(LocationController());

  final DescriptionController descriptionController = Get.put(DescriptionController());
  final ElevatorPitchController elevatorPitchController = Get.put(ElevatorPitchController());

  @override
  void initState() {
    super.initState();
    final recruiter = widget.recruiterResponseModel;

    // Text fields
    _biocontroller.text = recruiter.bio;
    _firstNameTEController.text = recruiter.firstName;
    _surNameTEController.text = recruiter.sureName ?? '';
    _linkedINTEController.text = recruiter.sLink.firstWhere(
            (e) => e.label.toLowerCase() == "linkedin",
        orElse: () => SocialLink(label: '', url: '')
    ).url ?? '';
    _twitterTEController.text = recruiter.sLink.firstWhere(
            (e) => e.label.toLowerCase() == "twitter",
        orElse: () => SocialLink(label: '', url: '')
    ).url ?? '';
    _upworkTEController.text = recruiter.sLink.firstWhere(
            (e) => e.label.toLowerCase() == "upwork",
        orElse: () => SocialLink(label: '', url: '')
    ).url ?? '';
    _facebookTEController.text = recruiter.sLink.firstWhere(
            (e) => e.label.toLowerCase() == "facebook",
        orElse: () => SocialLink(label: '', url: '')
    ).url ?? '';
    _tiktokTEController.text = recruiter.sLink.firstWhere(
            (e) => e.label.toLowerCase() == "tiktok",
        orElse: () => SocialLink(label: '', url: '')
    ).url ?? '';
    _instaTEController.text = recruiter.sLink.firstWhere(
            (e) => e.label.toLowerCase() == "instagram",
        orElse: () => SocialLink(label: '', url: '')
    ).url ?? '';

    // Preload banner & logo URLs
    if (recruiter.banner.isNotEmpty) {
      companyImageController.existingImageUrl.value = recruiter.banner;
    }
    if (recruiter.photo.isNotEmpty) {
      imagePickerController.existingImageUrl.value = recruiter.photo;
    }

    // Country & city
    controller.selectedCountry.value = recruiter.country;
    controller.selectedCity.value = recruiter.city;

    // ✅ Set previously selected company
    if (recruiter.companyId != null) {
      reCruiController.selectedCompany.value = recruiter.companyId!.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner & Logo
                SizedBox(
                  height: 230,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: companyImageController.showPickerOptions,
                          child: Obx(() {
                            final file = companyImageController.selectedImage.value;
                            final url = companyImageController.existingImageUrl.value;
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color(0xFF191919),
                              ),
                              height: 150,
                              child: file != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  file,
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : url.isNotEmpty
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  url,
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : Column(
                                children: [
                                  SizedBox(height: 20),
                                  SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: Image.asset('assets/icons/gallery.png'),
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    'Edit Company Banner',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 9.5),
                                  Text(
                                    'Choose file',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 30,
                        child: GestureDetector(
                          onTap: imagePickerController.showPickerOptions,
                          child: Obx(() {
                            final file = imagePickerController.selectedImage.value;
                            final url = imagePickerController.existingImageUrl.value;
                            return Container(
                              height: 110,
                              width: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFFD9D9D9),
                              ),
                              child: Center(
                                child: file != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    file,
                                    height: 110,
                                    width: 110,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                    : url.isNotEmpty
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    url,
                                    height: 110,
                                    width: 110,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                    : const Text(
                                  'photo/recruiter logo',
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
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Elevator Pitch
                Text(
                  'Elevator Pitch',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 3),
                Text(
                  'Upload or view a short video introducing yourself.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Color(0xFF999999),
                        width: .5,
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(VideoUploadScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFF191919),
                        ),
                        height: 160,
                        width: double.infinity,
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            SizedBox(
                              height: 18,
                              width: 18,
                              child: Image.asset('assets/icons/gallery.png'),
                            ),
                            SizedBox(height: 7),
                            Text(
                              'Drop your files here',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 9.5),
                            Text(
                              'Choose file',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About Us*',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF000000),
                            ),
                          ),

                          SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                width: 1,
                                color: Color(0xFF999999)
                              )
                            ),
                            child: TextField(
                              controller: _biocontroller,
                              maxLines: 8,
                              minLines: 3,
                              onChanged: (value) {
                                int currentWords = descriptionController
                                    .countWords(value);

                                if (currentWords >
                                    descriptionController.maxWords) {
                                  final words = value
                                      .trim()
                                      .split(RegExp(r'\s+'))
                                      .take(descriptionController.maxWords);
                                  _biocontroller.text = words.join(' ');
                                  _biocontroller
                                      .selection = TextSelection.fromPosition(
                                    TextPosition(offset: _biocontroller.text.length),
                                  );
                                  descriptionController.wordCount.value =
                                      descriptionController.maxWords;
                                } else {
                                  descriptionController.wordCount.value =
                                      currentWords;
                                }
                              },

                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFFAFAFA),
                                hintText:
                                'Write your description (max 400 words)',
                                hintStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF787878),
                                ),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  //  Makes it circular
                                  borderSide:
                                  BorderSide.none, // Removes border line
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  //Circular when enabled
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  // Circular when focused
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Obx(
                                () => Text(
                              '${descriptionController.wordCount.value} / ${descriptionController.maxWords} words',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                descriptionController.wordCount.value >
                                    descriptionController.maxWords
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'First Name*',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 6),
                          TextFormField(
                            controller: _firstNameTEController,
                            focusNode: _firstNameFocusNode,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: context.primaryInputDecoration.copyWith(
                              hintText: "Enter Your First Name",
                              hintStyle: TextStyle(
                                color: Color(0xFF787878),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            validator: Validators.name,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 19),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Surname (Optional)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 6),
                          TextFormField(
                            controller: _surNameTEController,
                            keyboardType: TextInputType.name,
                            focusNode: _surNameFocusNode,
                            textInputAction: TextInputAction.next,
                            decoration: context.primaryInputDecoration.copyWith(
                              hintText: "Enter Your Surname",
                              hintStyle: TextStyle(
                                color: Color(0xFF787878),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            validator: Validators.name,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 9),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email Address*',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 6),
                        ],
                      ),
                    ),

                  ],
                ),

                SizedBox(height: 9),

                CountryCitySearchableDropdown(controller: controller),

                SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Company',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 6),
                          CompanyDropdown(),
                        ],
                      ),
                    ),
                  ],
                ),

                // Row(
                //   children: [
                //     Expanded(
                //       child:
                //     ),
                //
                //     SizedBox(width: 19,),
                //     Expanded(
                //       child:
                //     )
                //   ],
                // ),
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
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    decoration: context.primaryInputDecoration
                                        .copyWith(
                                      hintText: "Enter Here",
                                      hintStyle: TextStyle(
                                        color: Color(0xFF787878),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    validator: Validators.name,
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
                                    decoration: context.primaryInputDecoration
                                        .copyWith(
                                      hintText: "Enter Here",
                                      hintStyle: TextStyle(
                                        color: Color(0xFF787878),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    validator: Validators.name,
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
                                    decoration: context.primaryInputDecoration
                                        .copyWith(
                                      hintText: "Enter Here",
                                      hintStyle: TextStyle(
                                        color: Color(0xFF787878),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    validator: Validators.name,
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
                                    decoration: context.primaryInputDecoration
                                        .copyWith(
                                      hintText: "Enter Here",
                                      hintStyle: TextStyle(
                                        color: Color(0xFF787878),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    validator: Validators.name,
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
                                    decoration: context.primaryInputDecoration
                                        .copyWith(
                                      hintText: "Enter Here",
                                      hintStyle: TextStyle(
                                        color: Color(0xFF787878),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    validator: Validators.name,
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
                                    decoration: context.primaryInputDecoration
                                        .copyWith(
                                      hintText: "Enter Here",
                                      hintStyle: TextStyle(
                                        color: Color(0xFF787878),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    validator: Validators.name,
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

                SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(

                  width: 150,
                  child: ElevatedButton(
                    onPressed: () async {
                      await reCruiController.updateRecruiter(
                        companyImageController.selectedImage.value, // nullable banner
                        imagePickerController.selectedImage.value,  // nullable photo
                        _biocontroller.text,
                        _firstNameTEController.text,
                        _surNameTEController.text,
                        widget.recruiterResponseModel.title,
                        controller.selectedCountry.toString(),
                        controller.selectedCity.toString(),
                        _linkedINTEController.text,
                        _twitterTEController.text,
                        _upworkTEController.text,
                        _facebookTEController.text,
                        _tiktokTEController.text,
                        _instaTEController.text,
                      );
                  
                      if (reCruiController.errorMessage.value.isEmpty) {
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2B7FD0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          5,
                        ),
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

                SizedBox(width: 10,),

                Container(
                  width: 150,
                  child: ElevatedButton(onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2B7FD0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                    ),
                  ), child: Text('Cancle', style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),)),
                )
              ],
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
