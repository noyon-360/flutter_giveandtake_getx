import 'package:dio/dio.dart';
import 'package:karlfive/features/recruiter_account/data/models/connect_company_request_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/connect_company_response_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/create_recruiter_response_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/follow_request_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/follow_response_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/get_currency_response_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/get_job_response_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/get_single_job_response_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/job_create_request_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/job_create_response_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/job_update_request_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/job_update_response_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/your_job_response_model.dart';
import '../../../../core/network/network_result.dart';
import '../../data/models/current_password_update_request_model.dart';
import '../../data/models/get_category_response_model.dart';
import '../../data/models/get_company_response_model.dart';
import '../../data/models/get_recruiter_response_model.dart';
import '../../data/models/update_recruiter_response_model.dart';

abstract class Repo{
  NetworkResult<List<GetCompanyResponseModel>> fetchCompany();
  NetworkResult<GetCategoryResponseModel> fetchCategory();
  NetworkResult<ConnectCompanyResponse> connectCompany(ConnectCompanyRequest request);
  NetworkResult<FollowResponseModel> follow(FollowRequestModel request);
  NetworkResult<List<YourJobResponseModel>>yourJob();
  NetworkResult<GetSingleJobResponseModel>singleJob(String jobId);
  NetworkResult<JobUpdateResponseModel>singleJobUpdate(UpdateJobRequest request, String jobId);
  NetworkResult<List<GetCurrencyResponseModel>> fetchCurrency();
  NetworkResult<List<JobPostResponseModel>> createNewJobPost(JobPostRequestModel request);
  NetworkResult<void> uploadVideo(String userId, FormData formData);
  NetworkResult<void> deleteVideo(String userId);
  NetworkResult<CreateRecruiterResponseModel> createRecruiter(FormData formData);
  NetworkResult<FetchRecruiterResponseModel> fetchRecruiterInfo(String userId);
  NetworkResult<UpdateRecruiterResponseModel> updateRecruiter(String userId, FormData formData);
  NetworkResult<void> changePass(UpdatePasswordRequestModel request);
}