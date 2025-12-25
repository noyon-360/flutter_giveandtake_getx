// import '../../../../core/network/api_client.dart';
// import '../../../../core/network/constants/api_constants.dart';
// import '../../../../core/network/network_result.dart';
// import '../../domain/repo/company_repo.dart';
// import '../model/all_user_response_model.dart';

// class CompanyRepoImplementation extends CompanyRepository {
//   final ApiClient _apiClient;

//   CompanyRepoImplementation({required ApiClient apiClient})
//     : _apiClient = apiClient;

//  @override
//   NetworkResult<List<AllUserResponseModel>> fetchUser() {
//     return _apiClient.get(
//       ApiConstants.allusers.alluser,
//       fromJsonT: (json) =>
//           (json as List).map((e) => AllUserResponseModel.fromJson(e)).toList(),
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:karlfive/features/company/data/model/archieve_request_model.dart';
import 'package:karlfive/features/company/data/model/archieve_response_model.dart';
import 'package:karlfive/features/company/data/model/candidate_resume_response_model.dart';
import 'package:karlfive/features/company/data/model/company_applicant_list_response_model.dart';
import 'package:karlfive/features/company/data/model/manage_job_response_model.dart';
import 'package:karlfive/features/company/data/model/rec_company_response_model.dart';
import 'package:karlfive/features/company/data/model/recruiter_added_request_model.dart';
import 'package:karlfive/features/company/data/model/recruiter_added_response_model.dart';
import 'package:karlfive/features/company/data/model/remove_recruiter_request_model.dart';
import 'package:karlfive/features/company/data/model/remove_recruiter_response_model.dart';
import 'package:karlfive/features/company/data/model/resume_updated_response_model.dart';
import 'package:karlfive/features/company/data/model/single_Company_response_model.dart';
import 'package:karlfive/features/company/data/model/status_update_response_model.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/repo/company_repo.dart';
import '../model/all_user_response_model.dart';
import '../model/company_response_model.dart';
import '../model/employee_fetch_single_model.dart';
import '../model/update_company_response_model.dart';

class CompanyRepoImplementation extends CompanyRepository {
  final ApiClient _apiClient;

  CompanyRepoImplementation({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  NetworkResult<List<AllUserResponseModel>> fetchAllUsers() async {
    return _apiClient.get(
      ApiConstants.allusers.alluser, // → /api/v1/all/users
      fromJsonT: (json) {
        // Critical Fix: Extract 'data' array from response
        if (json is Map<String, dynamic> && json.containsKey('data')) {
          final List<dynamic> dataList = json['data'];
          return dataList
              .map((item) => AllUserResponseModel.fromJson(item))
              .toList();
        } else {
          // Fallback: if backend sends raw list (unlikely)
          return (json as List)
              .map((item) => AllUserResponseModel.fromJson(item))
              .toList();
        }
      },
    );
  }

  @override
  NetworkResult<CompanyResponseModel> createCompany(FormData formData) {
    return _apiClient.post(
      ApiConstants.company.createcompany,
      formData: formData,
      fromJsonT: (json) => CompanyResponseModel.fromJson(json),
      isFormData: true,
    );
  }

  @override
  NetworkResult<SingleCompanyResponseModel> fetchCompanyInfo(String userId) {
    return _apiClient.get(
      ApiConstants.company.fetchCompanyInfo(userId),
      fromJsonT: (json) =>
          SingleCompanyResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<EmployeeFetchSingleModel> fetchEmployee(String userId) {
    return _apiClient.get(
      ApiConstants.company.fetchEmployee(userId),
      fromJsonT: (json) =>
          EmployeeFetchSingleModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<UpdateCompanyResponseModel> updateCompanyInfo(
    String userId,
    FormData formData,
  ) {
    return _apiClient.put(
      ApiConstants.company.fetchUpdateInfo(userId),
      formData: formData,
      fromJsonT: (json) =>
          UpdateCompanyResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<List<ManageJobResponseModel>> fetchManageJobs(
    String companyId,
  ) {
    return _apiClient.get(
      ApiConstants.company.manageJobs(companyId),
      fromJsonT: (json) {
        // Critical Fix: Extract 'data' array from response
        if (json is Map<String, dynamic> && json.containsKey('data')) {
          final List<dynamic> dataList = json['data'];
          return dataList
              .map((item) => ManageJobResponseModel.fromJson(item))
              .toList();
        } else {
          // Fallback: if backend sends raw list (unlikely)
          return (json as List)
              .map((item) => ManageJobResponseModel.fromJson(item))
              .toList();
        }
      },
    );
  }

  @override
  NetworkResult<RecruiterAddedResponseModel> connectRecruiter(
    RecruiterAddedRequestModel request,
  ) {
    return _apiClient.patch(
      ApiConstants.company.connectRecruiter,
      data: request.toJson(),
      fromJsonT: (json) => RecruiterAddedResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<RemoveRecruiterResponseModel> removeRecruiter(
    RemoveRecruiterRequestModel request,
  ) {
    return _apiClient.patch(
      ApiConstants.company.removeRecruiter,
      data: request.toJson(),
      fromJsonT: (json) => RemoveRecruiterResponseModel.fromJson(json),
    );
  }

  //  @override
  // NetworkResult<ArchieveResponseModel> archiveJobs(
  //   String jobId,
  //   ArchieveRequestModel request,
  // ) {
  //   return _apiClient.patch(
  //     ApiConstants.company.archiveJobs(jobId),
  //     data: request.toJson(),
  //     fromJsonT: (json) => ArchieveResponseModel.fromJson(json),
  //   );
  // }

  @override
  NetworkResult<ArchieveResponseModel> archiveJobs(
    String jobId,
    Map<String, dynamic> data,
  ) {
    return _apiClient.patch(
      ApiConstants.company.archiveJobs(jobId),
      data: data, // send as JSON
      fromJsonT: (json) => ArchieveResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<List<ApplicantListResponseModel>> applicantJob(
    String jobId,
  ) async {
    return _apiClient.get(
      ApiConstants.company.applicantJob(jobId), // → /api/v1/all/users
      fromJsonT: (json) {
        // Critical Fix: Extract 'data' array from response
        if (json is Map<String, dynamic> && json.containsKey('data')) {
          final List<dynamic> dataList = json['data'];
          return dataList
              .map((item) => ApplicantListResponseModel.fromJson(item))
              .toList();
        } else {
          // Fallback: if backend sends raw list (unlikely)
          return (json as List)
              .map((item) => ApplicantListResponseModel.fromJson(item))
              .toList();
        }
      },
    );
  }

  @override
  NetworkResult<CandidateResumeResponseModel> fetchCandidateInfo() {
    return _apiClient.get(
      ApiConstants.company.candidateResume,
      fromJsonT: (json) =>
          CandidateResumeResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<StatusUpdateResponseModel> status(
    String jobId,
    Map<String, dynamic> data,
  ) {
    return _apiClient.patch(
      ApiConstants.company.status(jobId),
      data: data, // send as JSON
      fromJsonT: (json) => StatusUpdateResponseModel.fromJson(json),
    );
  }

   @override
  NetworkResult<List<ResumeUpdatedResponseModel>> fetchResume(
    String candidateUserId,
  ) {
    return _apiClient.get(
      ApiConstants.company.fetchResume(candidateUserId),
      fromJsonT: (json) {
        // Critical Fix: Extract 'data' array from response
        if (json is Map<String, dynamic> && json.containsKey('data')) {
          final List<dynamic> dataList = json['data'];
          return dataList
              .map((item) => ResumeUpdatedResponseModel.fromJson(item))
              .toList();
        } else {
          // Fallback: if backend sends raw list (unlikely)
          return (json as List)
              .map((item) => ResumeUpdatedResponseModel.fromJson(item))
              .toList();
        }
      },
    );
  }

    @override
  NetworkResult<RecCompanyResponseModel> updateRecCompany(
    String recId,
    Map<String, dynamic> data,
  ) {
    return _apiClient.patch(
      ApiConstants.company.updateRecCompany(recId),
      data: data, // send as JSON
      fromJsonT: (json) => RecCompanyResponseModel.fromJson(json),
    );
  }
}
