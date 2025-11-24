import '../../../../core/network/network_result.dart';
import '../../data/models/job_listing_response_model.dart';
import '../repo/job_listing_repository.dart';

class GetJobsUseCase {
  final JobListingRepository _repository;

  GetJobsUseCase(this._repository);

  NetworkResult<JobListingResponseModel> call({int limit = 100}) {
    return _repository.getJobs(limit: limit);
  }
}
