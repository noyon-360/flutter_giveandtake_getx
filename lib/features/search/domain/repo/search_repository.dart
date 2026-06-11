import 'package:dio/dio.dart';

import '../../../../core/network/network_result.dart';
import '../../../company/data/model/seach_all_user_response_model.dart';
import '../../../job_listing/data/models/job_listing_response_model.dart';

/// Search across the two entity types the web global-search covers:
/// people (candidate / recruiter / company) and jobs.
abstract class SearchRepository {
  /// People search via GET /fetch/all/users?q=. Returns the full filtered list
  /// (the backend does not paginate this endpoint). A [cancelToken] lets the
  /// caller abort an in-flight request when a newer keystroke arrives.
  NetworkResult<List<SeachAllUserResponseModel>> searchPeople(
    String q, {
    CancelToken? cancelToken,
  });

  /// Job search via GET /jobs?title=&page=&limit= (server-paginated).
  NetworkResult<JobListingResponseModel> searchJobs({
    required String title,
    int page,
    int limit,
  });
}
