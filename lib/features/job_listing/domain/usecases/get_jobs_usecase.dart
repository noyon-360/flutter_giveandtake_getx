import '../../../../core/network/network_result.dart';
import '../../data/models/job_listing_response_model.dart';
import '../repo/job_listing_repository.dart';

class GetJobsUseCase {
  final JobListingRepository _repository;

  GetJobsUseCase(this._repository);

  NetworkResult<JobListingResponseModel> call({
    int page = 1,
    int limit = 10,
    String? search,
  }) {
    return _repository.getJobs(page: page, limit: limit, search: search);
  }
}
