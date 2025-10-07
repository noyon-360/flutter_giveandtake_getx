import 'package:karlfive/core/network/network_result.dart';

import 'package:karlfive/features/recruiter_account/data/models/get_company_response_model.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../domain/repo/repo.dart';

class RepoImplementation extends Repo{
  final ApiClient _apiClient;

  RepoImplementation({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<List<GetCompanyResponseModel>> fetchCompany() {
    return _apiClient.get(
      ApiConstants.recruiter.getCompany,
      fromJsonT: (json) => companyListFromJson(json as List<dynamic>),
    );
  }
}