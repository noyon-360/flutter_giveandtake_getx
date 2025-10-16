import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/repo/user_profile_repository.dart';
import '../models/user_profile_model.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final ApiClient _apiClient;

  UserProfileRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  NetworkResult<UserProfileModel> getUserProfile() async {
    return await _apiClient.get<UserProfileModel>(
      '${ApiConstants.baseUrl}/user/single',
      fromJsonT: (json) =>
          UserProfileModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
