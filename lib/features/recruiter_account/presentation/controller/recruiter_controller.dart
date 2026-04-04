import 'dart:developer' as DPrint;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:dio/dio.dart';
import 'package:giveandtake/core/network/services/auth_storage_service.dart';
import 'package:giveandtake/features/company/presentation/screen/manage_job_req_screen.dart';
import 'package:giveandtake/features/recruiter_account/data/models/archieve_job_request_model.dart'
    hide ApplicationRequirement, CustomQuestion;
import 'package:giveandtake/features/recruiter_account/data/models/connect_company_request_model.dart';
import 'package:giveandtake/features/recruiter_account/data/models/follow_request_model.dart';
import 'package:giveandtake/features/recruiter_account/data/models/get_category_response_model.dart';
import 'package:giveandtake/features/recruiter_account/data/models/get_company_response_model.dart';
import 'package:giveandtake/features/recruiter_account/data/models/get_currency_response_model.dart';
import 'package:giveandtake/features/recruiter_account/data/models/get_single_job_response_model.dart'
    hide ApplicationRequirement, CustomQuestion;
import 'package:giveandtake/features/recruiter_account/data/models/job_update_request_model.dart'
    hide ApplicationRequirement, CustomQuestion;
import 'package:giveandtake/features/recruiter_account/data/models/leave_company_request_model.dart';
import 'package:giveandtake/features/recruiter_account/data/models/public_view_response_model.dart';
import 'package:giveandtake/features/recruiter_account/domain/repo/repo.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/upload_elevator_pitch.dart';
import 'package:giveandtake/features/recruiter_account/presentation/screens/create_recruiter_account.dart';
import 'package:giveandtake/features/recruiter_account/presentation/screens/recruiter_page.dart';
import '../../../../core/base/base_controller.dart';
import '../../../../core/network/services/multiple_form_data_manager.dart';
import '../../../../core/network/services/secure_store_services.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../data/models/current_password_update_request_model.dart';
import '../../data/models/get_job_response_model.dart'
    hide ApplicationRequirement, CustomQuestion;
import '../../data/models/get_recruiter_response_model.dart';
import '../../data/models/job_create_request_model.dart';
import '../models/job_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../elevator/data/models/upload_video_request_model.dart';
import '../../../elevator/data/models/upload_video_response_model.dart';

import '../widgets/populate_for_single_job_edit.dart';
import 'job_controller/career_stage_controller.dart';
import 'job_controller/employment_type_controller.dart';
import 'job_controller/experience_level_controller.dart';
import 'job_controller/location_type_controller.dart';

class RecruiterController extends BaseController {
  final AuthStorageService _authStorageService;

  final Repo _recruiterRepo;
  var isSkipLoading = false.obs;
  var isContinueLoading = false.obs;

  // inside RecruiterController class
  final RxString searchText = ''.obs;

  final companies = <GetCompanyResponseModel>[].obs;

  final publicView = Rx<RecruiterPublicViewResponseModel?>(null);

  // In RecruiterController
  final JobFormController jobFormController = Get.put(JobFormController());
  RxString? companySearchQuery;

  // Add this line in RecruiterController
  final archiveLoadingMap = <String, bool>{}.obs;

  final category = <Category>[].obs;
  final currency = <GetCurrencyResponseModel>[].obs;

  // final selectedCompany = Rxn<GetCompanyResponseModel>();
  final selectedCompany = RxnString();

  final yourJobList = <YourJobResponseModel>[].obs;
  final Rxn<GetSingleJobResponseModel> singleJob =
      Rxn<GetSingleJobResponseModel>();

  var archiveJobs = <JobModel>[].obs;

  final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();

  RecruiterController(this._recruiterRepo, this._authStorageService);

  final Rxn<FetchRecruiterResponseModel> userInfo =
      Rxn<FetchRecruiterResponseModel>();

  final RxString uploadedVideoPath = ''.obs;
  final RxBool successVideoUploaded = false.obs;

  final EmploymentTypeController employeeController = Get.put(
    EmploymentTypeController(),
  );
  final ExperienceLevelController experienceLevelController = Get.put(
    ExperienceLevelController(),
  );
  final LocationTypeController locationTypeController = Get.put(
    LocationTypeController(),
  );
  final CareerStageController careerStageController = Get.put(
    CareerStageController(),
  );

  @override
  void onInit() {
    super.onInit();
    fetchCompany(); //Fetch when controller is created
    _fetchProfileIfLoggedIn();
    fetchCategory();
    fetchCurrency();

    // getJob();
  }

  Future<void> _fetchProfileIfLoggedIn() async {
    final userId = await _authStorageService.getUserId();
    if (userId != null && userId.isNotEmpty) {
      await fetchProfile();
    }
  }

  Future<void> fetchCompany() async {
    setLoading(true);
    setError('');

    final result = await _recruiterRepo.fetchCompany();

    result.fold(
      (fail) {
        setError(fail.message);
        setLoading(false);
      },
      (success) {
        companies.value = success.data;
        setLoading(false);
      },
    );
  }

  Future<void> fetchCategory() async {
    setLoading(true);
    setError('');

    final result = await _recruiterRepo.fetchCategory();

    result.fold(
      (fail) {
        setError(fail.message);
        setLoading(false);
      },
      (success) {
        category.value = success.data.category;
        setLoading(false);
      },
    );
  }

  Future<void> fetchCurrency() async {
    setLoading(true);
    setError('');

    final result = await _recruiterRepo.fetchCurrency();

    result.fold(
      (fail) {
        setError(fail.message);
        setLoading(false);
      },
      (success) {
        // success.data is already a List<GetCurrencyResponseModel>
        currency.value = success.data;

        setLoading(false);
      },
    );
  }

  Future createJobPost(
    final String title,
    final String description,
    final String location,
    final int vacancy,
    final String experience,
    final String deadline,
    final String jobCategoryId,
    final String name,
    final String role,
    final String compensation,
    final List<ApplicationRequirement> applicationRequirement,
    final List<CustomQuestion> customQuestion,
    final String employementType,
    final String websiteUrl,
    final String publishDate,
    final String careerStage,
    final String locationType,
    final String website_Url,
  ) async {
    setLoading(true);
    setError("");

    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }
    final request = JobPostRequestModel(
      userId: userId,
      title: title,
      description: description,
      location: location,
      vacancy: vacancy,
      experience: experience,
      deadline: deadline,
      jobCategoryId: jobCategoryId,
      name: name,
      role: role,
      compensation: compensation,
      applicationRequirement: applicationRequirement,
      customQuestion: customQuestion,
      employementType: employementType,
      websiteUrl: websiteUrl,
      publishDate: publishDate,
      careerStage: careerStage,
      locationType: locationType,
      website_Url: website_Url,
    );

    final result = await _recruiterRepo.createNewJobPost(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("create job success result : ${fail.message}");
        setLoading(false);
      },
      (success) async {
        DPrint.log("create job success result : ${success.message}");
        final userRole = await _authStorageService.getUserRole();
        if (userRole == 'recruiter') {
          Get.to(() => RecruiterPageScreen());
        } else {
          Get.to(() => ManageJobPostScreen());
        }
        setLoading(false);
      },
    );
  }

  Future<void> updateSingleJob({
    required UpdateJobRequest request,
    required String jobId,
  }) async {
    setLoading(true);
    setError("");

    // ADD THIS PRINT
    print("SENDING TO BACKEND → companyUrl = '${request.website_Url}'");
    print("FULL JSON BEING SENT → ${request.toJson()}");
    final result = await _recruiterRepo.singleJobUpdate(request, jobId);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("Update job failed: ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("Update job success: ${success.message}");
        // if your repo returns updated job
        DPrint.log(success.data.website_Url);
        DPrint.log("FULL JSON BEING SENT → ${request.toJson()}");

        Get.back();
        setLoading(false);
      },
    );
  }

  Future<void> updateArchieveJob({
    required ArchieveJobRequestModel request,
    required String jobId,
  }) async {
    final result = await _recruiterRepo.archieveJobUpdate(request, jobId);

    result.fold(
      (fail) {
        DPrint.log("Archive job failed: ${fail.message}");
        // you can show snackbar here if you want
      },
      (success) {
        DPrint.log("Archive job success: ${success.message}");

        // THIS IS THE IMPORTANT PART
        final index = yourJobList.indexWhere((j) => j.id == jobId);
        if (index != -1) {
          // Update the field directly on the existing model
          yourJobList[index].arcrivedJob = request.arcrivedJob!;
          yourJobList[index] = yourJobList[index];
          // Tell GetX the list changed → UI updates immediately
          //yourJobList.refresh();
        }

        // Optional: refresh whole list from server (safe fallback)
        // getJob();
      },
    );
  }

  Future connectCompany(final String companyId) async {
    setLoading(true);
    setError("");

    final request = ConnectCompanyRequest(companyId: companyId);
    final result = await _recruiterRepo.connectCompany(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("connect company success result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("connect company success result : ${success.message}");
        Get.back();
        setLoading(false);
      },
    );
  }

  Future leaveCompany(
    String cname,
    String aboutUs,
    String industry,
    String country,
    String city,
    String zipcode,
    String cemail,
    String clogo,
    String banner,
    String slug,
    List<String> employeesId,
    List<SocialLinkRequest> sLink,
    List<String> service,
  ) async {
    setLoading(true);
    setError("");

    final request = LeaveCompanyRequestModel(
      cname: cname,
      aboutUs: aboutUs,
      industry: industry,
      country: country,
      city: city,
      zipcode: zipcode,
      cemail: cemail,
      clogo: clogo,
      banner: banner,
      slug: slug,
      employeesId: employeesId,
      sLink: sLink,
      service: service,
    );
    final result = await _recruiterRepo.leaveCompany(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("leave company success result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("leave company success result : ${success.message}");
        Get.back();
        setLoading(false);
      },
    );
  }

  Future getJob() async {
    //setLoading(true);
    setError("");

    final result = await _recruiterRepo.yourJob();

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("your job fetch failed result : ${fail.message}");
        //setLoading(false);
      },
      (success) {
        DPrint.log("your job fetch success result : ${success.message}");
        yourJobList.value = success.data;
        //setLoading(false);
      },
    );
  }

  Future getSingleJob(String jobId) async {
    setLoading(true);
    setError("");

    final result = await _recruiterRepo.singleJob(jobId);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("your job fetch failed result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("your job fetch success result : ${success.message}");

        singleJob.value = success.data;
        employeeController.selectedEmploymentType.value = employeeController
            .getDisplayName(singleJob.value?.employementType ?? '');

        // 2. Experience Level (field: experience → "Entry Level", "Senior Level", etc.)
        final rawExperience = singleJob.value?.experience?.trim() ?? '';
        experienceLevelController.selectedExperienceLevel.value =
            experienceLevelController.experienceLevels.contains(rawExperience)
            ? rawExperience
            : 'Mid Level'; // fallback

        locationTypeController.selectedLocationType.value =
            locationTypeController.getDisplayName(
              singleJob.value?.locationType ?? '',
            );

        careerStageController.selectedCareerStage.value = careerStageController
            .getDisplayName(singleJob.value?.careerStage ?? '');

        print("=== DEBUG DROPDOWNS ===");
        print("Raw experience from API: '${singleJob.value?.experience}'");
        print("Raw careerStage from API: '${singleJob.value?.careerStage}'");

        //print("Experience display name: '${experienceLevelController.getDisplayName(singleJob.value?.experience ?? '')}'");
        print(
          "CareerStage display name: '${careerStageController.getDisplayName(singleJob.value?.careerStage ?? '')}'",
        );

        print(
          "Selected Experience: ${experienceLevelController.selectedExperienceLevel.value}",
        );
        print(
          "Selected CareerStage: ${careerStageController.selectedCareerStage.value}",
        );

        setLoading(false);
      },
    );
  }

  Future follow(final String recruiterId, final String userId) async {
    setLoading(true);
    setError("");

    final request = FollowRequestModel(
      recruiterId: recruiterId,
      userId: userId,
    );
    final result = await _recruiterRepo.follow(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("Follow success result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("Follow success result : ${success.message}");
        Get.back();
        setLoading(false);
      },
    );
  }

  Future<void> uploadVideo(
    ElevatorPitchController elevatorPitchController,
  ) async {
    final videoPath = elevatorPitchController.selectedVideoPath.value;

    //Check if video is selected
    if (videoPath.isEmpty) {
      setError('Please select a video first.');
      return;
    }

    final file = File(videoPath);
    if (!file.existsSync()) {
      Get.snackbar('Error', 'Selected video file not found.');
      return;
    }

    setLoading(true);
    setError('');

    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }

    try {
      //Delete any existing video unconditionally
      final deleteResult = await _recruiterRepo.deleteVideo(userId);
      deleteResult.fold(
        (fail) {
          //DPrint.log('Failed to delete existing video: ${fail.message}');
          // Get.snackbar(
          //   'Error',
          //   'Could not delete previous video: ${fail.message}',
          // );
          setLoading(false);
          return;
        },
        (_) {
          DPrint.log('Existing video deleted successfully');
          uploadedVideoPath.value = '';
          successVideoUploaded.value = false;
        },
      );

      //Upload new video using pre-signed URL flow
      final apiClient = ApiClient();

      final fileName = file.path.split('/').last;
      final fileSize = await file.length();
      final fileType = 'video/mp4';

      final requestModel = UploadVideoRequestModel(
        fileName: fileName,
        fileType: fileType,
        fileSize: fileSize,
      );

      DPrint.log('🔄 Requesting upload URL from server...');
      final urlResult = await apiClient.post(
        ApiConstants.elevatorPitchVideo.uploadVideo(userId),
        data: requestModel.toJson(),
        fromJsonT: (json) => UploadVideoResponseModel.fromJson(json),
      );

      UploadVideoResponseModel? uploadResponse;
      urlResult.fold(
        (fail) {
          DPrint.log('❌ Failed to get upload URL: ${fail.message}');
          throw Exception('Failed to get upload URL: ${fail.message}');
        },
        (success) {
          uploadResponse = success.data;
          DPrint.log('✅ Received upload URL');
        },
      );

      if (uploadResponse == null) {
        throw Exception('Upload URL not received');
      }

      DPrint.log('⬆️  Uploading video to storage...');
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
        DPrint.log('✅ Video uploaded successfully to storage');

        // Confirm video upload completion
        DPrint.log('🔄 Confirming video upload with server...');

        final completeUrl = ApiConstants.elevatorPitchVideo.completeVideoUpload(
          userId,
        );
        final completeData = {
          'fileKey': uploadResponse!.key,
          'fileName': fileName,
          'fileSize': fileSize,
        };

        final completeResult = await apiClient.post(
          completeUrl,
          data: completeData,
          fromJsonT: (json) => json as Map<String, dynamic>,
        );

        bool completeSuccess = false;
        String completeError = '';
        completeResult.fold(
          (fail) {
            DPrint.log(
              '⚠️ Warning: Failed to confirm video completion: ${fail.message}',
            );
            completeError = fail.message;
          },
          (success) {
            DPrint.log('✅ Video completion confirmed successfully');
            completeSuccess = true;
          },
        );

        if (!completeSuccess) {
          throw Exception(completeError);
        }

        uploadedVideoPath.value = videoPath;
        successVideoUploaded.value = true;
        DPrint.log('Upload video success');
        Get.snackbar(
          backgroundColor: Colors.green,
          colorText: Colors.white,
          'Success',
          'Video uploaded successfully',
        );
        Get.back();
      } else {
        throw Exception(
          'Failed to upload video to storage. Status: ${uploadToStorageResponse.statusCode}',
        );
      }
    } catch (e) {
      DPrint.log('Error uploading video: $e');
      Get.snackbar(
        backgroundColor: Colors.red,
        colorText: Colors.white,
        'Failed',
        'Maximum allowed video duration is 60 seconds for your plan',
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteElevatorVideo() async {
    setLoading(true);
    try {
      final userId = await _authStorageService.getUserId();
      if (userId == null || userId.isEmpty) {
        Get.snackbar('Error', 'User ID not found.');
        return;
      }

      final deleteResult = await _recruiterRepo.deleteVideo(userId);
      deleteResult.fold(
        (fail) {
          Get.snackbar('Error', 'Could not delete video: ${fail.message}');
        },
        (_) {
          uploadedVideoPath.value = '';
          successVideoUploaded.value = false;
          Get.snackbar('Success', 'Video deleted successfully');
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> createRecruiterScreen(
    File banner,
    File recruiterLogo,
    String description,
    String firstName,
    String surname,
    String emailAddress,
    String phoneNumber,
    String title,
    String country,
    String city,
    int zipCode,
    String linkedIn,
    String twitter,
    String upwork,
    String facebook,
    String tiktok,
    String instagram,
    String fiverr,
    String company,
  ) async {
    setLoading(true);
    setError('');

    final userId = await _authStorageService
        .getUserId(); // get logged-in userId
    DPrint.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }

    // Build social links list
    List<Map<String, String>> sLinks = [];
    if (linkedIn.isNotEmpty) sLinks.add({"label": "LinkedIn", "url": linkedIn});
    if (twitter.isNotEmpty) sLinks.add({"label": "Twitter", "url": twitter});
    if (upwork.isNotEmpty) sLinks.add({"label": "Upwork", "url": upwork});
    if (facebook.isNotEmpty) sLinks.add({"label": "Facebook", "url": facebook});
    if (tiktok.isNotEmpty) sLinks.add({"label": "TikTok", "url": tiktok});
    if (instagram.isNotEmpty)
      sLinks.add({"label": "Instagram", "url": instagram});
    if (fiverr.isNotEmpty) sLinks.add({"label": "Fiverr", "url": fiverr});
    if (company.isNotEmpty) sLinks.add({"label": "Company", "url": company});

    // Add all text + file fields
    _multiFormDataManager.addImageFile(key: "banner", banner);
    _multiFormDataManager.addImageFile(key: "photo", recruiterLogo);
    _multiFormDataManager.addTextData("firstName", firstName);
    _multiFormDataManager.addTextData("sureName", surname);
    _multiFormDataManager.addTextData("emailAddress", emailAddress);
    _multiFormDataManager.addTextData("phoneNumber", phoneNumber);
    _multiFormDataManager.addTextData("title", title);
    _multiFormDataManager.addTextData("bio", description);
    _multiFormDataManager.addTextData("country", country);
    _multiFormDataManager.addTextData("city", city);
    _multiFormDataManager.addTextData("zipCode", zipCode.toString());

    // Add userId here
    _multiFormDataManager.addTextData("userId", userId);

    // Optionally include companyId if your backend expects it
    if (selectedCompany.value != null) {
      DPrint.log("Recruiter controller -> ${selectedCompany.value}");
      _multiFormDataManager.addTextData(
        "companyId",
        selectedCompany.value.toString(),
      );
    }

    // Add social links
    for (int i = 0; i < sLinks.length; i++) {
      _multiFormDataManager.addTextData(
        "sLink[$i][label]",
        sLinks[i]["label"]!,
      );
      _multiFormDataManager.addTextData("sLink[$i][url]", sLinks[i]["url"]!);
    }

    final formRequest = await _multiFormDataManager.toFormDataAsync();

    print(' Fields: ${formRequest.fields}');
    print(' Files: ${formRequest.files}');

    final result = await _recruiterRepo.createRecruiter(formRequest);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log('Create Recruiter: ${fail.message}');
        setLoading(false); // Fix: Use setLoading instead of isLoading
      },
      (success) async {
        DPrint.log('Create Recruiter: ${success.message}');
        // Fetch the updated profile data before navigating
        await fetchProfile(); // Add this line to refresh userInfo
        Get.offAll(RecruiterPageScreen());
        setLoading(false); // Fix: Use setLoading instead of isLoading
        Get.snackbar('Success', success.message); // Show success message
      },
    );
  }

  Future<void> fetchProfile() async {
    setLoading(true);
    setError("");

    final userId = await _authStorageService.getUserId();
    DPrint.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }

    final result = await _recruiterRepo.fetchRecruiterInfo(userId);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log('data fetch failed: ${fail.message}');
        setLoading(false);
      },
      (success) {
        userInfo.value = success.data;

        setLoading(false);
      },
    );
  }

  Future<void> updateRecruiter(
    File? banner,
    File? recruiterLogo,
    String description,
    String firstName,
    String surname,
    String title,
    String country,
    String city,
    String linkedIn,
    String twitter,
    String upwork,
    String facebook,
    String tiktok,
    String instagram,
    String fiverr,
    String company,
  ) async {
    setLoading(true);
    setError("");

    final userId = await _authStorageService.getUserId();
    DPrint.log('UserId: $userId');

    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }

    _multiFormDataManager.clear();
    // Build social links list
    List<Map<String, String>> sLinks = [];
    if (linkedIn.isNotEmpty) sLinks.add({"label": "LinkedIn", "url": linkedIn});
    if (twitter.isNotEmpty) sLinks.add({"label": "Twitter", "url": twitter});
    if (upwork.isNotEmpty) sLinks.add({"label": "Upwork", "url": upwork});
    if (facebook.isNotEmpty) sLinks.add({"label": "Facebook", "url": facebook});
    if (tiktok.isNotEmpty) sLinks.add({"label": "TikTok", "url": tiktok});
    if (instagram.isNotEmpty) {
      sLinks.add({"label": "Instagram", "url": instagram});
    }
    if (fiverr.isNotEmpty) {
      sLinks.add({"label": "Fiverr", "url": fiverr});
    }
    if (company.isNotEmpty) {
      sLinks.add({"label": "Company", "url": company});
    }

    // Add images only if selected
    if (banner != null) {
      _multiFormDataManager.addImageFile(key: "banner", banner);
    }

    if (recruiterLogo != null) {
      _multiFormDataManager.addImageFile(key: "photo", recruiterLogo);
    }

    // Add text fields
    _multiFormDataManager.addTextData("firstName", firstName);
    _multiFormDataManager.addTextData("sureName", surname);
    _multiFormDataManager.addTextData("title", title);
    _multiFormDataManager.addTextData("bio", description);
    _multiFormDataManager.addTextData("country", country);
    _multiFormDataManager.addTextData("city", city);
    _multiFormDataManager.addTextData("userId", userId);

    // Add company ID (dropdown)
    if (selectedCompany.value != null) {
      DPrint.log("Recruiter controller -> ${selectedCompany.value}");
      _multiFormDataManager.addTextData(
        "companyId",
        selectedCompany.value.toString(),
      );
    }

    // Add social links as array
    for (int i = 0; i < sLinks.length; i++) {
      _multiFormDataManager.addTextData(
        "sLink[$i][label]",
        sLinks[i]["label"]!,
      );
      _multiFormDataManager.addTextData("sLink[$i][url]", sLinks[i]["url"]!);
    }

    final formRequest = await _multiFormDataManager.toFormDataAsync();

    final result = await _recruiterRepo.updateRecruiter(userId, formRequest);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log('Update Recruiter: ${fail.message}');
        setLoading(false);
      },
      (success) async {
        DPrint.log('Update Recruiter: ${success.message}');
        await fetchProfile(); // refresh profile
        Get.to(() => RecruiterPageScreen());
        setLoading(false);
        Get.snackbar('Success', success.message);
      },
    );
  }

  Future<void> fetchArchiveJobs() async {
    try {
      isLoading.value = true;
      //final jobs = await _repo.getArchivedJobs();
      //archiveJobs.assignAll(jobs);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final request = UpdatePasswordRequestModel(
      newPassword: newPassword,
      currentPassword: oldPassword,
    );
    final result = await _recruiterRepo.changePass(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("change pass success result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("change pass success result : ${success.message}");
        Get.to(() => RecruiterPageScreen());
        setLoading(false);
      },
    );
  }

  Future<void> recruiterPublicView(String slug) async {
    setLoading(true);
    setError("");

    final result = await _recruiterRepo.recruiterPublicView(slug);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log('data fetch failed: ${fail.message}');
        setLoading(false);
      },
      (success) {
        DPrint.log('data fetch successfully: ${success.message}');
        publicView.value = success.data;
        publicView.refresh();
        setLoading(false);
      },
    );
  }

  void viewJobDetails(String id) {
    // navigate to details page
  }

  void copyJobLink(String id) {
    // implement clipboard copy
  }

  void unarchiveJob(String id) async {
    // call API to remove from archive, then refresh
    //await _recruiterRepo.unarchiveJob(id);
    fetchArchiveJobs();
  }

  Future<void> logout() async {
    await _authStorageService.clearAuthData();
    final secureStore = SecureStoreServices();
    await secureStore.deleteData('email');
    await secureStore.deleteData('password');

    Get.offAll(() => LoginScreen());
  }
}
