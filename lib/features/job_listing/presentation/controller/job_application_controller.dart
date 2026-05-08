import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/contracts/web/job_contract.dart';
import 'package:giveandtake/core/network/constants/key_constants.dart';
import 'package:giveandtake/core/network/services/secure_store_services.dart';
import 'package:giveandtake/features/job_listing/data/models/job_application_request.dart';
import 'package:giveandtake/features/job_listing/data/models/user_profile_model.dart';
import 'package:giveandtake/features/job_listing/domain/repositories/job_application_repository.dart';
import 'package:giveandtake/features/job_listing/domain/usecases/get_job_details_usecase.dart';
import 'package:giveandtake/features/job_listing/domain/usecases/get_user_profile_usecase.dart';
import 'package:giveandtake/features/job_listing/domain/usecases/submit_job_application_usecase.dart';
import 'package:giveandtake/features/profile_dasboard/presentation/screens/job_history.dart';
import 'package:path_provider/path_provider.dart';

class JobApplicationController extends GetxController {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final SubmitJobApplicationUseCase _submitJobApplicationUseCase;
  final GetJobDetailsUseCase _getJobDetailsUseCase;
  final JobApplicationRepository _jobApplicationRepository = Get.find();

  JobApplicationController({
    required GetUserProfileUseCase getUserProfileUseCase,
    required SubmitJobApplicationUseCase submitJobApplicationUseCase,
    required GetJobDetailsUseCase getJobDetailsUseCase,
  }) : _getUserProfileUseCase = getUserProfileUseCase,
       _submitJobApplicationUseCase = submitJobApplicationUseCase,
       _getJobDetailsUseCase = getJobDetailsUseCase;

  // Observable variables
  final Rxn<UserProfileModel> userProfile = Rxn<UserProfileModel>();
  final RxBool isLoadingProfile = true.obs;
  final RxBool isSubmittingApplication = false.obs;
  final Rxn<PlatformFile> selectedResume = Rxn<PlatformFile>();
  final RxBool isPickingResume = false.obs;
  final RxString visaOption = ''.obs;
  final RxBool agreeToShareCV = true.obs;

  // FilePicker can only handle one native request at a time on iOS.
  static Future<FilePickerResult?>? _activeResumePickerRequest;

  // Store jobData for navigation after successful submission
  final Rxn<Map<String, dynamic>> jobData = Rxn<Map<String, dynamic>>();

  // Text controllers
  final pitchController = TextEditingController();
  final elevatorPitchController =
      TextEditingController(); // URL input if needed

  // Custom Questions handling
  final RxList<Map<String, dynamic>> customQuestions =
      <Map<String, dynamic>>[].obs;
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
        final id =
            q['_id'] ??
            q['id'] ??
            q['question'] ??
            DateTime.now().toIso8601String();
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
            final questionMaps = jobModel.customQuestion
                .map((e) => e.toJson())
                .toList();
            initQuestions(questionMaps);
          }
        },
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
    if (_activeResumePickerRequest != null) {
      print('⚠️ File picker already in progress, ignoring tap');
      return;
    }

    try {
      isPickingResume.value = true;
      print('🔄 Opening file picker on ${Platform.operatingSystem}...');

      final pickerRequest = FilePicker.platform.pickFiles(
        withData: false,
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          print('⏱️ File picker timeout');
          return null;
        },
      );
      _activeResumePickerRequest = pickerRequest;
      final result = await pickerRequest;

      if (result != null && result.files.isNotEmpty) {
        selectedResume.value = result.files.first;
        print('✅ Resume selected: ${result.files.first.name}');
      } else {
        print('⚠️ No file selected or picker cancelled');
      }
    } catch (e) {
      print('❌ Error picking resume: $e');
      // Only show error if not a cancellation
      if (!e.toString().contains('Cancelled') &&
          !e.toString().contains('multiple_request')) {
        Get.snackbar(
          'Error',
          'Failed to pick resume',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      // Add longer delay on iOS to ensure the platform channel fully closes
      await Future.delayed(Duration(
        milliseconds: Platform.isIOS ? 800 : 300,
      ));
      isPickingResume.value = false;
      _activeResumePickerRequest = null;
    }
  }

  void removeResume() {
    selectedResume.value = null;
  }

  String? get existingResumeId {
    final value = jobData.value?['resumeId']?.toString();
    if (value == null || value.trim().isEmpty) return null;
    return value;
  }

  bool get shouldAskVisa {
    final requirements =
        jobData.value?['applicationRequirement'] as List<dynamic>? ?? [];
    return requirements.any((requirement) {
      if (requirement is! Map<String, dynamic>) return false;
      final label = requirement['requirement']?.toString().trim().toLowerCase() ?? '';
      return label == JobPayloadBuilder.validVisaLabel.toLowerCase();
    });
  }

  bool get isVisaRequired {
    final requirements =
        jobData.value?['applicationRequirement'] as List<dynamic>? ?? [];
    for (final requirement in requirements) {
      if (requirement is! Map<String, dynamic>) continue;
      final label = requirement['requirement']?.toString().trim().toLowerCase() ?? '';
      if (label == JobPayloadBuilder.validVisaLabel.toLowerCase()) {
        return requirement['status']?.toString().trim().toLowerCase() ==
            'required';
      }
    }
    return false;
  }

  bool get isResumeRequired {
    final requirements =
        jobData.value?['applicationRequirement'] as List<dynamic>? ?? [];
    for (final requirement in requirements) {
      if (requirement is! Map<String, dynamic>) continue;
      final label = requirement['requirement']?.toString().trim().toLowerCase() ?? '';
      if (label == 'resume') {
        return requirement['status']?.toString().trim().toLowerCase() ==
            'required';
      }
    }
    return false;
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
    isSubmittingApplication.value = true;

    try {
      final secureStore = SecureStoreServices();
      final userId = await secureStore.retrieveData(KeyConstants.userId);

      if (userId == null || userId.isEmpty) {
        Get.snackbar(
          'Error',
          'User ID not found. Please log in again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isSubmittingApplication.value = false;
        return;
      }

      if (shouldAskVisa && isVisaRequired && visaOption.value.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Please confirm whether you have a valid visa for this location.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isSubmittingApplication.value = false;
        return;
      }

      final answers = <Map<String, String>>[];
      for (var q in customQuestions) {
        final id = q['_id'] ?? q['id'] ?? q['question'];
        if (id != null && answerControllers.containsKey(id.toString())) {
          final answer = answerControllers[id.toString()]?.text.trim() ?? '';
          if (answer.isNotEmpty) {
            answers.add({
              'question': q['question'] ?? '',
              'ans': answer,
            });
          }
        }
      }

      String? resolvedResumeId = resumeId ?? existingResumeId;
      final pickedResume = selectedResume.value;
      if (pickedResume != null) {
        if (pickedResume.path == null || pickedResume.path!.isEmpty) {
          Get.snackbar(
            'Error',
            'The selected resume file is not accessible.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          isSubmittingApplication.value = false;
          return;
        }

        final uploadResult = await _jobApplicationRepository.uploadResume(
          file: File(pickedResume.path!),
          userId: userId,
        );

        final uploadedResumeId = uploadResult.fold<String?>(
          (failure) {
            Get.snackbar(
              'Error',
              failure.message,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return null;
          },
          (success) => success.data,
        );

        if (uploadedResumeId == null || uploadedResumeId.isEmpty) {
          isSubmittingApplication.value = false;
          return;
        }
        resolvedResumeId = uploadedResumeId;
      }

      if (isResumeRequired &&
          (resolvedResumeId == null || resolvedResumeId.isEmpty)) {
        Get.snackbar(
          'Error',
          'Please upload or select a resume before submitting.',
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
        resumeId: resolvedResumeId,
        answer: answers.isNotEmpty ? answers : null,
        hasValidVisa: shouldAskVisa && visaOption.value.trim().isNotEmpty
            ? visaOption.value == 'Yes'
            : null,
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
            duration: const Duration(seconds: 2),
          );

          Future.delayed(const Duration(milliseconds: 800), () {
            Get.offAll(() => const JobHistoryScreen());
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

  Future<void> _legacySubmitApplication(String jobId, {String? resumeId}) async {
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
          'User ID not found. Please log in again.',
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
              'ans': answer, // Changed from 'answer' to 'ans' to match API spec
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

          // Navigate to Job History screen after a short delay
          Future.delayed(const Duration(milliseconds: 800), () {
            Get.offAll(() => const JobHistoryScreen());
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
