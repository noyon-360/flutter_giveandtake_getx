import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../../company/data/model/seach_all_user_response_model.dart';
import '../../../job_listing/data/models/job_listing_response_model.dart';
import '../../domain/repo/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final ApiClient apiClient;

  SearchRepositoryImpl({required this.apiClient});

  @override
  NetworkResult<List<SeachAllUserResponseModel>> searchPeople(
    String q, {
    CancelToken? cancelToken,
  }) {
    return apiClient.get(
      ApiConstants.search.people(q),
      options: Options(
        headers: {'X-Skip-Auth': true},
      ),
      cancelToken: cancelToken,
      // Same parser as the existing CompanyRepoImplementation.fetchSearchUser.
      fromJsonT: (json) => (json as List<dynamic>? ?? [])
          .where((item) => item != null)
          .map(
            (item) =>
                SeachAllUserResponseModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  @override
  NetworkResult<JobListingResponseModel> searchJobs({
    required String title,
    int page = 1,
    int limit = 10,
  }) {
    return apiClient.get(
      ApiConstants.search.jobs(title, page, limit),
      fromJsonT: (json) => JobListingResponseModel.fromJson(json),
    );
  }
}
