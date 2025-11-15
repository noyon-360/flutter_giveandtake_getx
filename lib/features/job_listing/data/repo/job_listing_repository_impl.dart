import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/repo/job_listing_repository.dart';
import '../models/job_listing_response_model.dart';

class JobListingRepositoryImpl implements JobListingRepository {
  final ApiClient _apiClient;

  JobListingRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  NetworkResult<JobListingResponseModel> getJobs({int limit = 100}) {
    return _apiClient.get<JobListingResponseModel>(
      ApiConstants.jobs.getJobs(limit),
      fromJsonT: (json) => JobListingResponseModel.fromJson(json),
    );
  }
}
