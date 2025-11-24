import '../../../../core/network/network_result.dart';
import '../../data/models/job_listing_response_model.dart';

abstract class JobListingRepository {
  NetworkResult<JobListingResponseModel> getJobs({int limit = 100});
}
