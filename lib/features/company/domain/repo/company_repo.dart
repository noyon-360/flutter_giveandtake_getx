import 'package:dio/dio.dart';

import '../../../../core/network/network_result.dart';
import '../../data/model/all_user_response_model.dart';
import '../../data/model/archieve_request_model.dart';
import '../../data/model/archieve_response_model.dart';
import '../../data/model/candidate_resume_response_model.dart';
import '../../data/model/company_applicant_list_response_model.dart';
import '../../data/model/company_response_model.dart';
import '../../data/model/employee_fetch_single_model.dart';
import '../../data/model/manage_job_response_model.dart';
import '../../data/model/rec_company_response_model.dart';
import '../../data/model/recruiter_added_request_model.dart';
import '../../data/model/recruiter_added_response_model.dart';
import '../../data/model/remove_recruiter_request_model.dart';
import '../../data/model/remove_recruiter_response_model.dart';
import '../../data/model/resume_updated_response_model.dart';
import '../../data/model/single_Company_response_model.dart';
import '../../data/model/status_update_response_model.dart';
import '../../data/model/update_company_response_model.dart';

abstract class CompanyRepository {
  NetworkResult<List<AllUserResponseModel>> fetchAllUsers();
  NetworkResult<CompanyResponseModel> createCompany(FormData formData);
  NetworkResult<SingleCompanyResponseModel> fetchCompanyInfo(String userId);
  NetworkResult<UpdateCompanyResponseModel> updateCompanyInfo(
    String userId,
    FormData formData,
  );
  NetworkResult<List<ManageJobResponseModel>> fetchManageJobs(String companyId);
  NetworkResult<RecruiterAddedResponseModel> connectRecruiter(
    RecruiterAddedRequestModel request,
  );

  NetworkResult<EmployeeFetchSingleModel> fetchEmployee(String userId);
  NetworkResult<RemoveRecruiterResponseModel> removeRecruiter(
    RemoveRecruiterRequestModel request,
  );
  NetworkResult<ArchieveResponseModel> archiveJobs(
    String jobId,
    Map<String, dynamic> data,
  );
  NetworkResult<List<ApplicantListResponseModel>> applicantJob(String jobId);
  NetworkResult<CandidateResumeResponseModel> fetchCandidateInfo();
  NetworkResult<StatusUpdateResponseModel> status(
    String jobId,
    Map<String, dynamic> data,
  );
  NetworkResult<List<ResumeUpdatedResponseModel>> fetchResume(String userId);
  NetworkResult<RecCompanyResponseModel> updateRecCompany(
    String recId,
    Map<String, dynamic> data,
  );
}
