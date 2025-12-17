import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/job_listing/data/models/job_application_request.dart';
import 'package:karlfive/features/job_listing/data/models/user_profile_model.dart';
import 'package:karlfive/features/job_listing/domain/usecases/get_user_profile_usecase.dart';
import 'package:karlfive/features/job_listing/domain/usecases/submit_job_application_usecase.dart';
import 'package:karlfive/features/plan_pricing/presentation/screens/plan_pricing_screen.dart';
import 'package:path_provider/path_provider.dart';

class JobApplicationController extends GetxController {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final SubmitJobApplicationUseCase _submitJobApplicationUseCase;

  JobApplicationController({
    required GetUserProfileUseCase getUserProfileUseCase,
    required SubmitJobApplicationUseCase submitJobApplicationUseCase,
  })  : _getUserProfileUseCase = getUserProfileUseCase,
        _submitJobApplicationUseCase = submitJobApplicationUseCase;

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

  Future<void> submitApplication(String jobId) async {
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
      // Collect answers
      List<Map<String, String>> answers = [];
      for (var q in customQuestions) {
         final id = q['_id'] ?? q['id'] ?? q['question'];
         if (id != null && answerControllers.containsKey(id.toString())) {
            final answer = answerControllers[id.toString()]?.text ?? '';
            if (answer.isNotEmpty) {
               // Sending back questionId and answer based on assumption. 
               // Also sending original question text might be safer if ID logic is loose.
               answers.add({
                 'questionId': q['_id'] ?? '',
                 'question': q['question'] ?? '',
                 'answer': answer,
               });
            }
         }
      }

      final request = JobApplicationRequest(
        jobId: jobId,
        visaRequired: visaOption.value,
        elevatorPitchUrl: elevatorPitchController.text.isNotEmpty
            ? elevatorPitchController.text
            : null,
        expectedSalary:
            pitchController.text.isNotEmpty ? pitchController.text : null,
        resumeFileName: selectedResume.value?.name,
        customQuestions: answers.isNotEmpty ? answers : null,
      );

      final result = await _submitJobApplicationUseCase.call(request);

      result.fold(
        (failure) {
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
        (success) {
          Get.snackbar(
            'Success',
            'Application submitted successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Navigate to success screen or plan pricing
          Get.to(() => PlanPricingScreen());
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit application',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmittingApplication.value = false;
    }
  }
}
