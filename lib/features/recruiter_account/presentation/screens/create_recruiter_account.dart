import 'package:flutter/material.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/company_image_controller.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/image_controller.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/video_upload_screen.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
import '../controller/country_city_controller.dart';
import '../controller/description_controller.dart';
import '../controller/recruiter_controller.dart';
import '../controller/upload_elevator_pitch.dart';
import '../widgets/bio.dart';
import '../widgets/country_city_searchable_dropdown.dart';
import '../widgets/name.dart';
import '../widgets/phone_number.dart';
import '../widgets/select_company.dart';
import '../widgets/video_player_widget.dart';

class CreateRecruiterAccount extends StatefulWidget {
  const CreateRecruiterAccount({super.key});

  @override
  State<CreateRecruiterAccount> createState() => _CreateRecruiterAccountState();
}

class _CreateRecruiterAccountState extends State<CreateRecruiterAccount> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  final TextEditingController _descriptionTController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _surNameTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _phoneNumberTEController = TextEditingController();
  final TextEditingController _currentPositionTEController = TextEditingController();
  final TextEditingController _postalCodeTEController = TextEditingController();
  final TextEditingController _linkedINTEController = TextEditingController();
  final TextEditingController _twitterTEController = TextEditingController();
  final TextEditingController _upworkTEController = TextEditingController();
  final TextEditingController _facebookTEController = TextEditingController();
  final TextEditingController _instaTEController = TextEditingController();
  final TextEditingController _tiktokTEController = TextEditingController();
  final TextEditingController _fiverrTEController = TextEditingController();
  final TextEditingController _companyTEController = TextEditingController();

  final recruiterController = Get.find<RecruiterController>();

  late int zipCode = int.tryParse(_postalCodeTEController.text) ?? 0;

  final ImageController imagePickerController = Get.put(ImageController());
  final CompanyImageController bannerPickerController = Get.put(
      CompanyImageController());

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _surNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _currentPositionFocusNode = FocusNode();
  final FocusNode _postalCodeFocusNode = FocusNode();
  final FocusNode _linkedINFocusNode = FocusNode();
  final FocusNode _twitterFocusNode = FocusNode();
  final FocusNode _upworkFocusNode = FocusNode();
  final FocusNode _facebookFocusNode = FocusNode();
  final FocusNode _instaFocusNode = FocusNode();
  final FocusNode _tiktokFocusNode = FocusNode();
  final FocusNode _fiverrFocusNode = FocusNode();
  final FocusNode _companyFocusNode = FocusNode();

  final LocationController controller = Get.put(LocationController());

  final DescriptionController descriptionController = Get.put(
    DescriptionController(),
  );
  final ElevatorPitchController elevatorPitchController = Get.put(
    ElevatorPitchController(),
  );

  _submit() {
    recruiterController.createRecruiterScreen(
        bannerPickerController.selectedImage.value!,
        imagePickerController.selectedImage.value!,
        _descriptionTController.text,
        _firstNameTEController.text,
        _surNameTEController.text,
        _emailTEController.text,
        _phoneNumberTEController.text,
        _currentPositionTEController.text,
        controller.selectedCountry.toString(),
        controller.selectedCity.toString(),
        zipCode,
        _linkedINTEController.text,
        _twitterTEController.text,
        _upworkTEController.text,
        _facebookTEController.text,
        _tiktokTEController.text,
        _instaTEController.text,_fiverrTEController.text, _companyTEController.text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffold(
        appBar: AppBar(
          title: const Text(
            'Create Recruiter Account',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4D4D4D),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ElevatedButton(onPressed: (){Get.find<RecruiterController>().logout();} , child: Text('Logout')),
                  const Text(
                    'Upload Your Elevator Speech (Optional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4D4D4D),
                    ),
                  ),
                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Upload a 60-second elevator video''pitch introducing your agency and what'
                              'makes you stand out from the rest!',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF4D4D4D),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Get.to(VideoUploadScreen());
                    },
                    child: Obx(() {
                      if (recruiterController.successVideoUploaded.value &&
                          recruiterController.uploadedVideoPath.value
                              .isNotEmpty) {
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
                              videoPath: recruiterController.uploadedVideoPath
                                  .value,
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
                                child: Image(image: AssetImage(
                                    'assets/icons/gallery.png')),
                              ),
                              const SizedBox(height: 7),
                              const Text(
                                'Drop your files here',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                              const SizedBox(height: 9.5),
                              const Text(
                                'Choose file',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
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
                              bannerPickerController.selectedImage.value !=
                                  null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                // same as container
                                child: Image.file(
                                  bannerPickerController
                                      .selectedImage
                                      .value!,
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

                          SizedBox(height: 10),
                        ],
                      ),

                      SizedBox(width: 15),

                      Bio(descriptionTController: _descriptionTController, descriptionController: descriptionController),
                    ],
                  ),

                  SizedBox(height: 14),

                  Name(firstNameTEController: _firstNameTEController, firstNameFocusNode: _firstNameFocusNode, surNameTEController: _surNameTEController, surNameFocusNode: _surNameFocusNode),

                  SizedBox(height: 9),

                  PhoneNumberAndEmail(emailTEController: _emailTEController, emailFocusNode: _emailFocusNode),

                  SizedBox(height: 9),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Position*',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 6),
                            TextFormField(
                              controller: _currentPositionTEController,
                              focusNode: _currentPositionFocusNode,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: context.primaryInputDecoration.copyWith(
                                hintText: "Enter current position",
                                hintStyle: TextStyle(
                                  color: Color(0xFF787878),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Current position is required';
                                }
                                return null;
                              },

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
                              'Phone Number*',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 6),
                            TextFormField(
                              controller: _phoneNumberTEController,
                              keyboardType: TextInputType.phone,
                              focusNode: _phoneNumberFocusNode,
                              textInputAction: TextInputAction.next,
                              decoration: context.primaryInputDecoration.copyWith(
                                hintText: "+49 97 25917 3740",
                                hintStyle: TextStyle(
                                  color: Color(0xFF787878),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              validator: Validators.phone,
                            ),
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
                              'Zip/Postal Code (Optional)',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 6),
                            TextFormField(
                              controller: _postalCodeTEController,
                              focusNode: _postalCodeFocusNode,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration: context.primaryInputDecoration.copyWith(
                                hintText: "Enter Zip/Postal Code",
                                hintStyle: TextStyle(
                                  color: Color(0xFF787878),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

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

                  SocialLink(linkedINTEController: _linkedINTEController,
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
                    fiverrTEController: _fiverrTEController,
                    fiverrFocusNode: _fiverrFocusNode,
                    companyTEController: _companyTEController,
                    companyFocusNode: _companyFocusNode,),

                  SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;

                        if (bannerPickerController.selectedImage.value == null) {
                          Get.snackbar('Error', 'Company banner is required');
                          return;
                        }

                        if (imagePickerController.selectedImage.value == null) {
                          Get.snackbar('Error', 'Profile image is required');
                          return;
                        }

                        _submit();
                      },

                      // onPressed: () {
                      //   _submit();
                      //   // if(recruiterController.successVideoUploaded.value){
                      //   //   _submit();
                      //
                      //   // }
                      // },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
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
                ],
              ),
            ),
          ),
        ),
      ),
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
    required TextEditingController fiverrTEController,
    required FocusNode fiverrFocusNode,
    required TextEditingController companyTEController,
    required FocusNode companyFocusNode,
  }) : _linkedINTEController = linkedINTEController, _linkedINFocusNode = linkedINFocusNode, _twitterTEController = twitterTEController, _twitterFocusNode = twitterFocusNode, _upworkTEController = upworkTEController, _upworkFocusNode = upworkFocusNode, _facebookTEController = facebookTEController, _facebookFocusNode = facebookFocusNode, _tiktokTEController = tiktokTEController, _tiktokFocusNode = tiktokFocusNode, _instaTEController = instaTEController, _instaFocusNode = instaFocusNode, _fiverrTEController = fiverrTEController, _fiverrFocusNode = fiverrFocusNode, _companyTEController= companyTEController, _companyFocusNode = companyFocusNode;

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
  final TextEditingController _companyTEController;
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
                        'Professional Social Media and Website Links',
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
                        controller: _companyTEController,
                        focusNode: _companyFocusNode,
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
    );
  }
}





