import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../data/models/change_password_request_model.dart';
import '../../domain/repo/change_password_repo.dart';

class ChangePasswordRepoImpl implements ChangePasswordRepo {
  final ApiClient _apiClient;

  ChangePasswordRepoImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  @override
  NetworkResult<void> changePassword(ChangePasswordRequestModel request) {
    return _apiClient.post<void>(
      ApiConstants.auth.changePassword,
      data: request.toJson(),
      fromJsonT: (json) => null,
    );
  }
}
