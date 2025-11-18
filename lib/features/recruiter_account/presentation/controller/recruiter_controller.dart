import 'dart:developer' as DPrint;
import 'dart:io';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:dio/dio.dart';
import 'package:karlfive/core/network/services/auth_storage_service.dart';
import 'package:karlfive/features/recruiter_account/data/models/connect_company_request_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/follow_request_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/get_category_response_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/get_company_response_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/get_currency_response_model.dart';
import 'package:karlfive/features/recruiter_account/domain/repo/repo.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/upload_elevator_pitch.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/create_recruiter_account.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/recruiter_page.dart';
import '../../../../core/base/base_controller.dart';
import '../../../../core/network/services/multiple_form_data_manager.dart';
import '../../../../core/network/services/secure_store_services.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../data/models/get_job_response_model.dart' hide ApplicationRequirement, CustomQuestion;
import '../../data/models/get_recruiter_response_model.dart';
import '../../data/models/job_create_request_model.dart';
import '../models/job_model.dart';
import 'package:http_parser/http_parser.dart';

class RecruiterController extends BaseController {
  final AuthStorageService _authStorageService;

  final Repo _recruiterRepo;
  var isSkipLoading = false.obs;
  var isContinueLoading = false.obs;

  final companies = <GetCompanyResponseModel>[].obs;
  RxString? companySearchQuery;

  final category = <Category>[].obs;
  final currency = <GetCurrencyResponseModel>[].obs;

  // final selectedCompany = Rxn<GetCompanyResponseModel>();
  final selectedCompany = RxnString();

  final yourJobList = <YourJobResponseModel>[].obs;


  var archiveJobs = <JobModel>[].obs;

  final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();

  RecruiterController(this._recruiterRepo, this._authStorageService);

  final Rxn<FetchRecruiterResponseModel> userInfo =
      Rxn<FetchRecruiterResponseModel>();

  final RxString uploadedVideoPath = ''.obs;
  final RxBool successVideoUploaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCompany(); //Fetch when controller is created
    fetchProfile();
    fetchCategory();
    fetchCurrency();
    getJob();
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
    );

    final result = await _recruiterRepo.createNewJobPost(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("create job success result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("create job success result : ${success.message}");
        Get.offAll(() => RecruiterPageScreen());
        setLoading(false);
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

  Future getJob() async {
    setLoading(true);
    setError("");

    final result = await _recruiterRepo.yourJob();

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log("your job fetch failed result : ${fail.message}");
        setLoading(false);
      },
          (success) {
        DPrint.log("your job fetch success result : ${success.message}");
        yourJobList.value = success.data;
        setLoading(false);
      },
    );
  }




  Future follow(final String recruiterId,
  final String userId) async {
    setLoading(true);
    setError("");

    final request = FollowRequestModel(recruiterId: recruiterId, userId: userId);
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
          Get.snackbar(
            'Error',
            'Could not delete previous video: ${fail.message}',
          );
          setLoading(false);
          return;
        },
        (_) {
          DPrint.log('Existing video deleted successfully');
          uploadedVideoPath.value = '';
          successVideoUploaded.value = false;
        },
      );

      //Upload new video
      final formData = FormData.fromMap({
        "videoFile": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
          contentType: MediaType('video', 'mp4'),
        ),
      });

      final uploadResult = await _recruiterRepo.uploadVideo(userId, formData);

      uploadResult.fold(
        (fail) {
          setError(fail.message);
          DPrint.log('Upload video failed: ${fail.message}');
          Get.snackbar('Error', fail.message);
        },
        (success) {
          uploadedVideoPath.value = videoPath;
          successVideoUploaded.value = true;
          DPrint.log('Upload video success: ${success.message}');
          Get.snackbar('Success', success.message);
          Get.to(() => CreateRecruiterAccount());
        },
      );
    } catch (e) {
      DPrint.log('Error uploading video: $e');
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
    if (instagram.isNotEmpty) {
      sLinks.add({"label": "Instagram", "url": instagram});
    }

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
