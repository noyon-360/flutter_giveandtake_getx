import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../data/models/applied_jobs_response_model.dart';
import '../../domain/repo/applied_jobs_repo.dart';

class AppliedJobsRepoImpl implements AppliedJobsRepo {
  final ApiClient _apiClient;

  AppliedJobsRepoImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<AppliedJobsResponseModel> fetchUserApplications({required String userId, int page = 1}) {
    final endpoint = '${ApiConstants.baseUrl}/applied-jobs/user/$userId?page=$page';
    return _apiClient.get<AppliedJobsResponseModel>(
      endpoint,
      fromJsonT: (json) => AppliedJobsResponseModel.fromJson(json['data'] ?? json),
    );
  }
}
