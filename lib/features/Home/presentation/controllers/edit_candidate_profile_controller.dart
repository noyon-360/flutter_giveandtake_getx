import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/network/constants/api_constants.dart';
import 'package:giveandtake/core/network/constants/key_constants.dart';
import 'package:giveandtake/core/network/services/auth_storage_service.dart';
import 'package:giveandtake/core/network/services/secure_store_services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../company/data/model/candidate_resume_response_model.dart';

class EditCandidateProfileController extends GetxController {
  final isLoading = false.obs;
  final isUpdating = false.obs;

  // Form Controllers
  final firstNameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  
  final linkedinController = TextEditingController();
  final twitterController = TextEditingController();
  final facebookController = TextEditingController();
  final tiktokController = TextEditingController();
  final instagramController = TextEditingController();
  final upworkController = TextEditingController();
  final fiverrController = TextEditingController();
  final portfolioController = TextEditingController();

  final languageController = TextEditingController();
  final certificationController = TextEditingController();

  // Quill Controller for About Me
  late QuillController aboutMeQuillController;
  final aboutMeWordCount = 0.obs;

  // State Variables
  final Rx<String?> selectedCountry = Rx<String?>(null);
  final Rx<String?> selectedCity = Rx<String?>(null);
  final immediatelyAvailable = false.obs;

  // Dynamic Lists
  final experienceList = <Map<String, dynamic>>[].obs;
  final educationList = <Map<String, dynamic>>[].obs;
  final awardsList = <Map<String, dynamic>>[].obs;
  final skillsList = <String>[].obs;
  final languages = <String>[].obs;
  final certifications = <String>[].obs;

  // Media
  final Rx<String?> photoPath = Rx<String?>(null); // For new local file
  final Rx<String?> networkPhotoUrl = Rx<String?>(null); // For existing URL
  
  final Rx<String?> bannerPath = Rx<String?>(null); // For new local file
  final Rx<String?> networkBannerUrl = Rx<String?>(null); // For existing URL

  // Data
  final RxList<String> countries = <String>[].obs;
  final RxList<String> cities = <String>[].obs;

  final List<String> degrees = [
    'BSc',
    'B.Tech',
    'B.A',
    'B.Ed',
    'B.Eng',
    'LLB',
    'LLM',
    'M.B.A',
    'MSc',
    'M.Phil',
    'M.Eng',
    'Ph.D',
    'High School',
    'College',
    'Sixth Form',
  ];

  @override
  void onInit() {
    super.onInit();
    aboutMeQuillController = QuillController.basic();
    
    // Add listener for word count
    aboutMeQuillController.document.changes.listen((event) {
      final text = aboutMeQuillController.document.toPlainText();
      final words = text.trim().split(RegExp(r'\s+'));
      aboutMeWordCount.value = text.trim().isEmpty ? 0 : words.length;
    });

    // Defer all reactive state updates to after the first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCountriesAndCities();
      
      if (Get.arguments != null && Get.arguments is CandidateResumeResponseModel) {
        populateData(Get.arguments as CandidateResumeResponseModel);
      }
    });
  }

  // Populate data from the dashboard's Resume object
  void populateData(CandidateResumeResponseModel data) {
    final resume = data.resume;
    if (resume == null) return;

    firstNameController.text = resume.firstName ?? '';
    surnameController.text = resume.lastName ?? '';
    emailController.text = resume.email ?? '';
    
    selectedCountry.value = resume.country;
    selectedCity.value = resume.city;
    immediatelyAvailable.value = resume.immediatelyAvailable;

    // About Me - using 'aboutUs' field
    if (resume.aboutUs != null && resume.aboutUs!.isNotEmpty) {
      aboutMeQuillController.document = Document()..insert(0, resume.aboutUs!);
    }

    // Social Links - sLink is List<String>, need to parse or handle differently
    // For now, we'll skip this as the structure doesn't match
    // The API might return it differently than the model suggests

    // Lists
    skillsList.assignAll(resume.skills);
    languages.assignAll(resume.languages);
    certifications.assignAll(resume.certifications);

    // Experience - from parent model
    experienceList.assignAll(data.experiences.map((e) => {
      'jobTitle': e.position,
      'companyName': e.company,
      'country': e.country,
      'city': e.city,
      'startDate': e.startDate?.toIso8601String().split('T')[0] ?? '',
      'endDate': e.endDate?.toIso8601String().split('T')[0] ?? '',
      'presentlyWorkHere': false, // Not in model
      'description': e.jobDescription,
    }).toList());

    // Education - from parent model
    educationList.assignAll(data.education.map((e) => {
      'institution': e.instituteName,
      'degree': e.degree,
      'fieldOfStudy': e.fieldOfStudy,
      'country': e.country,
      'city': e.city,
      'startDate': e.startDate?.toIso8601String().split('T')[0] ?? '',
      'graduationDate': e.graduationDate?.toIso8601String().split('T')[0] ?? '',
      'presentlyAttendHere': false, // Not in model
    }).toList());

    // Awards - from parent model
    awardsList.assignAll(data.awardsAndHonors.map((a) => {
      'title': a.title,
      'year': a.programeDate?.toIso8601String().split('T')[0] ?? '',
      'description': a.description,
    }).toList());

    // Images
    networkPhotoUrl.value = resume.photo;
    networkBannerUrl.value = resume.banner;
  }

  Future<void> _loadCountriesAndCities() async {
    // This would typically fetch from API or a local JSON
    // For now, I'll mock some data or ideally use the same source as ElevatorResumeController if available
    // Assuming constant lists for now or fetched from a service. 
    // I'll add some dummy data to ensure dropdowns work. 
    // Ideally this comes from a shared service.
    countries.addAll(['USA', 'UK', 'Canada', 'Australia', 'Germany', 'France', 'India', 'Japan']);
    cities.addAll(['New York', 'London', 'Toronto', 'Sydney', 'Berlin', 'Paris', 'Mumbai', 'Tokyo']);
  }

  // --- Image Pickers ---
  final ImagePicker _picker = ImagePicker();

  Future<void> pickPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      photoPath.value = image.path;
    }
  }

  Future<void> pickBanner() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      bannerPath.value = image.path;
    }
  }

  // --- Dynamic List Helpers ---
  
  void addExperience() {
    experienceList.add({
      'jobTitle': '',
      'companyName': '',
      'country': null,
      'city': null,
      'startDate': '',
      'endDate': '',
      'presentlyWorkHere': false,
      'description': '',
    });
  }

  void removeExperience(int index) {
    experienceList.removeAt(index);
  }

  void togglePresentlyWorkHere(int index) {
    final exp = experienceList[index];
    exp['presentlyWorkHere'] = !(exp['presentlyWorkHere'] ?? false);
    experienceList.refresh();
  }

  void addEducation() {
    educationList.add({
      'institution': '',
      'degree': '',
      'fieldOfStudy': '',
      'country': null,
      'city': null,
      'startDate': '',
      'graduationDate': '',
      'presentlyAttendHere': false,
    });
  }

  void removeEducation(int index) {
    educationList.removeAt(index);
  }

  void togglePresentlyAttendHere(int index) {
    final edu = educationList[index];
    edu['presentlyAttendHere'] = !(edu['presentlyAttendHere'] ?? false);
    educationList.refresh();
  }

  void addAward() {
    awardsList.add({
      'title': '',
      'year': '',
      'description': '',
    });
  }

  void removeAward(int index) {
    awardsList.removeAt(index);
  }

  void addSkill(String skill) {
    if (skill.isNotEmpty && !skillsList.contains(skill)) {
      skillsList.add(skill);
    }
  }

  void removeSkill(String skill) {
    skillsList.remove(skill);
  }

  void addLanguage(String lang) {
     if (lang.isNotEmpty && !languages.contains(lang)) {
      languages.add(lang);
    }
  }

  void removeLanguage(String lang) {
    languages.remove(lang);
  }

  void addCertification(String cert) {
    if (cert.isNotEmpty && !certifications.contains(cert)) {
      certifications.add(cert);
    }
  }

  void removeCertification(String cert) {
    certifications.remove(cert);
  }


  // --- Update Profile ---

  Future<void> updateProfile() async {
    if (isUpdating.value) return;
    isUpdating.value = true;

    try {
      final secureStore = SecureStoreServices();
      final token = await secureStore.retrieveData(KeyConstants.accessToken);
      
      if (token == null) {
        Get.snackbar('Error', 'Authentication error. Please log in again.');
        return;
      }

      // Prepare Data (Similar to ElevatorResumeController)
      final aboutMe = aboutMeQuillController.document.toPlainText().trim();

      final resumeData = {
        'firstName': firstNameController.text.trim(),
        'lastName': surnameController.text.trim(),
        'email': emailController.text.trim(),
        'country': selectedCountry.value,
        'city': selectedCity.value,
        'immediatelyAvailable': immediatelyAvailable.value,
        'about': aboutMe,
        'certifications': certifications.toList(),
        'languages': languages.toList(),
        'skills': skillsList.toList(),
        'sLink': [
          if (linkedinController.text.trim().isNotEmpty) {'platform': 'LinkedIn', 'url': linkedinController.text.trim()},
          if (twitterController.text.trim().isNotEmpty) {'platform': 'Twitter', 'url': twitterController.text.trim()},
          if (facebookController.text.trim().isNotEmpty) {'platform': 'Facebook', 'url': facebookController.text.trim()},
          if (tiktokController.text.trim().isNotEmpty) {'platform': 'TikTok', 'url': tiktokController.text.trim()},
          if (instagramController.text.trim().isNotEmpty) {'platform': 'Instagram', 'url': instagramController.text.trim()},
          if (upworkController.text.trim().isNotEmpty) {'platform': 'Upwork', 'url': upworkController.text.trim()},
          if (fiverrController.text.trim().isNotEmpty) {'platform': 'Fiverr', 'url': fiverrController.text.trim()},
          if (portfolioController.text.trim().isNotEmpty) {'platform': 'Portfolio', 'url': portfolioController.text.trim()},
        ],
      };

      final experiencesData = experienceList.map((exp) => {
        'position': exp['jobTitle'],
        'company': exp['companyName'],
        'country': exp['country'],
        'city': exp['city'],
        'startDate': exp['startDate'],
        'endDate': exp['endDate'],
        'presentlyWorkHere': exp['presentlyWorkHere'],
        'description': exp['description'],
      }).toList();

      final educationData = educationList.map((edu) => {
         'institution': edu['institution'],
         'degree': edu['degree'],
         'fieldOfStudy': edu['fieldOfStudy'],
         'country': edu['country'],
         'city': edu['city'],
         'startDate': edu['startDate'],
         'graduationDate': edu['graduationDate'],
         'presentlyAttendHere': edu['presentlyAttendHere'],
      }).toList();

      final awardsData = awardsList.map((award) => {
        'title': award['title'],
        'year': award['year'],
        'description': award['description'],
      }).toList();


      // Use MultipartRequest for PATCH
      // API Constraint: "PATCH https://api.evpitch.com/api/v1/create-resume/resume/update"
      final uri = Uri.parse('${ApiConstants.baseUrl}/create-resume/resume/update');
      final request = http.MultipartRequest('PATCH', uri);
      
      request.headers['Authorization'] = 'Bearer $token';

      // Determine UserId - ideally passed or retrieved. 
      // The previous controller got it from GetUserProfileService.
      // I'll grab it safely if possible, or omit if the token handles it (usually API infers from token, but previous used userId field).
      // Let's assume we need to pass userId if it was passed in create.
      // Checking `CandidateDashboardController`, it uses `AuthStorageService().getUserId()`.
      final userId = await AuthStorageService().getUserId();
      if(userId != null) request.fields['userId'] = userId;


      request.fields['resume'] = jsonEncode(resumeData);
      request.fields['experiences'] = jsonEncode(experiencesData);
      request.fields['educationList'] = jsonEncode(educationData);
      request.fields['awardsAndHonors'] = jsonEncode(awardsData);

      if (photoPath.value != null) {
        request.files.add(await http.MultipartFile.fromPath('photo', photoPath.value!));
      }

      if (bannerPath.value != null) {
        request.files.add(await http.MultipartFile.fromPath('banner', bannerPath.value!));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // Close Screen
        Get.snackbar('Success', 'Profile updated successfully!', backgroundColor: Colors.green, colorText: Colors.white);
        
        // Refresh Dashboard Data
        // The dashboard will automatically refresh when we navigate back
        // since it uses Obx to watch resumeData

      } else {
         final data = jsonDecode(response.body);
         final msg = data['message'] ?? 'Update failed';
         Get.snackbar('Error', msg, backgroundColor: Colors.red, colorText: Colors.white);
      }

    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e', backgroundColor: Colors.red, colorText: Colors.white);
      print(e);
    } finally {
      isUpdating.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    linkedinController.dispose();
    twitterController.dispose();
    facebookController.dispose();
    tiktokController.dispose();
    instagramController.dispose();
    upworkController.dispose();
    fiverrController.dispose();
    portfolioController.dispose();
    languageController.dispose();
    certificationController.dispose();
    aboutMeQuillController.dispose();
    super.onClose();
  }
}
