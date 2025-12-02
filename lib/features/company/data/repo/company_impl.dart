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

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/repo/company_repo.dart';
import '../model/all_user_response_model.dart';

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
}