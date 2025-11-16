import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutx_core/core/debug_print.dart';
import 'package:karlfive/core/network/network_result.dart';

import 'package:karlfive/features/recruiter_account/data/models/get_company_response_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/get_job_response_model.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../domain/repo/repo.dart';
import '../models/connect_company_request_model.dart';
import '../models/connect_company_response_model.dart';
import '../models/create_recruiter_response_model.dart';
import '../models/follow_request_model.dart';
import '../models/follow_response_model.dart';
import '../models/get_category_response_model.dart';
import '../models/get_currency_response_model.dart';
import '../models/get_recruiter_response_model.dart';
import '../models/job_create_request_model.dart';
import '../models/job_create_response_model.dart';
import '../models/update_recruiter_response_model.dart';
import '../models/your_job_response_model.dart';

class RepoImplementation extends Repo {
  final ApiClient _apiClient;

  RepoImplementation({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<List<GetCompanyResponseModel>> fetchCompany() {
    return _apiClient.get(
      ApiConstants.recruiter.getCompany,
      fromJsonT: (json) => companyListFromJson(json as List<dynamic>),
    );
  }

  @override
  NetworkResult<GetCategoryResponseModel> fetchCategory() {
    return _apiClient.get(
      ApiConstants.recruiter.getCategory,
      fromJsonT: (json) => GetCategoryResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<List<GetCurrencyResponseModel>> fetchCurrency() {
    return _apiClient.get(
      ApiConstants.recruiter.getCurrency,
      fromJsonT: (json) {
        // Ensure json is a List
        final List<dynamic> jsonList = json as List<dynamic>;
        return jsonList
            .map(
              (item) => GetCurrencyResponseModel.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();
      },
    );
  }

  @override
  NetworkResult<List<JobPostResponseModel>> createNewJobPost(
    JobPostRequestModel request,
  ) {
    return _apiClient.post(
      ApiConstants.recruiter.createJob,
      data: request.toJson(),
      fromJsonT: (json) {
        // Check if API returns a list or single object
        if (json is List) {
          return json
              .map(
                (e) => JobPostResponseModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        } else if (json is Map<String, dynamic>) {
          // Sometimes API returns a single object
          return [JobPostResponseModel.fromJson(json)];
        } else {
          return <JobPostResponseModel>[];
        }
      },
    );
  }

  @override
  NetworkResult<void> uploadVideo(String userId, FormData formData) {
    return _apiClient.post(
      ApiConstants.elevatorPitchVideo.uploadVideo(userId),
      formData: formData,
      fromJsonT: (json) => [],
    );
  }

  @override
  NetworkResult<void> deleteVideo(String userId) {
    return _apiClient.delete(
      ApiConstants.elevatorPitchVideo.uploadVideo(userId),
      fromJsonT: (json) => [],
    );
  }

  @override
  NetworkResult<ConnectCompanyResponse> connectCompany(
    ConnectCompanyRequest request,
  ) {
    return _apiClient.post(
      ApiConstants.recruiter.connectCompany,
      data: request.toJson(),
      fromJsonT: (json) => ConnectCompanyResponse.fromJson(json),
    );
  }

  @override
  NetworkResult<List<YourJobResponseModel>> yourJob() {
    return _apiClient.get(ApiConstants.recruiter.getJob,
        fromJsonT: (json) => (json as List).map((item) => YourJobResponseModel.fromJson(item)).toList());
  }

  @override
  NetworkResult<FollowResponseModel> follow(FollowRequestModel request) {
    return _apiClient.post(
      ApiConstants.recruiter.follow,
      data: request.toJson(),
      fromJsonT: (json) => FollowResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<CreateRecruiterResponseModel> createRecruiter(
    FormData formData,
  ) {
    return _apiClient.post(
      ApiConstants.recruiter.createRecruiterAccount,
      formData: formData,
      fromJsonT: (json) => CreateRecruiterResponseModel.fromJson(json),
      isFormData: true,
    );
  }

  @override
  NetworkResult<FetchRecruiterResponseModel> fetchRecruiterInfo(String userId) {
    return _apiClient.get(
      ApiConstants.recruiter.fetchRecruiterInfo(userId),
      fromJsonT: (json) =>
          FetchRecruiterResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<UpdateRecruiterResponseModel> updateRecruiter(
    String userId,
    FormData formData,
  ) {
    DPrint.log("Repo Impl : ${formData.toString()}");
    return _apiClient.patch(
      ApiConstants.recruiter.updateRecruiter(userId),
      formData: formData,
      fromJsonT: (json) => UpdateRecruiterResponseModel.fromJson(json),
      isFormData: true,
    );
  }
}
