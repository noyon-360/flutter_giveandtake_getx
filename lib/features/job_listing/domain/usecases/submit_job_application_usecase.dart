import '../../../../core/network/network_result.dart';
import '../../data/models/job_application_request.dart';
import '../../data/models/job_application_response.dart';
import '../repositories/job_application_repository.dart';

class SubmitJobApplicationUseCase {
  final JobApplicationRepository _repository;

  SubmitJobApplicationUseCase(this._repository);

  NetworkResult<JobApplicationResponse> call(JobApplicationRequest request) {
    return _repository.submitApplication(request);
  }
}