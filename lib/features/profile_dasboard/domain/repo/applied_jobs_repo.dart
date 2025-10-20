import '../../../../core/network/network_result.dart';
import '../../data/models/applied_jobs_response_model.dart';

abstract class AppliedJobsRepo {
  NetworkResult<AppliedJobsResponseModel> fetchUserApplications({required String userId, int page = 1});
}
