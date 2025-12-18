import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/repo/job_listing_repository.dart';
import '../models/job_listing_response_model.dart';
import '../models/job_model.dart';

class JobListingRepositoryImpl implements JobListingRepository {
  final ApiClient _apiClient;

  JobListingRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  NetworkResult<JobListingResponseModel> getJobs({
    int page = 1,
    int limit = 10,
    String? search,
  }) {
    return _apiClient.get<JobListingResponseModel>(
      ApiConstants.jobs.getJobs(page, limit, search: search),
      fromJsonT: (json) {
        print("DEBUG: JobListingRepositoryImpl raw json: $json");
        return JobListingResponseModel.fromJson(json);
      },
    );
  }

  @override
  NetworkResult<JobModel> getJobDetails(String jobId) {
    return _apiClient.get<JobModel>(
      ApiConstants.recruiter.getSingleJob(jobId),
      fromJsonT: (json) => JobModel.fromJson(json),
    );
  }
}
