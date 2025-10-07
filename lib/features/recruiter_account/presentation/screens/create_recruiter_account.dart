import 'package:flutter/material.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';
import 'package:karlfive/features/recruiter_account/presentation/widgets/experience_dropdown.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../controller/country_city_controller.dart';
import '../controller/description_controller.dart';
import '../controller/recruiter_controller.dart';
import '../controller/upload_elevator_pitch.dart';
import '../widgets/country_city_searchable_dropdown.dart';
import '../widgets/select_company.dart';

class CreateRecruiterAccount extends StatefulWidget {
  const CreateRecruiterAccount({super.key});

  @override
  State<CreateRecruiterAccount> createState() => _CreateRecruiterAccountState();
}

class _CreateRecruiterAccountState extends State<CreateRecruiterAccount> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _surNameTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _phoneNumberTEController =
      TextEditingController();
  final TextEditingController _currentPositionTEController =
      TextEditingController();
  final TextEditingController _postalCodeTEController = TextEditingController();
  final TextEditingController _linkedINTEController = TextEditingController();
  final TextEditingController _twitterTEController = TextEditingController();
  final TextEditingController _upworkTEController = TextEditingController();
  final TextEditingController _facebookTEController = TextEditingController();
  final TextEditingController _instaTEController = TextEditingController();
  final TextEditingController _tiktokTEController = TextEditingController();

  final RecruiterController reCruiController = Get.find<RecruiterController>();

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

  final LocationController controller = Get.put(LocationController());

  final DescriptionController descriptionController = Get.put(
    DescriptionController(),
  );
  final ElevatorPitchController elevatorPitchController = Get.put(
    ElevatorPitchController(),
  );

  final countryChoose = ''.obs;
  final cityChoose = ''.obs;

  // This will hold the current country code for city picker
  String? selectedCountryCode;

  /// 🔍 Custom Searchable List Dialog
  void _showSearchDialog({
    required BuildContext context,
    required String title,
    required List<String> items,
    required Function(String?) onSelected,
  }) {
    final TextEditingController searchController = TextEditingController();
    List<String> filteredItems = List.from(items);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(title),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: Column(
                children: [
                  // 🔎 Search Field
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredItems = items
                            .where(
                              (item) => item.toLowerCase().contains(
                                value.toLowerCase(),
                              ),
                            )
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  // 📜 Scrollable List
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return ListTile(
                          title: Text(item),
                          onTap: () {
                            onSelected(item); // ✅ safe call
                            Get.back();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    const Expanded(
                      child: Text(
                        'Upload a 60-second elevator video'
                        'pitch introducing your agency and what'
                        'makes you stand out from the rest!',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4D4D4D),
                        ),
                      ),
                    ),

                    SizedBox(width: 16),


                  ],
                ),

                SizedBox(height: 16),
                GestureDetector(
                  onTap: elevatorPitchController.isUploading.value
                      ? null
                      : elevatorPitchController.pickAndUploadVideo,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0xFF191919),
                    ),
                    height: 105,
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
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        SizedBox(height: 9.5),
                        Text(
                          'Choose file',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFD9D9D9),
                          ),
                        ),
                        SizedBox(height: 6),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2B7FD0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                6,
                              ), // custom shape
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            'photo/recruiter logo',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: 10),

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
                          TextField(
                            controller: _controller,
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
                                _controller.text = words.join(' ');
                                _controller
                                    .selection = TextSelection.fromPosition(
                                  TextPosition(offset: _controller.text.length),
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
                          TextFormField(
                            controller: _emailTEController,
                            focusNode: _emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: context.primaryInputDecoration.copyWith(
                              hintText: "Enter Your Email",
                              hintStyle: TextStyle(
                                color: Color(0xFF787878),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            validator: Validators.email,
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
                            'Years of Experience*',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 6),
                          ExperienceDropdown(),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 9),

                CountryCitySearchableDropdown(controller: controller),

                SizedBox(height: 9),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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

                SizedBox(height: 15),
                Text(
                  'View your company',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                          const SizedBox(height: 20),
                          // Obx(() {
                          //   final selected = reCruiController.selectedCompany.value;
                          //   return selected != null
                          //       ? Text("Selected: ${selected.cname}")
                          //       : const Text("No company selected");
                          // }),

                          SizedBox(height: 12),

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

                SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: Text('Save', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
