import 'package:karlfive/core/network/network_result.dart';
import 'package:karlfive/features/job_listing/data/models/job_model.dart';
import 'package:karlfive/features/job_listing/domain/repo/job_listing_repository.dart';

class GetJobDetailsUseCase {
  final JobListingRepository _repository;

  GetJobDetailsUseCase(this._repository);

  NetworkResult<JobModel> call(String jobId) {
    return _repository.getJobDetails(jobId);
  }
}
