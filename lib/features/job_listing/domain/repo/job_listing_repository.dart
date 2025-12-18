import '../../../../core/network/network_result.dart';
import '../../data/models/job_listing_response_model.dart';
import '../../data/models/job_model.dart';

abstract class JobListingRepository {
  NetworkResult<JobListingResponseModel> getJobs({
    int page = 1,
    int limit = 10,
    String? search,
  });

  NetworkResult<JobModel> getJobDetails(String jobId);
}
