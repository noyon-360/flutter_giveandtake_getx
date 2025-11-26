import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ElevatorResumeController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  // Rich text controller for About Me
  late final quill.QuillController aboutMeQuillController;


  /// ================== ABOUT ME EDITOR ==================
  final aboutMeController = TextEditingController();

  var aboutMeHeading = 'Normal'.obs;                // Normal / Heading 1 / 2 / 3
  var aboutMeIsBold = false.obs;
  var aboutMeIsItalic = false.obs;
  var aboutMeIsUnderline = false.obs;
  var aboutMeTextAlign = TextAlign.left.obs;        // left / center / right
  var aboutMeWordCount = 0.obs;

  /// ================== SELECTED VALUES ==================
  var selectedTitle = 'Mr.'.obs;
  var selectedCountry = Rx<String?>(null);
  var selectedCity = Rx<String?>(null);

  var selectedJobTitle = Rx<String?>(null);
  var selectedStartMonth = Rx<String?>(null);
  var selectedStartYear = Rx<String?>(null);
  var selectedEndMonth = Rx<String?>(null);
  var selectedEndYear = Rx<String?>(null);
  var selectedAvailability = Rx<String?>(null);
  var selectedJobCategory = Rx<String?>(null);
  var selectedDegree = Rx<String?>(null);
  var selectedGradMonth = Rx<String?>(null);
  var selectedGradYear = Rx<String?>(null);

  /// Immediately Available checkbox
  var immediatelyAvailable = false.obs;

  /// ================== FILE PATHS ==================
  var elevatorVideoPath = Rx<String?>(null);
  var photoPath = Rx<String?>(null);
  var bannerImagePath = Rx<String?>(null);

  /// ================== DYNAMIC LISTS ==================
  // each experience map can hold more fields later (company, role, etc.)
  var experienceList = <Map<String, dynamic>>[
    {'presentlyWorkHere': false},
  ].obs;

  var educationList = <Map<String, dynamic>>[
    {'presentlyAttendHere': false},
  ].obs;

  var awardsList = <Map<String, dynamic>>[{}].obs;

  /// Skills chips
  var skillsList = <String>[].obs;

  /// Other custom URLs
  var otherUrlsList = <String>[].obs;

  /// Certifications list (shown under Certifications section)
  var certifications = <String>[].obs;

  /// Languages list (chips under Languages)
  var languages = <String>[].obs;

  /// ================== DUMMY DATA ==================
  final List<String> titles = ['Mr.', 'Mrs.', 'Ms.', 'Dr.'];

  final List<String> countries = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Germany',
    'France',
    'India',
    'China',
    'Japan',
  ];

  /// For simplicity, ekta static list use korchi. Ichcha korle per-country map banate paro.
  final List<String> cities = [
    'New York',
    'London',
    'Toronto',
    'Sydney',
    'Berlin',
    'Paris',
    'Mumbai',
    'Beijing',
    'Tokyo',
  ];

  final List<String> jobTitles = [
    'Software Engineer',
    'Product Manager',
    'Designer',
    'Data Scientist',
    'Marketing Manager',
    'Sales Executive',
    'HR Manager',
    'Business Analyst',
  ];

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final List<String> years = List.generate(
    50,
        (index) => (DateTime.now().year - index).toString(),
  );

  final List<String> availabilities = [
    'Immediately',
    'Within 2 weeks',
    'Within 1 month',
    'Within 2 months',
    'Within 3 months',
  ];

  final List<String> jobCategories = [
    'Technology',
    'Healthcare',
    'Finance',
    'Education',
    'Marketing',
    'Sales',
    'Human Resources',
    'Design',
    'Engineering',
  ];

  final List<String> degrees = [
    'High School',
    'Associate Degree',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'Doctorate',
    'Professional Certificate',
  ];

  /// ================== LIFECYCLE ==================
  @override
  void onInit() {
    super.onInit();

    aboutMeQuillController = quill.QuillController.basic();

    // word count update
    aboutMeQuillController.addListener(_updateWordCountFromQuill);
  }

  void _updateWordCountFromQuill() {
    final plain = aboutMeQuillController.document.toPlainText().trim();
    if (plain.isEmpty) {
      aboutMeWordCount.value = 0;
    } else {
      aboutMeWordCount.value =
          plain.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    }
  }

  @override
  void onClose() {
    aboutMeQuillController.dispose();
    super.onClose();
  }


  /// ================== ABOUT ME ACTIONS ==================
  void setAboutMeHeading(String heading) {
    aboutMeHeading.value = heading;
  }

  void toggleAboutMeBold() {
    aboutMeIsBold.value = !aboutMeIsBold.value;
  }

  void toggleAboutMeItalic() {
    aboutMeIsItalic.value = !aboutMeIsItalic.value;
  }

  void toggleAboutMeUnderline() {
    aboutMeIsUnderline.value = !aboutMeIsUnderline.value;
  }

  void setAboutMeAlign(TextAlign align) {
    aboutMeTextAlign.value = align;
  }

  /// ================== PICKERS ==================
  Future<void> pickElevatorVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        elevatorVideoPath.value = video.path;
        Get.snackbar('Success', 'Video selected successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick video: $e');
    }
  }

  Future<void> pickPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        photoPath.value = image.path;
        Get.snackbar('Success', 'Photo selected successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick photo: $e');
    }
  }

  /// Banner image (for “Drop your banner image here”)
  Future<void> pickBannerImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        bannerImagePath.value = image.path;
        Get.snackbar('Success', 'Banner image selected successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick banner image: $e');
    }
  }

  /// ================== DROPDOWN HELPERS ==================
  void onCountryChanged(String? value) {
    selectedCountry.value = value;
    // jodi per-country city list korte chao, ekhane handle korbe
  }

  /// ================== EXPERIENCE / EDUCATION / AWARDS ==================
  void addExperience() {
    experienceList.add({'presentlyWorkHere': false});
  }

  void addEducation() {
    educationList.add({'presentlyAttendHere': false});
  }

  void addAward() {
    awardsList.add({});
  }

  void removeExperience(int index) {
    if (experienceList.length > 1) {
      experienceList.removeAt(index);
    }
  }

  void removeEducation(int index) {
    if (educationList.length > 1) {
      educationList.removeAt(index);
    }
  }

  void removeAward(int index) {
    if (awardsList.length > 1) {
      awardsList.removeAt(index);
    }
  }

  void togglePresentlyWorkHere(int index) {
    experienceList[index]['presentlyWorkHere'] =
    !(experienceList[index]['presentlyWorkHere'] ?? false);
    experienceList.refresh();
  }

  void togglePresentlyAttendHere(int index) {
    educationList[index]['presentlyAttendHere'] =
    !(educationList[index]['presentlyAttendHere'] ?? false);
    educationList.refresh();
  }

  /// ================== SKILLS ==================
  void addSkill(String skill) {
    final s = skill.trim();
    if (s.isNotEmpty && !skillsList.contains(s)) {
      skillsList.add(s);
    }
  }

  void removeSkill(int index) {
    skillsList.removeAt(index);
  }

  /// ================== OTHER URLS ==================
  void addOtherUrl() {
    otherUrlsList.add('');
  }

  void removeOtherUrl(int index) {
    if (otherUrlsList.isNotEmpty) {
      otherUrlsList.removeAt(index);
    }
  }

  /// ================== CERTIFICATIONS ==================
  void addCertification() {
    final textController = TextEditingController();

    Get.defaultDialog(
      title: 'Add Certification',
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(
          hintText: 'e.g. AWS Certified Solutions Architect',
        ),
      ),
      textConfirm: 'Add',
      textCancel: 'Cancel',
      onConfirm: () {
        final text = textController.text.trim();
        if (text.isNotEmpty) {
          certifications.add(text);
        }
        Get.back();
      },
      onCancel: () {},
    );
  }

  /// ================== LANGUAGES ==================
  void addLanguage(String lang) {
    final l = lang.trim();
    if (l.isNotEmpty && !languages.contains(l)) {
      languages.add(l);
    }
  }

  void removeLanguage(String lang) {
    languages.remove(lang);
  }

  /// ================== SUBMIT / SAVE ==================
  void saveResume() {
    // TODO: Backend call / form validation
    Get.snackbar('Success', 'Resume saved successfully!');
  }

  /// Used by the big bottom button: "Upload Elevator Pitch First"
  void onUploadElevatorPitchFirst() {
    if (elevatorVideoPath.value == null) {
      Get.snackbar(
        'Upload required',
        'Please upload your Elevator Video Pitch before submitting the form.',
      );
      return;
    }

    // jodi video thake, tahole actual save
    saveResume();
  }
}
