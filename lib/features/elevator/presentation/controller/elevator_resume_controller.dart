import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/constants/key_constants.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../../../core/network/services/secure_store_services.dart';
import '../../../../core/services/get_user_profile_service.dart';
import '../../../Home/presentation/screen/candidate_dashboard_screen.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../company/presentation/screen/company_details_screen.dart';
import '../../../recruiter_account/presentation/screens/recruiter_page.dart';
import '../../data/models/upload_video_request_model.dart';
import '../../data/models/upload_video_response_model.dart';

class ElevatorResumeController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  /// ================== ABOUT ME (QUILL) ==================
  late final quill.QuillController aboutMeQuillController;
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

  /// Check if resume upload is in progress
  var isUploadingResume = false.obs;
  var elevatorVideoPath = ''.obs;
  var isVideoUploaded = false.obs;
  var isVideoInitialized = false.obs;
  var isPlaying = false.obs;
  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;

  VideoPlayerController? videoPlayerController;

  var photoPath = Rx<String?>(null);
  var bannerImagePath = Rx<String?>(null);

  /// ================== DYNAMIC LISTS ==================
  var experienceList = <Map<String, dynamic>>[].obs;

  var educationList = <Map<String, dynamic>>[
    {'presentlyAttendHere': false},
  ].obs;

  var awardsList = <Map<String, dynamic>>[{}].obs;

  /// Skills chips
  var skillsList = <String>[].obs;

  /// Other custom URLs
  var otherUrlsList = <String>[].obs;

  /// Certifications list
  var certifications = <String>[].obs;

  /// Languages list
  var languages = <String>[].obs;
  var availableLanguages = <String>[].obs; // All languages from API

  /// ================== DUMMY DATA ==================
  final List<String> titles = ['Mr.', 'Mrs.', 'Ms.', 'Dr.'];

  // Dynamic countries and cities from API
  var countries = <String>[].obs;
  var cities = <String>[].obs;
  Map<String, List<String>> countryCityMap = {};

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

  /// ================== FORM CONTROLLERS ==================
  final firstNameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final certificationController = TextEditingController();
  final languageController = TextEditingController();

  // Social media links
  final linkedinController = TextEditingController();
  final twitterController = TextEditingController();
  final facebookController = TextEditingController();
  final tiktokController = TextEditingController();
  final instagramController = TextEditingController();
  final upworkController = TextEditingController();
  final fiverrController = TextEditingController();
  final portfolioController = TextEditingController();

  /// ================== LIFECYCLE ==================
  @override
  void onInit() {
    super.onInit();

    aboutMeQuillController = quill.QuillController.basic();
    aboutMeQuillController.addListener(_updateWordCountFromQuill);

    // Fetch dynamic data from APIs
    fetchCountriesWithCities();
    fetchLanguages();

    // Load user profile data with delay to ensure service is ready
    Future.delayed(Duration.zero, () {
      _loadUserProfileData();
    });

    // Also listen to userInfoRx for reactive updates
    _setupUserProfileListener();
  }

  void _updateWordCountFromQuill() {
    final plain = aboutMeQuillController.document.toPlainText().trim();
    if (plain.isEmpty) {
      aboutMeWordCount.value = 0;
    } else {
      aboutMeWordCount.value = plain
          .split(RegExp(r'\s+'))
          .where((w) => w.isNotEmpty)
          .length;
    }
  }

  @override
  void onClose() {
    print('========== ELEVATOR RESUME CONTROLLER CLOSING ==========');
    videoPlayerController?.dispose();
    aboutMeQuillController.dispose();
    firstNameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    certificationController.dispose();
    languageController.dispose();
    linkedinController.dispose();
    twitterController.dispose();
    facebookController.dispose();
    tiktokController.dispose();
    instagramController.dispose();
    upworkController.dispose();
    fiverrController.dispose();
    portfolioController.dispose();
    super.onClose();
  }

  /// ================== LOAD USER PROFILE ==================
  void _setupUserProfileListener() {
    try {
      print('Setting up user profile listener...');
      final userProfileService = Get.find<GetUserProfileService>();

      // Listen to changes in user profile
      ever(userProfileService.userInfoRx, (user) {
        print('User profile changed! User is null: ${user == null}');
        if (user != null) {
          print('Calling _populateUserData from listener');
          _populateUserData(user);
        }
      });
      print('User profile listener set up successfully');
    } catch (e) {
      print('Error setting up user profile listener: $e');
    }
  }

  void _loadUserProfileData() {
    try {
      print('Loading user profile data...');
      final userProfileService = Get.find<GetUserProfileService>();
      final user = userProfileService.userInfo;

      print('User info is null: ${user == null}');
      if (user != null) {
        print('User found, calling _populateUserData');
        _populateUserData(user);
      } else {
        // If user is null, try to fetch from API
        print('User info is null, attempting to fetch from API');
        userProfileService.getUserProfile().then((_) {
          // After fetching, try to populate again
          final updatedUser = userProfileService.userInfo;
          if (updatedUser != null) {
            print('User fetched from API, now populating');
            _populateUserData(updatedUser);
          }
        });
      }
    } catch (e) {
      print('Error loading user profile data: $e');
    }
  }

  /// Refresh all user profile data (called when screen opens/closes)
  Future<void> refreshUserProfileData() async {
    try {
      print('========== REFRESHING USER PROFILE DATA ==========');
      final userProfileService = Get.find<GetUserProfileService>();

      // Force fetch from API
      await userProfileService.getUserProfile();

      // Get the updated user
      final user = userProfileService.userInfo;
      if (user != null) {
        _populateUserData(user);
        print('User profile refreshed successfully');
      } else {
        print('User profile is still null after refresh');
      }
    } catch (e) {
      print('Error refreshing user profile: $e');
    }
  }

  void _populateUserData(UserModel user) {
    print('========== POPULATING USER DATA ==========');
    print('Full user name: "${user.name}"');
    print('User email: "${user.email}"');
    print('User phoneNumber: "${user.phoneNumber}"');
    print('User profileImage: "${user.profileImage}"');

    // Parse name into first name and surname
    final nameParts = user.name.trim().split(' ');
    print('Name parts count: ${nameParts.length}');
    print('Name parts: $nameParts');

    if (nameParts.isNotEmpty) {
      final firstName = nameParts.first.trim();
      print('Setting first name to: "$firstName"');
      firstNameController.text = firstName;

      if (nameParts.length > 1) {
        final surname = nameParts.sublist(1).join(' ').trim();
        print('Setting surname to: "$surname"');
        surnameController.text = surname;
      } else {
        print('No surname found');
      }
    }

    // Set email
    print('Setting email to: "${user.email}"');
    emailController.text = user.email;

    // Set phone number
    print(
      'Phone number check - isEmpty: ${user.phoneNumber.isEmpty}, value: "${user.phoneNumber}"',
    );
    if (user.phoneNumber.isNotEmpty) {
      print('Setting phone number to: "${user.phoneNumber}"');
    } else {
      print('Phone number is empty, not setting');
    }

    // Set profile image if available
    if (user.profileImage != null && user.profileImage!.isNotEmpty) {
      print('Setting profile image to: "${user.profileImage}"');
      photoPath.value = user.profileImage;
    } else {
      print('No profile image available');
    }

    print('========== USER DATA POPULATION COMPLETE ==========');
  }

  /// ================== PICKERS ==================
  Future<void> pickElevatorVideo() async {
    try {
      final source = await Get.bottomSheet<ImageSource>(
        Container(
          color: const Color(0xFFFFFFFF),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.video_library),
                title: const Text('Pick from Gallery'),
                onTap: () => Get.back(result: ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Record New Video'),
                onTap: () => Get.back(result: ImageSource.camera),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      final XFile? video = await _picker.pickVideo(
        source: source,
        maxDuration: const Duration(seconds: 60),
      );

      if (video == null) return;

      elevatorVideoPath.value = video.path;
      isVideoInitialized.value = false;
      isVideoUploaded.value = false;

      videoPlayerController?.dispose();

      videoPlayerController = VideoPlayerController.file(File(video.path))
        ..initialize().then((_) {
          isVideoInitialized.value = true;
          totalDuration.value = videoPlayerController!.value.duration;

          videoPlayerController!.setLooping(false);
          videoPlayerController!.play();
          isPlaying.value = true;

          videoPlayerController!.addListener(() {
            final position = videoPlayerController!.value.position;
            currentPosition.value = position;

            if (position >= videoPlayerController!.value.duration &&
                !videoPlayerController!.value.isPlaying) {
              isPlaying.value = false;
            }
          });
        });
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick video: $e');
    }
  }

  void togglePlayPause() {
    if (videoPlayerController == null) return;

    if (videoPlayerController!.value.isPlaying) {
      videoPlayerController!.pause();
      isPlaying.value = false;
    } else {
      if (currentPosition.value >= videoPlayerController!.value.duration) {
        videoPlayerController!.seekTo(Duration.zero);
      }
      videoPlayerController!.play();
      isPlaying.value = true;
    }
  }

  void seekTo(Duration position) {
    videoPlayerController?.seekTo(position);
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> uploadElevatorVideo() async {
    if (elevatorVideoPath.value.isEmpty) {
      Get.snackbar('Error', 'Please select a video first.');
      return;
    }

    final file = File(elevatorVideoPath.value);
    if (!file.existsSync()) {
      Get.snackbar('Error', 'Selected video file not found.');
      return;
    }

    // Get user ID
    final authStorageService = Get.find<AuthStorageService>();
    final userId = await authStorageService.getUserId();
    
    if (userId == null || userId.isEmpty) {
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      return;
    }

    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Get ApiClient instance
      final apiClient = ApiClient();

      // Step 1: Get file info
      final fileName = file.path.split('/').last;
      final fileSize = await file.length();
      final fileType = 'video/mp4'; // You can determine this from file extension if needed

      print('📹 Preparing to upload video...');
      print('File name: $fileName');
      print('File size: $fileSize bytes');
      print('File type: $fileType');

      // Step 2: Request upload URL from server
      final requestModel = UploadVideoRequestModel(
        fileName: fileName,
        fileType: fileType,
        fileSize: fileSize,
      );

      print('🔄 Requesting upload URL from server...');
      final urlResult = await apiClient.post(
        ApiConstants.elevatorPitchVideo.uploadVideo(userId),
        data: requestModel.toJson(),
        fromJsonT: (json) => UploadVideoResponseModel.fromJson(json),
      );

      UploadVideoResponseModel? uploadResponse;
      urlResult.fold(
        (fail) {
          print('❌ Failed to get upload URL: ${fail.message}');
          throw Exception('Failed to get upload URL: ${fail.message}');
        },
        (success) {
          uploadResponse = success.data;
          print('✅ Received upload URL');
          print('Upload URL: ${success.data.uploadUrl}');
          print('Key: ${success.data.key}');
          print('Bucket: ${success.data.bucket}');
        },
      );

      if (uploadResponse == null) {
        throw Exception('Upload URL not received');
      }

      // Step 3: Upload video to the pre-signed URL using Dio directly
      print('⬆️  Uploading video to storage...');
      final dio = Dio();
      final videoBytes = await file.readAsBytes();

      final uploadToStorageResponse = await dio.put(
        uploadResponse!.uploadUrl,
        data: videoBytes,
        options: Options(
          headers: {
            'Content-Type': fileType,
            'Content-Length': fileSize.toString(),
          },
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      if (uploadToStorageResponse.statusCode == 200 || 
          uploadToStorageResponse.statusCode == 201 ||
          uploadToStorageResponse.statusCode == 204) {
        print('✅ Video uploaded successfully to storage');
        
        // Step 4: Confirm video upload completion
        print('🔄 Confirming video upload with server...');
        
        final completeUrl = ApiConstants.elevatorPitchVideo.completeVideoUpload(userId);
        final completeData = {
          'fileKey': uploadResponse!.key,
          'fileName': fileName,
          'fileSize': fileSize,
        };
        
        print('Sending completion request to: $completeUrl');
        print('Completion data: $completeData');
        
        final completeResult = await apiClient.post(
          completeUrl,
          data: completeData,
          fromJsonT: (json) {
            // Just return the raw response as map
            return json as Map<String, dynamic>;
          },
        );
        
        bool completeSuccess = false;
        String completeError = '';
        completeResult.fold(
          (fail) {
            print('⚠️ Warning: Failed to confirm video completion: ${fail.message}');
            completeError = fail.message;
          },
          (success) {
            print('✅ Video completion confirmed successfully');
            print('Response: ${success.data}');
            completeSuccess = true;
          },
        );

        if (!completeSuccess) {
          throw Exception(completeError);
        }
        
        // Close loading
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        
        isVideoUploaded.value = true;
        
        Get.snackbar(
          'Success',
          'Elevator pitch uploaded successfully. We\'re processing your video. Feel free to submit your resume while it finalizes.',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      } else {
        throw Exception('Failed to upload video to storage. Status: ${uploadToStorageResponse.statusCode}');
      }
    } catch (e) {
      print('❌ Error uploading video: $e');
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.snackbar(
        'Error',
        'Failed to upload video: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void deleteElevatorVideo() {
    videoPlayerController?.dispose();
    videoPlayerController = null;
    elevatorVideoPath.value = '';
    isVideoUploaded.value = false;
    isVideoInitialized.value = false;
    isPlaying.value = false;
    currentPosition.value = Duration.zero;
    totalDuration.value = Duration.zero;
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
    if (value != null) {
      cities.value = countryCityMap[value] ?? [];
      selectedCity.value = null; // Reset city selection
      print("Loaded ${cities.length} cities for $value");
    } else {
      cities.clear();
      selectedCity.value = null;
    }
  }

  /// ================== API CALLS ==================
  Future<void> fetchCountriesWithCities() async {
    try {
      print("🌍 Fetching countries from API...");
      final url = '${ApiConstants.baseUrl}/countries';
      print("🔗 URL: $url");

      final response = await http.get(Uri.parse(url));

      print("📡 Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("📦 Response data keys: ${data.keys}");

        for (var country in data['data']) {
          if (country['cities'] != null &&
              (country['cities'] as List).isNotEmpty) {
            countryCityMap[country['country']] = List<String>.from(
              country['cities'],
            );
          }
        }

        countries.value = countryCityMap.keys.toList();
        print("✅ Countries loaded: ${countries.length}");
      } else {
        print("❌ Failed to load countries - Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching countries: $e");
    }
  }

  Future<void> fetchLanguages() async {
    try {
      print("🌐 Fetching languages from API...");
      final url = '${ApiConstants.baseUrl}/language';
      print("🔗 URL: $url");

      final response = await http.get(Uri.parse(url));

      print("📡 Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("📦 Response data keys: ${data.keys}");

        // Parse language names from the data array
        if (data['data'] != null) {
          availableLanguages.value = (data['data'] as List)
              .map((item) => item['name'] as String)
              .where((name) => name != 'name') // Filter out the invalid entry
              .toList();
          print("✅ Languages loaded: ${availableLanguages.length}");
        }
      } else {
        print("❌ Failed to load languages - Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching languages: $e");
    }
  }

  /// ================== EXPERIENCE / EDUCATION / AWARDS ==================
  void addExperience() {
    experienceList.add({
      'presentlyWorkHere': false,
      'country': null,
      'city': null,
      // 'jobTitle': '',
      // 'companyName': '',
      // 'startDate': '',
      // 'endDate': '',
      // 'description': '',
    });
  }

  void addEducation() {
    educationList.add({'presentlyAttendHere': false});
  }

  // Update specific field in education item
  void updateEducationField(int index, String key, dynamic value) {
    if (index >= 0 && index < educationList.length) {
      final item = Map<String, dynamic>.from(educationList[index]);
      item[key] = value;
      educationList[index] = item;
    }
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
    updateEducationField(
      index,
      'presentlyAttendHere',
      !(educationList[index]['presentlyAttendHere'] ?? false),
    );
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
    final text = certificationController.text.trim();
    if (text.isNotEmpty && !certifications.contains(text)) {
      certifications.add(text);
      certificationController.clear();
    }
  }

  void removeCertification(String cert) {
    certifications.remove(cert);
  }

  /// ================== LANGUAGES ==================
  void addLanguage(String lang) {
    final l = lang.trim();
    // Support direct add via controller if argument is empty
    if (l.isEmpty && languageController.text.isNotEmpty) {
      final fromController = languageController.text.trim();
      if (fromController.isNotEmpty && !languages.contains(fromController)) {
        languages.add(fromController);
        languageController.clear();
      }
      return;
    }

    if (l.isNotEmpty && !languages.contains(l)) {
      languages.add(l);
    }
  }

  void removeLanguage(String lang) {
    languages.remove(lang);
  }

  /// ================== SUBMIT / SAVE ==================
  Future<void> saveResume() async {
    try {
      // Prevent duplicate submissions
      if (isUploadingResume.value) {
        print('Upload already in progress');
        return;
      }

      isUploadingResume.value = true;
      print('Starting resume upload...');

      // Get user info
      final userProfileService = Get.find<GetUserProfileService>();
      final user = userProfileService.userInfo;

      if (user == null) {
        print('ERROR: User not logged in');
        Get.snackbar(
          'Error',
          'User not logged in. Please log in again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isUploadingResume.value = false;
        return;
      }

      print('User ID: ${user.id}, Email: ${user.email}');

        final authStorageService = Get.isRegistered<AuthStorageService>()
          ? Get.find<AuthStorageService>()
          : AuthStorageService();
        final userRole = (await authStorageService.getUserRole() ?? 'candidate')
          .trim()
          .toLowerCase();

      // Get about me as plain text
      final aboutMe = aboutMeQuillController.document.toPlainText().trim();
      print('About me text length: ${aboutMe.length}');

      // Prepare resume object
      print('Preparing resume data...');
      final resumeData = {
        'type': userRole.isEmpty ? 'candidate' : userRole,
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
          if (linkedinController.text.trim().isNotEmpty)
            {'platform': 'LinkedIn', 'url': linkedinController.text.trim()},
          if (twitterController.text.trim().isNotEmpty)
            {'platform': 'Twitter', 'url': twitterController.text.trim()},
          if (facebookController.text.trim().isNotEmpty)
            {'platform': 'Facebook', 'url': facebookController.text.trim()},
          if (tiktokController.text.trim().isNotEmpty)
            {'platform': 'TikTok', 'url': tiktokController.text.trim()},
          if (instagramController.text.trim().isNotEmpty)
            {'platform': 'Instagram', 'url': instagramController.text.trim()},
          if (upworkController.text.trim().isNotEmpty)
            {'platform': 'Upwork', 'url': upworkController.text.trim()},
          if (fiverrController.text.trim().isNotEmpty)
            {'platform': 'Fiverr', 'url': fiverrController.text.trim()},
          if (portfolioController.text.trim().isNotEmpty)
            {'platform': 'Portfolio', 'url': portfolioController.text.trim()},
        ],
      };

      // Prepare experiences array
      final experiencesData = experienceList.map((exp) {
        return {
          'position': exp['jobTitle'] ?? '',
          'company': exp['companyName'] ?? '',
          'country': exp['country'] ?? '',
          'city': exp['city'] ?? '',
          'startDate': exp['startDate'] ?? '',
          'endDate': exp['endDate'] ?? '',
          'duration': exp['duration'] ?? '',
          'presentlyWorkHere': exp['presentlyWorkHere'] ?? false,
          'description': exp['description'] ?? '',
        };
      }).toList();

      // Prepare education array
      final educationData = educationList.map((edu) {
        return {
          'institution': edu['institution'] ?? '',
          'degree': edu['degree'] ?? '',
          'fieldOfStudy': edu['fieldOfStudy'] ?? '',
          'country': edu['country'] ?? '',
          'city': edu['city'] ?? '',
          'startDate': edu['startDate'] ?? '',
          'graduationDate': edu['graduationDate'] ?? '',
          'presentlyAttendHere': edu['presentlyAttendHere'] ?? false,
        };
      }).toList();

      // Prepare awards array
      final awardsData = awardsList.map((award) {
        return {
          'title': award['title'] ?? '',
          'year': award['year'] ?? '',
          'description': award['description'] ?? '',
        };
      }).toList();

      // Get auth token
      print('Retrieving auth token...');
      final secureStore = SecureStoreServices();
      final token = await secureStore.retrieveData(KeyConstants.accessToken);

      if (token == null || token.isEmpty) {
        print('ERROR: No auth token found');
        Get.snackbar(
          'Error',
          'Authentication token not found. Please log in again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isUploadingResume.value = false;
        return;
      }
      print('Auth token retrieved successfully');

      // Create multipart request
      final apiUrl = ApiConstants.resume.createResume;
      print('API URL: $apiUrl');

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add Authorization header
      request.headers['Authorization'] = 'Bearer $token';
      print('Authorization header added');

      // Add text fields - IMPORTANT: Match the exact field names from your Postman request
      request.fields['userId'] = user.id;
      request.fields['resume'] = jsonEncode(resumeData);
      request.fields['experiences'] = jsonEncode(experiencesData);
      request.fields['educationList'] = jsonEncode(educationData);
      request.fields['awardsAndHonors'] = jsonEncode(awardsData);

      print('Resume data added to request');
      print('  - UserId: ${user.id}');
      print('  - Resume fields: ${resumeData.keys.toList()}');
      print('  - Experiences count: ${experiencesData.length}');
      print('  - Education count: ${educationData.length}');
      print('  - Awards count: ${awardsData.length}');

      // Add photo file if selected
      if (photoPath.value != null) {
        print('Adding photo file: ${photoPath.value}');
        request.files.add(
          await http.MultipartFile.fromPath('photo', photoPath.value!),
        );
      } else {
        print('No photo selected');
      }

      // Add banner file if selected
      if (bannerImagePath.value != null) {
        print('Adding banner file: ${bannerImagePath.value}');
        request.files.add(
          await http.MultipartFile.fromPath('banner', bannerImagePath.value!),
        );
      } else {
        print('No banner selected');
      }

      print('All fields and files added. Sending request...');

      // Show loading dialog
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false, // Prevent dismissal
          child: const Center(child: CircularProgressIndicator()),
        ),
        barrierDismissible: false,
      );

      // Send request with timeout
      print('Sending multipart request to API...');
      print('Request headers: ${request.headers}');
      print('Request fields: ${request.fields.keys.toList()}');
      print('Request files: ${request.files.map((f) => f.field).toList()}');

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Resume upload request timed out');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);
      print('========== API RESPONSE ==========');
      print('Status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');
      print('==================================');

      // Close loading dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final data = jsonDecode(response.body);
          final message = data['message'] ?? 'Resume created successfully!';
          print('SUCCESS: $message');

          Get.snackbar(
            'Success',
            message,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );

          // Clear form and navigate to role-based dashboard
          clearForm();
          Future.delayed(const Duration(seconds: 2), () {
            _navigateToDashboardByRole();
          });
        } catch (e) {
          print('Error parsing success response: $e');
          Get.snackbar(
            'Success',
            'Resume uploaded successfully!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Clear form and navigate to role-based dashboard
          clearForm();
          Future.delayed(const Duration(seconds: 2), () {
            _navigateToDashboardByRole();
          });
        }
      } else {
        print('❌ Upload failed with status: ${response.statusCode}');

        try {
          final data = jsonDecode(response.body);
          print('Error response data: $data');

          final errorMessage =
              data['message'] ?? data['error'] ?? 'Failed to create resume';
          print('ERROR Message: $errorMessage');

          Get.snackbar(
            'Upload Failed',
            errorMessage.toString(),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
            snackPosition: SnackPosition.BOTTOM,
          );
        } catch (e) {
          print('Error parsing error response: $e');
          print('Raw response body: ${response.body}');

          Get.snackbar(
            'Upload Failed',
            'Status: ${response.statusCode}\nPlease check your internet connection and try again.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } on TimeoutException catch (e) {
      print('TIMEOUT ERROR: $e');

      // Close loading if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Timeout',
        'Upload took too long. Please check your connection and try again.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('EXCEPTION ERROR: $e');

      // Close loading if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isUploadingResume.value = false;
      print('========== RESUME UPLOAD COMPLETED =========');
    }
  }

  Future<void> _navigateToDashboardByRole() async {
    final authStorageService = Get.isRegistered<AuthStorageService>()
        ? Get.find<AuthStorageService>()
        : AuthStorageService();

    final role = (await authStorageService.getUserRole() ?? '')
        .trim()
        .toLowerCase();

    if (role == 'candidate') {
      Get.offAll(() => const CandidateDashboardScreen());
      return;
    }

    if (role == 'company') {
      Get.offAll(() => CompanyDetailsPage());
      return;
    }

    if (role == 'recruiter') {
      Get.offAll(() => const RecruiterPageScreen());
      return;
    }

    // Fallback keeps old behavior when role is missing/unknown.
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
    }
  }

  /// Clear all form fields
  void clearForm() {
    print('Clearing form...');

    // Clear text controllers
    firstNameController.clear();
    surnameController.clear();
    emailController.clear();
    certificationController.clear();
    languageController.clear();
    linkedinController.clear();
    twitterController.clear();
    facebookController.clear();
    tiktokController.clear();
    instagramController.clear();
    upworkController.clear();
    fiverrController.clear();
    portfolioController.clear();

    // Clear Quill controller
    aboutMeQuillController.clear();

    // Reset selections
    selectedTitle.value = 'Mr.';
    selectedCountry.value = null;
    selectedCity.value = null;
    immediatelyAvailable.value = false;

    // Clear lists
    experienceList.clear();
    educationList.value = [
      {'presentlyAttendHere': false},
    ];
    awardsList.value = [{}];
    skillsList.clear();
    otherUrlsList.clear();
    certifications.clear();
    languages.clear();

    // Clear media files
    photoPath.value = null;
    bannerImagePath.value = null;
    elevatorVideoPath.value = '';
    isVideoUploaded.value = false;

    // Reset word count
    aboutMeWordCount.value = 0;

    print('Form cleared successfully');
  }

  /// Validation for resume submission
  String? validateResume() {
    // Validate required fields
    if (firstNameController.text.trim().isEmpty) {
      return 'First name is required';
    }

    if (surnameController.text.trim().isEmpty) {
      return 'Surname is required';
    }

    if (selectedCountry.value == null || selectedCountry.value!.isEmpty) {
      return 'Country is required';
    }

    if (selectedCity.value == null || selectedCity.value!.isEmpty) {
      return 'City is required';
    }

    if (emailController.text.trim().isEmpty) {
      return 'Email address is required';
    }

    if (educationList.isEmpty ||
        educationList.every(
          (edu) =>
              (edu['institution'] ?? '').isEmpty &&
              (edu['degree'] ?? '').isEmpty,
        )) {
      return 'At least one education entry is required';
    }

    return null; // No errors
  }

  void onUploadElevatorPitchFirst() {
    print('========== RESUME UPLOAD STARTED =========');

    // Validate form
    final validationError = validateResume();
    if (validationError != null) {
      print('Validation Error: $validationError');
      Get.snackbar(
        'Validation Error',
        validationError,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    print('Validation passed, proceeding with resume save');
    saveResume();
  }
}
