import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/constants/key_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../../../core/network/network_result.dart';
import '../../../../core/network/services/secure_store_services.dart';
import '../../data/models/applied_jobs_response_model.dart';
import '../../domain/repo/applied_jobs_repo.dart';

class AppliedJobsRepoImpl implements AppliedJobsRepo {
  final SecureStoreServices _secureStoreServices = SecureStoreServices();

  @override
  NetworkResult<AppliedJobsResponseModel> fetchUserApplications({
    required String userId,
    int page = 1,
  }) async {
    try {
      final endpoint =
          '${ApiConstants.baseUrl}/applied-jobs/user/$userId?page=$page';

      print('📋 [JobHistory] Fetching applications from: $endpoint');

      // Create Dio instance
      final dio = Dio();

      // Get auth token
      final token = await _secureStoreServices.retrieveData(
        KeyConstants.accessToken,
      );

      print('📋 [JobHistory] Token retrieved: ${token != null}');

      // Make request with Dio directly to access full response
      final response = await dio.get(
        endpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('📋 [JobHistory] Response status: ${response.statusCode}');
      print('📋 [JobHistory] Response data type: ${response.data.runtimeType}');

      // Check success
      final responseData = response.data as Map<String, dynamic>;

      print('📋 [JobHistory] Response keys: ${responseData.keys.toList()}');

      // Check if data is nested
      if (responseData.containsKey('data')) {
        final dataObj = responseData['data'] as Map<String, dynamic>?;
        print('📋 [JobHistory] Data object keys: ${dataObj?.keys.toList()}');
        print(
          '📋 [JobHistory] Applications count in data: ${(dataObj?['applications'] as List?)?.length ?? 0}',
        );
      } else {
        print(
          '📋 [JobHistory] Applications count: ${(responseData['applications'] as List?)?.length ?? 0}',
        );
      }

      // Parse the response
      final model = AppliedJobsResponseModel.fromJson(responseData);

      print('📋 [JobHistory] Model parsed successfully');
      print(
        '📋 [JobHistory] Model applications count: ${model.applications.length}',
      );

      return Right(
        NetworkSuccess(
          data: model,
          message: responseData['message'] ?? 'Success',
          statusCode: response.statusCode ?? 200,
        ),
      );
    } on DioException catch (e) {
      print('❌ [JobHistory] DioException: ${e.message}');
      print('❌ [JobHistory] Response: ${e.response?.data}');
      return Left(
        ServerFailure(
          message: e.response?.data?['message'] ?? e.message ?? 'Network error',
          statusCode: e.response?.statusCode ?? 500,
        ),
      );
    } catch (e, stackTrace) {
      print('❌ [JobHistory] Exception: $e');
      print('❌ [JobHistory] StackTrace: $stackTrace');
      return Left(UnknownFailure(message: 'Failed to fetch applications: $e'));
    }
  }
}
