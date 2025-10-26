import '../../../../core/network/network_result.dart';
import '../../data/models/job_application_request.dart';
import '../../data/models/job_application_response.dart';

abstract class JobApplicationRepository {
  NetworkResult<JobApplicationResponse> submitApplication(JobApplicationRequest request);
}