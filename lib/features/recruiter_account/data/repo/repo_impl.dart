import 'package:dio/dio.dart';
import 'package:flutx_core/core/debug_print.dart';
import 'package:karlfive/core/network/network_result.dart';

import 'package:karlfive/features/recruiter_account/data/models/get_company_response_model.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../domain/repo/repo.dart';
import '../models/create_recruiter_response_model.dart';
import '../models/get_recruiter_response_model.dart';
import '../models/update_recruiter_response_model.dart';

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
  NetworkResult<UpdateRecruiterResponseModel> updateRecruiter(String userId, FormData formData){
    DPrint.log("Repo Impl : ${formData.toString()}");
    return _apiClient.patch(
      ApiConstants.recruiter.updateRecruiter(userId),
      formData: formData,
      fromJsonT: (json) => UpdateRecruiterResponseModel.fromJson(json),
      isFormData: true
    );
  }
}
