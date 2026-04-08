import '../../../../core/network/network_result.dart';
import '../../data/models/job_application_request.dart';
import '../../data/models/job_application_response.dart';
import 'dart:io';

abstract class JobApplicationRepository {
  NetworkResult<JobApplicationResponse> submitApplication(JobApplicationRequest request);
  NetworkResult<String> uploadResume({
    required File file,
    required String userId,
  });
}
