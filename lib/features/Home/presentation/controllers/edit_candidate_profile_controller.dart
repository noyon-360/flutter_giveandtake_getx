import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/contracts/web/resume_contract.dart';
import 'package:giveandtake/core/network/constants/api_constants.dart';
import 'package:giveandtake/core/network/constants/key_constants.dart';
import 'package:giveandtake/core/network/services/auth_storage_service.dart';
import 'package:giveandtake/core/network/services/secure_store_services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/media_crop_service.dart';
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
  final aboutMeController = TextEditingController();

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
  final removedExperienceIds = <String>[].obs;
  final removedEducationIds = <String>[].obs;
  final removedAwardIds = <String>[].obs;
  final Map<String, ResumeSocialLink> existingSocialLinksByLabel = {};

  // Media
  final Rx<String?> photoPath = Rx<String?>(null); // For new local file
  final Rx<String?> networkPhotoUrl = Rx<String?>(null); // For existing URL
  
  final Rx<String?> bannerPath = Rx<String?>(null); // For new local file
  final Rx<String?> networkBannerUrl = Rx<String?>(null); // For existing URL

  // Data
  final RxList<String> countries = <String>[].obs;
  final RxList<String> cities = <String>[].obs;
  final Map<String, List<String>> countryCityMap = {};
  final RxList<String> universities = <String>[].obs;
  final Map<String, List<String>> universitiesByCountry = {};
  final RxList<String> availableSkills = <String>[].obs;
  final RxList<String> availableLanguages = <String>[].obs;
  final MediaCropService _mediaCropService = Get.find<MediaCropService>();
  String _resumeId = '';
  String _resumeType = 'candidate';
  String _resumeTitle = '';
  String _zipCode = '';

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
    
    // Add listener for word count on aboutMeController
    aboutMeController.addListener(() {
      final text = aboutMeController.text;
      final words = text.trim().split(RegExp(r'\s+'));
      aboutMeWordCount.value = text.trim().isEmpty ? 0 : words.length;
    });

    // Defer all reactive state updates to after the first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null && Get.arguments is CandidateResumeResponseModel) {
        populateData(Get.arguments as CandidateResumeResponseModel);
      }

      // Keep API-backed options loading, but do not block showing existing saved data.
      _initializeFormData();
    });
  }

  Future<void> _initializeFormData() async {
    await Future.wait([
      _loadCountriesAndCities(),
      _loadLanguageOptions(),
      _loadSkillOptions(),
      _loadUniversities(),
    ]);
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
    _syncCitiesForSelectedCountry(resetSelectedCity: false);
    immediatelyAvailable.value = resume.immediatelyAvailable;

    // About Me - using 'aboutUs' field
    if (resume.aboutUs != null && resume.aboutUs!.isNotEmpty) {
      aboutMeController.text = resume.aboutUs!;
      aboutMeQuillController.document = Document()..insert(0, resume.aboutUs!);
    }

    _resumeId = resume.id ?? '';
    _resumeType = resume.type ?? 'candidate';
    _resumeTitle = resume.title ?? '';
    _zipCode = resume.zipCode ?? '';

    existingSocialLinksByLabel
      ..clear()
      ..addEntries(
        resume.sLink.map(
          (link) => MapEntry(link.label.toLowerCase(), link),
        ),
      );

    linkedinController.text = _linkUrl('linkedin');
    twitterController.text = _linkUrl('twitter');
    facebookController.text = _linkUrl('facebook');
    tiktokController.text = _linkUrl('tiktok');
    instagramController.text = _linkUrl('instagram');
    upworkController.text = _linkUrl('upwork');
    fiverrController.text = _linkUrl('fiverr');
    portfolioController.text = _linkUrl('portfolio');

    // Lists
    skillsList.assignAll(resume.skills);
    languages.assignAll(resume.languages);
    certifications.assignAll(resume.certifications);

    // Experience - from parent model
    experienceList.assignAll(data.experiences.map((e) => {
      '_id': e.id,
      'jobTitle': e.position,
      'companyName': e.company,
      'country': e.country,
      'city': e.city,
      'zip': e.zip,
      'jobCategory': e.jobCategory,
      'startDate': _toIsoDateFormat(e.startDate),
      'endDate': _toIsoDateFormat(e.endDate),
      'presentlyWorkHere': e.endDate == null,
      'description': e.jobDescription,
    }).toList());

    // Education - from parent model
    educationList.assignAll(data.education.map((e) => {
      '_id': e.id,
      'institution': e.instituteName.toString(),
      'degree': e.degree,
      'fieldOfStudy': e.fieldOfStudy,
      'country': e.country,
      'city': e.city,
      'startDate': _toIsoDateFormat(e.startDate),
      'graduationDate': _toIsoDateFormat(e.graduationDate),
      'presentlyAttendHere': e.graduationDate == null,
    }).toList());

    // Awards - from parent model
    awardsList.assignAll(data.awardsAndHonors.map((a) => {
      '_id': a.id,
      'title': a.title,
      'issuer': a.programeName,
      'year': a.programeDate?.toIso8601String().split('T').first ?? '',
      'description': a.description,
    }).toList());

    // Images
    networkPhotoUrl.value = resume.photo;
    networkBannerUrl.value = resume.banner;
  }

  Future<void> _loadCountriesAndCities() async {
    try {
      final token = await Get.find<AuthStorageService>().getAccessToken();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/countries'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) return;

      final decoded = jsonDecode(response.body);
      final data = decoded['data'] as List<dynamic>? ?? [];

      countryCityMap.clear();
      for (final item in data) {
        final country = (item['country'] ?? '').toString().trim();
        final rawCities = item['cities'] as List<dynamic>? ?? const [];
        final cityNames = rawCities
            .map((city) => city.toString().trim())
            .where((city) => city.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

        if (country.isNotEmpty) {
          countryCityMap[country] = cityNames;
        }
      }

      countries.assignAll(countryCityMap.keys.toList()..sort());
      _syncCitiesForSelectedCountry(resetSelectedCity: false);
    } catch (_) {}
  }

  Future<void> _loadLanguageOptions() async {
    try {
      final token = await Get.find<AuthStorageService>().getAccessToken();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/language'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) return;

      final decoded = jsonDecode(response.body);
      final data = decoded['data'] as List<dynamic>? ?? [];

      final options = data
          .map((item) => (item['name'] ?? '').toString().trim())
          .where((name) => name.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

      availableLanguages.assignAll(options);
    } catch (_) {}
  }

  Future<void> _loadSkillOptions() async {
    try {
      final token = await Get.find<AuthStorageService>().getAccessToken();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/skill'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) return;

      final decoded = jsonDecode(response.body);
      final data = decoded['data'] as List<dynamic>? ?? [];

      final options = data
          .map((item) => (item['name'] ?? '').toString().trim())
          .where((name) => name.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

      availableSkills.assignAll(options);
    } catch (_) {}
  }

  Future<void> _loadUniversities() async {
    try {
      print('🏫 Fetching universities from API...');
      final url = '${ApiConstants.baseUrl}/university';
      print('🔗 URL: $url');

      final token = await Get.find<AuthStorageService>().getAccessToken();
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        
        // Handle both direct array and wrapped object responses
        List<dynamic> data = [];
        if (responseBody is List) {
          data = responseBody;
        } else if (responseBody is Map && responseBody['data'] != null) {
          data = responseBody['data'] as List<dynamic>;
        }
        
        print('📦 Universities data: ${data.length} items');

        universitiesByCountry.clear();

        for (var university in data) {
          final country = university['country'] as String?;
          final name = university['name'] as String?;

          if (country != null && name != null) {
            if (!universitiesByCountry.containsKey(country)) {
              universitiesByCountry[country] = [];
            }
            universitiesByCountry[country]!.add(name);
          }
        }

        print('✅ Universities loaded for ${universitiesByCountry.length} countries');
        print('   Total universities: ${data.length}');
      } else {
        print('❌ Failed to load universities - Status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching universities: $e');
    }
  }

  void onCountryChanged(String? country) {
    selectedCountry.value = country;
    _syncCitiesForSelectedCountry();
  }

  void _syncCitiesForSelectedCountry({bool resetSelectedCity = true}) {
    final country = selectedCountry.value;
    if (country == null || country.isEmpty) {
      cities.clear();
      selectedCity.value = null;
      return;
    }

    final matchedCities = countryCityMap[country] ?? const <String>[];
    cities.assignAll(matchedCities);
    if (resetSelectedCity) {
      selectedCity.value = null;
    }
  }

  Future<void> pickPhoto() async {
    final image = await _mediaCropService.pickAndCropImage(
      source: ImageSource.gallery,
      preset: MediaCropPreset.avatar,
    );
    if (image != null) {
      photoPath.value = image.path;
      networkPhotoUrl.value = null;
    }
  }

  Future<void> pickBanner() async {
    final image = await _mediaCropService.pickAndCropImage(
      source: ImageSource.gallery,
      preset: MediaCropPreset.banner,
    );
    if (image != null) {
      bannerPath.value = image.path;
      networkBannerUrl.value = null;
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
    final item = experienceList[index];
    final id = item['_id']?.toString();
    if (id != null && id.isNotEmpty) {
      removedExperienceIds.add(id);
    }
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
    final item = educationList[index];
    final id = item['_id']?.toString();
    if (id != null && id.isNotEmpty) {
      removedEducationIds.add(id);
    }
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
    final item = awardsList[index];
    final id = item['_id']?.toString();
    if (id != null && id.isNotEmpty) {
      removedAwardIds.add(id);
    }
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

      final aboutMe = aboutMeController.text.trim();
      final payload = ResumePayloadBuilder.buildUpdate(
        CandidateResumeUpdateInput(
          resumeId: _resumeId,
          userId: (await AuthStorageService().getUserId()) ?? '',
          type: _resumeType,
          firstName: firstNameController.text.trim(),
          lastName: surnameController.text.trim(),
          email: emailController.text.trim(),
          title: _resumeTitle,
          country: selectedCountry.value ?? '',
          city: selectedCity.value ?? '',
          zip: _zipCode,
          aboutUs: aboutMe,
          immediatelyAvailable: immediatelyAvailable.value,
          skills: skillsList.toList(),
          certifications: certifications.toList(),
          languages: languages.toList(),
          socialLinks: _buildSocialLinks(),
          experiences: [
            ...experienceList.map(
              (exp) => CandidateExperienceInput(
                id: exp['_id']?.toString(),
                mutation: exp['_id'] == null
                    ? WebMutationType.create
                    : WebMutationType.update,
                company: (exp['companyName'] ?? '').toString(),
                position: (exp['jobTitle'] ?? '').toString(),
                country: (exp['country'] ?? '').toString(),
                city: (exp['city'] ?? '').toString(),
                zip: (exp['zip'] ?? '').toString(),
                startDate: exp['startDate']?.toString(),
                endDate: exp['endDate']?.toString(),
                currentlyWorking: exp['presentlyWorkHere'] == true,
                jobDescription: (exp['description'] ?? '').toString(),
                jobCategory: (exp['jobCategory'] ?? '').toString(),
              ),
            ),
            ...removedExperienceIds.map(
              (id) => CandidateExperienceInput(
                id: id,
                mutation: WebMutationType.delete,
                company: '',
                position: '',
                country: '',
                city: '',
                zip: '',
                jobDescription: '',
                jobCategory: '',
              ),
            ),
          ],
          educationList: [
            ...educationList.map(
              (edu) => CandidateEducationInput(
                id: edu['_id']?.toString(),
                mutation: edu['_id'] == null
                    ? WebMutationType.create
                    : WebMutationType.update,
                university: (edu['institution'] ?? '').toString(),
                degree: (edu['degree'] ?? '').toString(),
                fieldOfStudy: (edu['fieldOfStudy'] ?? '').toString(),
                country: (edu['country'] ?? '').toString(),
                city: (edu['city'] ?? '').toString(),
                startDate: edu['startDate']?.toString(),
                graduationDate: edu['graduationDate']?.toString(),
                currentlyStudying: edu['presentlyAttendHere'] == true,
              ),
            ),
            ...removedEducationIds.map(
              (id) => CandidateEducationInput(
                id: id,
                mutation: WebMutationType.delete,
                university: '',
                degree: '',
                fieldOfStudy: '',
                country: '',
                city: '',
              ),
            ),
          ],
          awardsAndHonors: [
            ...awardsList.map(
              (award) => CandidateAwardInput(
                id: award['_id']?.toString(),
                mutation: award['_id'] == null
                    ? WebMutationType.create
                    : WebMutationType.update,
                title: (award['title'] ?? '').toString(),
                programeName: (award['issuer'] ?? '').toString(),
                programeDate: (award['year'] ?? '').toString(),
                description: (award['description'] ?? '').toString(),
              ),
            ),
            ...removedAwardIds.map(
              (id) => CandidateAwardInput(
                id: id,
                mutation: WebMutationType.delete,
                title: '',
                programeName: '',
                description: '',
              ),
            ),
          ],
          photo: photoPath.value == null ? null : File(photoPath.value!),
          banner: bannerPath.value == null ? null : File(bannerPath.value!),
        ),
      );


      // Use MultipartRequest for PATCH
      // API Constraint: "PATCH https://api.evpitch.com/api/v1/create-resume/resume/update"
      final uri = Uri.parse(ApiConstants.resume.updateResume);
      final request = http.MultipartRequest('PATCH', uri);
      
      request.headers['Authorization'] = 'Bearer $token';
      request.fields.addAll(payload.fields);

      for (final entry in payload.files.entries) {
        for (final file in entry.value) {
          request.files.add(await http.MultipartFile.fromPath(entry.key, file.path));
        }
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
    aboutMeController.dispose();
    aboutMeQuillController.dispose();
    super.onClose();
  }

  /// Convert DateTime to YYYY-MM-DD format for form storage
  String _toIsoDateFormat(DateTime? value) {
    if (value == null) return '';
    return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
  }

  String _linkUrl(String label) =>
      existingSocialLinksByLabel[label.toLowerCase()]?.url ?? '';

  List<ResumeSocialLinkInput> _buildSocialLinks() {
    final result = <ResumeSocialLinkInput>[];

    void handleLink(String label, TextEditingController controller) {
      final existing = existingSocialLinksByLabel[label.toLowerCase()];
      final url = controller.text.trim();

      if (url.isEmpty && existing != null) {
        result.add(
          ResumeSocialLinkInput(
            id: existing.id,
            label: existing.label,
            url: existing.url,
            mutation: WebMutationType.delete,
          ),
        );
        return;
      }

      if (url.isEmpty) return;

      result.add(
        ResumeSocialLinkInput(
          id: existing?.id,
          label: label,
          url: url,
          mutation: existing == null
              ? WebMutationType.create
              : WebMutationType.update,
        ),
      );
    }

    handleLink('LinkedIn', linkedinController);
    handleLink('Twitter', twitterController);
    handleLink('Facebook', facebookController);
    handleLink('TikTok', tiktokController);
    handleLink('Instagram', instagramController);
    handleLink('Upwork', upworkController);
    handleLink('Fiverr', fiverrController);
    handleLink('Portfolio', portfolioController);

    return result;
  }
}
