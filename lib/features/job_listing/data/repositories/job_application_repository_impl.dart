import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/constants/key_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../../../core/network/network_result.dart';
import '../../../../core/network/services/secure_store_services.dart';
import '../../domain/repositories/job_application_repository.dart';
import '../models/job_application_request.dart';
import '../models/job_application_response.dart';

class JobApplicationRepositoryImpl implements JobApplicationRepository {
  final SecureStoreServices _secureStoreServices = SecureStoreServices();

  @override
  NetworkResult<JobApplicationResponse> submitApplication(JobApplicationRequest request) async {
    try {
      final dio = Dio();
      
      // Copy headers from the API client
      dio.options.headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      
      // Add authorization header if available
      final token = await _secureStoreServices.retrieveData(KeyConstants.accessToken);
      if (token != null && token.isNotEmpty) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }

      final response = await dio.post(
        '${ApiConstants.baseUrl}/applications', // Adjust endpoint as needed
        data: request.toJson(),
      );

      final responseData = response.data;
      
      // Handle the custom response format: {status: "success", data: {...}}
      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final applicationData = JobApplicationResponse.fromJson(responseData['data']);
        return Right(NetworkSuccess(
          data: applicationData,
          message: responseData['message'] ?? 'Application submitted successfully',
          statusCode: response.statusCode ?? 200,
        ));
      } else {
        return Left(NetworkFailure(
          message: responseData['message'] ?? 'Failed to submit application',
          statusCode: response.statusCode ?? 400,
        ));
      }
    } catch (e) {
      return Left(NetworkFailure(
        message: 'Failed to submit application: $e',
        statusCode: 500,
      ));
    }
  }
}