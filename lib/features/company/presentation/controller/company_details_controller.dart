import 'package:flutter/material.dart';
import 'package:flutx_core/core/debug_print.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';
import 'package:karlfive/features/company/data/model/employee_fetch_single_model.dart';
import 'package:karlfive/features/company/data/model/remove_recruiter_request_model.dart';
import 'package:karlfive/features/company/data/model/remove_recruiter_response_model.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../data/model/all_user_response_model.dart';
import '../../data/model/company_details_model.dart';
import '../../data/model/single_Company_response_model.dart';
import '../../domain/repo/company_repo.dart';
import '../screen/company_details_screen.dart';

class CompanyDetailsController extends BaseController {
  final CompanyRepository _companyRepo;
  final AuthStorageService _authStorageService;

  CompanyDetailsController(this._companyRepo, this._authStorageService);

  // Change from Rxn (problematic) to Rx with explicit null
  final userInfo = Rx<SingleCompanyResponseModel?>(null);
  final employee = Rx<EmployeeFetchSingleModel?>(
    null,
  );
  final remove = Rx<RemoveRecruiterResponseModel?>(
    null,
  );  // <AllUserResponseModel>
  var recruiters = <AllUserResponseModel>[].obs;

  var isCompanyLoading = true.obs;
  var isEmployeeLoading = true.obs;



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
      Get.snackbar("Error", fail.message,
          backgroundColor: Colors.red, colorText: Colors.white);
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

}
