import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/network/constants/key_constants.dart';
import 'package:karlfive/core/network/services/secure_store_services.dart';
import 'package:karlfive/features/job_listing/data/models/job_application_request.dart';
import 'package:karlfive/features/job_listing/data/models/user_profile_model.dart';
import 'package:karlfive/features/job_listing/domain/usecases/get_job_details_usecase.dart';
import 'package:karlfive/features/job_listing/domain/usecases/get_user_profile_usecase.dart';
import 'package:karlfive/features/job_listing/domain/usecases/submit_job_application_usecase.dart';
import 'package:karlfive/features/job_listing/presentation/screens/job_listing_screen.dart';
import 'package:path_provider/path_provider.dart';

class JobApplicationController extends GetxController {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final SubmitJobApplicationUseCase _submitJobApplicationUseCase;
  final GetJobDetailsUseCase _getJobDetailsUseCase;

  JobApplicationController({
    required GetUserProfileUseCase getUserProfileUseCase,
    required SubmitJobApplicationUseCase submitJobApplicationUseCase,
    required GetJobDetailsUseCase getJobDetailsUseCase,
  })  : _getUserProfileUseCase = getUserProfileUseCase,
        _submitJobApplicationUseCase = submitJobApplicationUseCase,
        _getJobDetailsUseCase = getJobDetailsUseCase;

  // Observable variables
  final Rxn<UserProfileModel> userProfile = Rxn<UserProfileModel>();
  final RxBool isLoadingProfile = true.obs;
  final RxBool isSubmittingApplication = false.obs;
  final Rxn<PlatformFile> selectedResume = Rxn<PlatformFile>();
  final RxString visaOption = 'Yes'.obs;
  final RxBool agreeToShareCV = true.obs;

  // Text controllers
  final pitchController = TextEditingController();
  final elevatorPitchController = TextEditingController(); // URL input if needed
  
  // Custom Questions handling
  final RxList<Map<String, dynamic>> customQuestions = <Map<String, dynamic>>[].obs;
  // Map to store controllers using question ID as key
  final Map<String, TextEditingController> answerControllers = {};

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  @override
  void onClose() {
    pitchController.dispose();
    elevatorPitchController.dispose();
    for (var controller in answerControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }
  
  void initQuestions(List<dynamic> questions) {
    customQuestions.clear();
    // specific to re-init, clear old controllers
    for (var controller in answerControllers.values) {
      controller.dispose();
    }
    answerControllers.clear();

    for (var q in questions) {
      if (q is Map<String, dynamic>) {
        customQuestions.add(q);
        // Use '_id' if available, otherwise generate a key or use question text
        final id = q['_id'] ?? q['id'] ?? q['question'] ?? DateTime.now().toIso8601String();
        answerControllers[id.toString()] = TextEditingController();
      }
    }
  }

  Future<void> fetchJobDetails(String jobId) async {
    try {
      final result = await _getJobDetailsUseCase.call(jobId);
      result.fold(
        (failure) {
          //  print("Failed to fetch job details: ${failure.message}");
        },
        (success) {
           final jobModel = success.data;
           // jobModel.customQuestion is non-nullable List<CustomQuestionModel>
           if (jobModel.customQuestion.isNotEmpty) {
              final questionMaps = jobModel.customQuestion.map((e) => e.toJson()).toList();
              initQuestions(questionMaps);
           }
        }
      );
    } catch (e) {
      print("Error fetching job details: $e");
    }
  }

  Future<void> fetchUserProfile() async {
    isLoadingProfile.value = true;
    
    try {
      final result = await _getUserProfileUseCase.call();

      result.fold(
        (failure) {
          isLoadingProfile.value = false;
          Get.snackbar(
            'Warning',
            'Could not load user profile data: ${failure.message}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        },
        (success) {
          userProfile.value = success.data;
          isLoadingProfile.value = false;
        },
      );
    } catch (e) {
      isLoadingProfile.value = false;
      Get.snackbar(
        'Warning',
        'Could not load user profile data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  Future<void> pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      withData: false,
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      selectedResume.value = result.files.first;
    }
  }

  void removeResume() {
    selectedResume.value = null;
  }

  Future<void> downloadFile(PlatformFile file) async {
    try {
      // Check if the file has a path
      if (file.path == null) {
        Get.snackbar(
          'Error',
          'File path not available',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Get the app's directory (no permission needed)
      Directory? directory;
      if (Platform.isAndroid) {
        // Use app's external storage directory (accessible without permissions)
        directory = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        // For iOS, use the app's documents directory
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        Get.snackbar(
          'Error',
          'Could not access storage directory',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Create a Documents folder in the app directory
      final documentsPath = '${directory.path}/Documents';
      final documentsDir = Directory(documentsPath);
      if (!await documentsDir.exists()) {
        await documentsDir.create(recursive: true);
      }

      // Create the destination path
      final String newPath = '$documentsPath/${file.name}';

      // Copy the file
      final File sourceFile = File(file.path!);
      await sourceFile.copy(newPath);

      Get.snackbar(
        'Success',
        'File saved to app Documents folder: ${file.name}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to download file: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> submitApplication(String jobId, {String? resumeId}) async {
    print('========== SUBMIT APPLICATION CALLED ==========');
    print('JobId received: "$jobId"');
    print('JobId isEmpty: ${jobId.isEmpty}');
    print('ResumeId received: "$resumeId"');
    print('===============================================');
    
    if (selectedResume.value == null) {
      Get.snackbar(
        'Error',
        'Please upload a resume before submitting',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isSubmittingApplication.value = true;

    try {
      // Get userId from secure storage
      final secureStore = SecureStoreServices();
      final userId = await secureStore.retrieveData(KeyConstants.userId);
      
      if (userId == null || userId.isEmpty) {
        Get.snackbar(
          'Error',
          'User ID not found. Please login again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isSubmittingApplication.value = false;
        return;
      }

      // Collect answers in the new format
      List<Map<String, String>> answers = [];
      for (var q in customQuestions) {
         final id = q['_id'] ?? q['id'] ?? q['question'];
         if (id != null && answerControllers.containsKey(id.toString())) {
            final answer = answerControllers[id.toString()]?.text ?? '';
            if (answer.isNotEmpty) {
               answers.add({
                 'question': q['question'] ?? '',
                 'ans': answer,  // Changed from 'answer' to 'ans' to match API spec
               });
            }
         }
      }

      // Use resumeId from parameter if provided, otherwise show error
      if (resumeId == null || resumeId.isEmpty) {
        Get.snackbar(
          'Error',
          'Resume ID not found. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isSubmittingApplication.value = false;
        return;
      }

      final request = JobApplicationRequest(
        jobId: jobId,
        userId: userId,
        resumeId: resumeId,
        status: 'pending',
        answer: answers.isNotEmpty ? answers : null,
      );

      final result = await _submitJobApplicationUseCase.call(request);

      print('========== SUBMIT APPLICATION RESULT ==========');
      print('Result: $result');
      print('Is Right (Success): ${result.isRight()}');
      print('Is Left (Failure): ${result.isLeft()}');
      print('================================================');

      result.fold(
        (failure) {
          print('❌ FAILURE CALLBACK - Message: ${failure.message}');
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
        (success) {
          print('✅ SUCCESS CALLBACK - Message: ${success.message}');
          // Show success snackbar
          Get.snackbar(
            'Success',
            'Application submitted successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          
          // Navigate directly to All Jobs screen after a short delay
          Future.delayed(const Duration(milliseconds: 800), () {
            Get.offAll(() => const JobListingScreen());
          });
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit application: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmittingApplication.value = false;
    }
  }
}
