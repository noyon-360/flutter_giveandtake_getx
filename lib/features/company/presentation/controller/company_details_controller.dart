import 'package:flutter/material.dart';
import 'package:flutx_core/core/debug_print.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';
import 'package:karlfive/features/company/data/model/archieve_request_model.dart';
import 'package:karlfive/features/company/data/model/archieve_response_model.dart';
import 'package:karlfive/features/company/data/model/candidate_resume_response_model.dart';
import 'package:karlfive/features/company/data/model/company_applicant_list_response_model.dart';
import 'package:karlfive/features/company/data/model/employee_fetch_single_model.dart';
import 'package:karlfive/features/company/data/model/remove_recruiter_request_model.dart';
import 'package:karlfive/features/company/data/model/remove_recruiter_response_model.dart';
import 'package:karlfive/features/company/data/model/resume_updated_response_model.dart';
import 'package:karlfive/features/company/data/model/status_update_response_model.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../data/model/all_user_response_model.dart';
import '../../data/model/company_details_model.dart';
import '../../data/model/rec_company_request_model.dart';
import '../../data/model/single_Company_response_model.dart';
import '../../domain/repo/company_repo.dart';
import '../screen/company_details_screen.dart';
import 'company_account_controller.dart';

class CompanyDetailsController extends BaseController {
  final CompanyRepository _companyRepo;
  final AuthStorageService _authStorageService;

  CompanyDetailsController(this._companyRepo, this._authStorageService);

  // Change from Rxn (problematic) to Rx with explicit null
  final userInfo = Rx<SingleCompanyResponseModel?>(null);
  final employee = Rx<EmployeeFetchSingleModel?>(null);
  var resume = <ResumeUpdatedResponseModel>[].obs;
  final remove = Rx<RemoveRecruiterResponseModel?>(
    null,
  ); // <AllUserResponseModel>
  var recruiters = <AllUserResponseModel>[].obs;

  Rx<ArchieveResponseModel?> jobData = Rx<ArchieveResponseModel?>(null);

  Rx<StatusUpdateResponseModel?> status = Rx<StatusUpdateResponseModel?>(null);

  // final Rx<ApplicantListResponseModel?> venue = Rx<ApplicantListResponseModel?>(
  //   null,
  // );

  var venue = <ApplicantListResponseModel>[].obs;

  var jobId = ''.obs;

  var isCompanyLoading = true.obs;
  var isEmployeeLoading = true.obs;
  final Rx<CandidateResumeResponseModel?> candidate = Rx(null);

  Future<void> fetchCompanyProfile() async {
    setLoading(true);
    // isCompanyLoading.value = true;
    setError("");

    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      // isCompanyLoading.value = false;
      return;
    }

    final result = await _companyRepo.fetchCompanyInfo(userId);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log('data fetch failed: ${fail.message}');
        setLoading(false);
        // isCompanyLoading.value = false;
      },
      (success) {
        // success is NetworkSuccess<SingleCompanyResponseModel>
        // → extract the actual model using .data
        userInfo.value = success.data;
        userInfo.refresh(); // ← THIS IS THE CORRECT WAY

        DPrint.log("Loaded ${success.data.companies.length} companies");
        DPrint.log("Loaded ${success.data.honors.length} honors");
        setLoading(false);
        // isCompanyLoading.value = false;
      },
    );
  }

  Future<void> fetchEmployee() async {
    setLoading(true);
    // isEmployeeLoading.value = true;
    setError("");

    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      // isEmployeeLoading.value = false;
      return;
    }

    final result = await _companyRepo.fetchEmployee(userId);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log('data fetch failed: ${fail.message}');
        setLoading(false);
        // isEmployeeLoading.value = false;
      },
      (success) {
        DPrint.log('data fetch successfully: ${success.message}');
        // success is NetworkSuccess<SingleCompanyResponseModel>
        // → extract the actual model using .data
        employee.value = success.data;
        employee.refresh(); // ← THIS IS THE CORRECT WAY

        setLoading(false);
        // isEmployeeLoading.value = false;
      },
    );
  }

  Future<void> removeRecruiter(String employeeId) async {
    setLoading(true);
    setError("");

    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      setError('User not authenticated');
      Get.snackbar('Error', 'User not authenticated');
      setLoading(false);
      return;
    }

    final request = RemoveRecruiterRequestModel(
      companyId: userId,
      employeeId: employeeId,
    );

    final result = await _companyRepo.removeRecruiter(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("Remove recruiter failed: ${fail.message}");
        Get.snackbar(
          "Error",
          fail.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        setLoading(false);
      },
      (success) async {
        DPrint.log("Remove recruiter success: ${success.message}");

        // Option 1: Refresh the employee list
        await fetchEmployee(); // reloads employee list after deletion

        setLoading(false);
      },
    );
  }

  //  Future<void> archiveJobs(
  //     String jobId,
  //     // <-- just a list of task IDs
  //   ) async {
  //    setLoading(true);
  //    setError("");
  //         final userId = await _authStorageService.getUserId();
  //   if (userId == null || userId.isEmpty) {
  //     setError('User not authenticated');
  //     Get.snackbar('Error', 'User not authenticated');
  //     setLoading(false);
  //     return;
  //   }

  //     final data = {
  //       "userId": userId,
  //       "jobId": jobId, // send list of ObjectId strings
  //     };

  //     final result = await _companyRepo.archiveJobs(jobId, data);

  //     result.fold(
  //       (fail) {
  //         setError(fail.message);
  //         DPrint.log('❌ Client info update failed: ${fail.message}');
  //         isLoading(false);
  //       },
  //       (success) async {
  //         DPrint.log('✅ Client info updated: ${success.message}');

  //         Get.back(); // navigate back after success
  //         isLoading(false);
  //       },
  //     );
  //   }
  Future<void> archiveJobs(String jobId) async {
    setLoading(true);
    setError("");

    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      setError('User not authenticated');
      Get.snackbar('Error', 'User not authenticated');
      setLoading(false);
      return;
    }

    final data = {"userId": userId, "jobId": jobId};

    final result = await _companyRepo.archiveJobs(jobId, data);

    result.fold(
      (fail) {
        setError(fail.message);
        Get.snackbar(
          "Error",
          fail.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      (success) {
        // Update the reactive job data
        jobData.value = success.data;

        // Show success message based on new state
        Get.snackbar(
          "Success",
          success.data.arcrivedJob ? "Job archived" : "Job unarchived",
          backgroundColor: success.data.arcrivedJob
              ? Colors.orange
              : Colors.green,
          colorText: Colors.white,
        );

        // Optional: Refresh the full list to reflect changes everywhere
        Get.find<CompanyAccountController>().manageJobs();
      },
    );

    setLoading(false); // Always stop loading
  }

  Future<void> fetchApplicantList() async {
    if (jobId.isEmpty) return;
    setLoading(true);
    final result = await _companyRepo.applicantJob(jobId.value);

    result.fold(
      (fail) {
        setLoading(false);
      },
      (success) {
        venue.value = success.data;
        setLoading(false);
      },
    );
  }

  Future<void> fetchCandidate() async {
    setLoading(true);

    final result = await _companyRepo.fetchCandidateInfo();

    result.fold(
      (fail) {
        setError(fail.message);
        setLoading(false);
      },
      (success) {
        candidate.value = success.data;

        setLoading(false);
      },
    );
  }

  Future<void> statusUpdated({
    required String applicantId,
    required String status,
  }) async {
    setLoading(true);
    setError("");

    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      setError('User not authenticated');
      Get.snackbar('Error', 'User not authenticated');
      setLoading(false);
      return;
    }

    final data = {
      "userId": userId,
      "applicantId": applicantId,
      "status": status,
    };

    final result = await _companyRepo.status(applicantId, data);

    result.fold(
      (fail) {
        setError(fail.message);
        Get.snackbar(
          "Error",
          fail.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        setLoading(false);
      },
      (success) {
        Get.snackbar(
          "Success",
          "Status updated to $status",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Refresh the applicant list to reflect new status
        fetchApplicantList();
      },
    );
  }

  Future<void> fetchResume(String candidateUserId) async {
    setLoading(true);
    setError("");

    if (candidateUserId.isEmpty) {
      setError('Invalid candidate ID');
      setLoading(false);
      return;
    }

    final result = await _companyRepo.fetchResume(candidateUserId);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log('data fetch failed: ${fail.message}');
        setLoading(false);
      },
      (success) {
        DPrint.log('data fetch successfully: ${success.message}');
        resume.value = success.data;
        setLoading(false);
      },
    );
  }

  // In CompanyDetailsController

  Future<void> updateRecCompany({
    required String id, // request document _id (recId) → goes in URL
    required String
    recruiterUserId, // ← THIS IS CRITICAL: the user who requested
    required String companyId, // company _id
    required String status, // 'accepted' or 'rejected'
  }) async {
    setLoading(true);
    setError("");

    // We do NOT use the currently logged-in user here
    // We use the recruiterUserId passed from the UI (the applicant)

    final data = RecCompanyRequestModel(
      status: status,
      companyId: companyId,
      userId: recruiterUserId, // ← the recruiter who wants to join
    ).toJson();

    final result = await _companyRepo.updateRecCompany(id, data);

    result.fold(
      (fail) {
        setError(fail.message);
        Get.snackbar(
          "Error",
          fail.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      (success) {
        Get.snackbar(
          "Success",
          "Request $status successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Refresh the lists
        fetchEmployee(); // This will now show the correct recruiter
        // If requests are part of the same fetch, it will update too
      },
    );

    setLoading(false);
  }
}
