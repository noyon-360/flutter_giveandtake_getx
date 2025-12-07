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
import 'package:karlfive/features/company/data/model/single_Company_response_model.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/repo/company_repo.dart';
import '../model/all_user_response_model.dart';
import '../model/company_response_model.dart';
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
  NetworkResult<CompanyResponseModel> createCompany(
    FormData formData,
  ) {
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
  NetworkResult<UpdateCompanyResponseModel> updateCompanyInfo(String userId,FormData formData,) {
    return _apiClient.put(
      ApiConstants.company.fetchUpdateInfo(userId),
      formData: formData,
      fromJsonT: (json) =>
          UpdateCompanyResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}