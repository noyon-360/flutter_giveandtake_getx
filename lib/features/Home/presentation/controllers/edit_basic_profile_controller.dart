import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/contracts/web/resume_contract.dart';
import 'package:giveandtake/core/network/constants/api_constants.dart';
import 'package:giveandtake/core/network/services/auth_storage_service.dart';
import 'package:giveandtake/core/services/media_crop_service.dart';
import 'package:giveandtake/features/Home/presentation/controllers/candidate_dashboard_controller.dart';
import 'package:giveandtake/features/profile_dasboard/presentation/controller/profile_controller.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditBasicProfileController extends GetxController {
  final isLoading = false.obs;
  final isUpdating = false.obs;

  // Form Controllers - Only Basic Fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();

  // Reactive values for display
  final firstNameValue = ''.obs;
  final lastNameValue = ''.obs;
  final emailValue = ''.obs;

  // Data
  final RxList<String> countries = <String>[].obs;
  final RxList<String> cities = <String>[].obs;
  final Map<String, List<String>> countryCityMap = {};
  final Rx<String?> selectedCountry = Rx<String?>(null);
  final Rx<String?> selectedCity = Rx<String?>(null);

  // Media
  final Rx<String?> photoPath = Rx<String?>(null); // For new local file
  final Rx<String?> networkPhotoUrl = Rx<String?>(null); // For existing URL
  
  final MediaCropService _mediaCropService = Get.find<MediaCropService>();

  String _resumeId = '';

  @override
  void onInit() {
    super.onInit();
    _loadCountriesAndCities();
    _loadFreshResumeData(); // Fetch fresh data instead of relying on stale arguments
    
    // Listen to text controller changes
    firstNameController.addListener(() {
      firstNameValue.value = firstNameController.text;
    });
    lastNameController.addListener(() {
      lastNameValue.value = lastNameController.text;
    });
    emailController.addListener(() {
      emailValue.value = emailController.text;
    });
  }

  Future<void> _loadCountriesAndCities() async {
    try {
      isLoading.value = true;
      final token = await Get.find<AuthStorageService>().getAccessToken();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/countries'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> countryList = data['data'] ?? [];
        
        countries.value = [];
        countryCityMap.clear();
        
        for (var country in countryList) {
          final countryName = country['country'] as String?;
          final citiesList = country['cities'] as List<dynamic>?;
          
          if (countryName != null) {
            countries.value.add(countryName);
            countryCityMap[countryName] = citiesList?.cast<String>() ?? [];
          }
        }
      }
    } catch (e) {
      print('Error loading countries: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadFreshResumeData() async {
    try {
      // Wait a bit for countries to load
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Try to get fresh data from dashboard controller first
      try {
        final dashboardController = Get.find<CandidateDashboardController>();
        if (dashboardController.resumeData.value != null) {
          print('📝 [EditBasicProfile] Using fresh data from dashboard controller');
          populateData(dashboardController.resumeData.value!.resume);
          return;
        }
      } catch (e) {
        print('⚠️ [EditBasicProfile] Dashboard controller not ready: $e');
      }

      // Fallback: use arguments if provided
      final data = Get.arguments;
      if (data != null) {
        print('📝 [EditBasicProfile] Using data from arguments');
        populateData(data);
      }
    } catch (e) {
      print('❌ [EditBasicProfile] Error loading fresh resume data: $e');
    }
  }

  void updateCitiesForCountry(String country) {
    selectedCountry.value = country;
    cities.value = countryCityMap[country] ?? [];
    selectedCity.value = null;
  }

  void populateData(dynamic data) {
    try {
      // Handle both Map and Resume object
      String id = '';
      String firstName = '';
      String lastName = '';
      String email = '';
      String country = '';
      String city = '';
      String? photoUrl;

      if (data is Map<String, dynamic>) {
        id = data['_id']?.toString() ?? data['id']?.toString() ?? '';
        firstName = data['firstName']?.toString() ?? '';
        lastName = data['lastName']?.toString() ?? '';
        email = data['email']?.toString() ?? '';
        country = data['country']?.toString() ?? '';
        city = data['city']?.toString() ?? '';
        photoUrl = data['photo']?.toString();
      } else {
        // Assume it's a Resume object with properties
        id = data.id?.toString() ?? '';
        firstName = data.firstName?.toString() ?? '';
        lastName = data.lastName?.toString() ?? '';
        email = data.email?.toString() ?? '';
        country = data.country?.toString() ?? '';
        city = data.city?.toString() ?? '';
        photoUrl = data.photo?.toString();
      }

      print('📝 [EditBasicProfile] Populating - Name: $firstName $lastName, Email: $email, Country: $country');

      _resumeId = id;
      firstNameController.text = firstName;
      lastNameController.text = lastName;
      emailController.text = email;
      countryController.text = country;
      cityController.text = city;
      networkPhotoUrl.value = photoUrl;
      
      // Trigger reactive values
      firstNameValue.value = firstName;
      lastNameValue.value = lastName;
      emailValue.value = email;
      
      print('✅ [EditBasicProfile] Data populated successfully');
      
      // Set selected values for dropdowns after a delay for countries to load
      Future.delayed(const Duration(milliseconds: 500), () {
        if (country.isNotEmpty && countries.contains(country)) {
          print('🌍 [EditBasicProfile] Setting country: $country');
          selectedCountry.value = country;
          updateCitiesForCountry(country);
          if (city.isNotEmpty) {
            print('🏙️ [EditBasicProfile] Setting city: $city');
            selectedCity.value = city;
          }
        }
      });
    } catch (e) {
      print('❌ Error populating data: $e');
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

  Future<void> updateProfile() async {
    try {
      // Validate fields
      if (firstNameController.text.trim().isEmpty) {
        Get.snackbar('Error', 'First name is required', 
          backgroundColor: const Color(0xFFE53935), colorText: Colors.white);
        return;
      }
      if (lastNameController.text.trim().isEmpty) {
        Get.snackbar('Error', 'Last name is required', 
          backgroundColor: const Color(0xFFE53935), colorText: Colors.white);
        return;
      }

      isUpdating.value = true;
      final token = await Get.find<AuthStorageService>().getAccessToken();
      final userId = await AuthStorageService().getUserId();

      // Build payload using the same structure as edit candidate profile
      final payload = ResumePayloadBuilder.buildUpdate(
        CandidateResumeUpdateInput(
          resumeId: _resumeId,
          userId: userId ?? '',
          type: 'update',
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          email: emailController.text.trim(),
          country: selectedCountry.value ?? '',
          city: selectedCity.value ?? '',
          // Keep other fields as they were
          title: '',
          zip: '',
          aboutUs: '',
          immediatelyAvailable: false,
          skills: [],
          certifications: [],
          languages: [],
          socialLinks: [],
          experiences: [],
          educationList: [],
          awardsAndHonors: [],
          photo: photoPath.value != null ? File(photoPath.value!) : null,
        ),
      );

      // Use MultipartRequest for PATCH (same as edit candidate profile)
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
        Get.snackbar('Success', 'Profile updated successfully!',
          backgroundColor: Colors.green, colorText: Colors.white);
        
        // Refresh dashboard data AND profile data BEFORE navigating back
        try {
          final dashboardController = Get.find<CandidateDashboardController>();
          await dashboardController.fetchDashboardData();
          print('✅ [EditBasicProfile] Dashboard data refreshed after profile update');
          
          // Also refresh profile controller if it exists
          try {
            final profileController = Get.find<ProfileController>();
            await profileController.fetchUser();
            print('✅ [EditBasicProfile] Profile controller refreshed');
          } catch (e) {
            print('⚠️ [EditBasicProfile] Profile controller not found: $e');
          }
        } catch (e) {
          print('⚠️ [EditBasicProfile] Could not refresh data: $e');
        }
        
        // Navigate back to profile screen with automatic refresh
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.back();
        });
      } else {
        try {
          final data = jsonDecode(response.body);
          final msg = data['message'] ?? 'Update failed';
          Get.snackbar('Error', msg, 
            backgroundColor: Colors.red, colorText: Colors.white);
        } catch (_) {
          Get.snackbar('Error', 'Update failed with status ${response.statusCode}', 
            backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
        backgroundColor: Colors.red, colorText: Colors.white);
      print('❌ [EditBasicProfile] Update error: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    countryController.dispose();
    cityController.dispose();
    super.onClose();
  }
}
