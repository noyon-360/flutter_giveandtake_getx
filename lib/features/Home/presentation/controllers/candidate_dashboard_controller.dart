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
          _appliedJobsRepo = AppliedJobsRepoImpl();
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
    print('🔄 [CandidateDashboard] Starting to fetch dashboard data...');
    
    final userId = await _authStorageService.getUserId();
    if (userId == null) {
      print('❌ [CandidateDashboard] User ID not found in storage');
      setError("User ID not found");
      return;
    }

    print('✅ [CandidateDashboard] User ID: $userId');

    await Future.wait([
      fetchResume(userId),
      fetchAppliedJobs(userId),
    ]);
    
    print('✅ [CandidateDashboard] Dashboard data fetch completed');
  }

  Future<void> fetchResume(String userId) async {
    print('📄 [CandidateDashboard] Fetching resume data...');
    isLoadingResume.value = true;
    
    try {
      final endpoint = '${ApiConstants.baseUrl}/create-resume/get-resume';
      print('🌐 [CandidateDashboard] API Endpoint: $endpoint');
      
      final result = await _apiClient.get(
        endpoint,
        fromJsonT: (json) => CandidateResumeResponseModel.fromJson(json as Map<String, dynamic>),
      );

      result.fold(
        (fail) {
          print('❌ [CandidateDashboard] Failed to fetch resume: ${fail.message}');
          print('❌ [CandidateDashboard] Error details: ${fail.toString()}');
        },
        (success) {
          resumeData.value = success.data;
          print('✅ [CandidateDashboard] Resume data fetched successfully!');
          
          // Log resume details
          final resume = success.data.resume;
          if (resume != null) {
            print('👤 [CandidateDashboard] Name: ${resume.firstName} ${resume.lastName}');
            print('📧 [CandidateDashboard] Email: ${resume.email}');
            print('📍 [CandidateDashboard] Location: ${resume.city}, ${resume.country}');
            print('🖼️ [CandidateDashboard] Photo: ${resume.photo != null ? "✓" : "✗"}');
            print('🎨 [CandidateDashboard] Banner: ${resume.banner != null ? "✓" : "✗"}');
            print('📝 [CandidateDashboard] About: ${resume.aboutUs != null && resume.aboutUs!.isNotEmpty ? "✓" : "✗"}');
            print('🎯 [CandidateDashboard] Skills count: ${resume.skills.length}');
            print('🎯 [CandidateDashboard] Skills: ${resume.skills.join(", ")}');
          }
          
          // Log elevator pitch
          final elevatorPitches = success.data.elevatorPitch;
          print('🎬 [CandidateDashboard] Elevator Pitches count: ${elevatorPitches.length}');
          if (elevatorPitches.isNotEmpty) {
            final firstPitch = elevatorPitches.first;
            print('🎬 [CandidateDashboard] Elevator Pitch Video URL: ${firstPitch.video?.hlsUrl ?? "N/A"}');
            print('🎬 [CandidateDashboard] Video Status: ${firstPitch.status ?? "N/A"}');
          }
          
          // Log experiences
          final experiences = success.data.experiences;
          print('💼 [CandidateDashboard] Experiences count: ${experiences.length}');
          
          // Log education
          final education = success.data.education;
          print('🎓 [CandidateDashboard] Education count: ${education.length}');
          
          // Log awards
          final awards = success.data.awardsAndHonors;
          print('🏆 [CandidateDashboard] Awards count: ${awards.length}');
        },
      );
    } catch (e, stackTrace) {
      print('❌ [CandidateDashboard] Error fetching resume: $e');
      print('❌ [CandidateDashboard] Stack trace: $stackTrace');
    } finally {
      isLoadingResume.value = false;
      print('📄 [CandidateDashboard] Resume fetch completed (loading: false)');
    }
  }

  Future<void> fetchAppliedJobs(String userId) async {
    print('💼 [CandidateDashboard] Fetching applied jobs...');
    isLoadingJobs.value = true;
    
    try {
      final result = await _appliedJobsRepo.fetchUserApplications(userId: userId);
      
      result.fold(
        (fail) {
          print('❌ [CandidateDashboard] Failed to fetch applied jobs: ${fail.message}');
        },
        (success) {
          appliedJobs.assignAll(success.data.applications);
          print('✅ [CandidateDashboard] Applied jobs fetched successfully!');
          print('💼 [CandidateDashboard] Applied jobs count: ${appliedJobs.length}');
          
          // Fallback: If fetchResume failed or returned null, try to use valid data from here
          if (resumeData.value == null && success.data.createResume != null) {
            print('⚠️ [CandidateDashboard] Resume data is null, but found in applied jobs response');
          }
        },
      );
    } catch (e, stackTrace) {
      print('❌ [CandidateDashboard] Error fetching applied jobs: $e');
      print('❌ [CandidateDashboard] Stack trace: $stackTrace');
    } finally {
      isLoadingJobs.value = false;
      print('💼 [CandidateDashboard] Applied jobs fetch completed (loading: false)');
    }
  }
}
