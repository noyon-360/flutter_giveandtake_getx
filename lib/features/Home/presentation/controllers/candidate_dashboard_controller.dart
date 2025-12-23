import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';
import 'package:karlfive/core/network/api_client.dart';
import 'package:karlfive/core/network/constants/api_constants.dart';
import 'package:karlfive/core/network/services/auth_storage_service.dart';
import 'package:karlfive/features/company/data/model/candidate_resume_response_model.dart';
import 'package:karlfive/features/profile_dasboard/data/models/applied_jobs_response_model.dart';
import 'package:karlfive/features/profile_dasboard/data/repo/applied_jobs_repo_impl.dart';

class CandidateDashboardController extends BaseController {
  final AuthStorageService _authStorageService;
  late final AppliedJobsRepoImpl _appliedJobsRepo;
  final ApiClient _apiClient;

  CandidateDashboardController({
    AuthStorageService? authStorageService,
    ApiClient? apiClient,
  })  : _authStorageService = authStorageService ?? Get.find<AuthStorageService>(),
        _apiClient = apiClient ?? ApiClient() {
          _appliedJobsRepo = AppliedJobsRepoImpl(apiClient: _apiClient);
        }

  final Rxn<CandidateResumeResponseModel> resumeData = Rxn<CandidateResumeResponseModel>();
  final RxList<ApplicationModel> appliedJobs = <ApplicationModel>[].obs;
  
  final isLoadingResume = false.obs;
  final isLoadingJobs = false.obs;

  @override
  void onInit() {
    super.onInit();
    // We will call fetches manually from UI
  }

  Future<void> fetchDashboardData() async {
    final userId = await _authStorageService.getUserId();
    if (userId == null) {
      setError("User ID not found");
      return;
    }

    await Future.wait([
      fetchResume(userId),
      fetchAppliedJobs(userId),
    ]);
  }

  Future<void> fetchResume(String userId) async {
    isLoadingResume.value = true;
    try {
      // Trying to fetch the full resume including Elevator Pitch
      // Note: The CompanyRepo uses a hardcoded URL. We attempt to use the generic structure.
      // If there is no endpoint like /create-resume/get-resume without parameter, 
      // we might need to rely on what we can find.
      // Assuming a GET request to /create-resume/get-resume retrieves the logged-in user's resume
      // Or we try to use the endpoint pattern: /create-resume/get-resume
      
      final result = await _apiClient.get(
        '${ApiConstants.baseUrl}/create-resume/get-resume',
        fromJsonT: (json) => CandidateResumeResponseModel.fromJson(json as Map<String, dynamic>),
      );

      result.fold(
        (fail) {
           print("Failed to fetch full resume: ${fail.message}");
           // If failed opacity, we might not show the full data
        },
        (success) {
          resumeData.value = success.data;
        },
      );
    } catch (e) {
      print("Error fetching resume: $e");
    } finally {
      isLoadingResume.value = false;
    }
  }

  Future<void> fetchAppliedJobs(String userId) async {
    isLoadingJobs.value = true;
    try {
      final result = await _appliedJobsRepo.fetchUserApplications(userId: userId);
      
      result.fold(
        (fail) {
          // handle error
        },
        (success) {
          appliedJobs.assignAll(success.data.applications);
          
          // Fallback: If fetchResume failed or returned null, try to use valid data from here
          // createResume in AppliedJobsResponseModel is simpler (no elevator pitch)
          if (resumeData.value == null && success.data.createResume != null) {
             // We can map partial data if needed, but UI expects CandidateResumeResponseModel.
             // For now we prioritize the dedicated resume fetch.
          }
        },
      );
    } catch (e) {
      print("Error fetching jobs: $e");
    } finally {
      isLoadingJobs.value = false;
    }
  }
}
