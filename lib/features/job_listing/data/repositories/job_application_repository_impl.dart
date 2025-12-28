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

      // Debug: Print request details
      print('========== JOB APPLICATION API REQUEST ==========');
      print('Endpoint: ${ApiConstants.jobs.applyJob}');
      print('Request Payload: ${request.toJson()}');
      print('Headers: ${dio.options.headers}');
      print('================================================');

      final response = await dio.post(
        ApiConstants.jobs.applyJob,
        data: request.toJson(),
      );

      final responseData = response.data;
      
      // Debug: Print response details
      print('========== JOB APPLICATION API RESPONSE ==========');
      print('Status Code: ${response.statusCode}');
      print('Response Data: $responseData');
      print('Response Type: ${responseData.runtimeType}');
      print('==================================================');
      
      // Handle different response formats
      // 1. Check if it's a wrapped response with status and data
      if (responseData is Map<String, dynamic>) {
        final status = responseData['status'];
        final message = responseData['message'] ?? 'Application submitted successfully';
        
        print('Response status: $status');
        print('Response message: $message');
        
        // Success if status is 'success' or HTTP status code is 2xx
        if (status == 'success' && responseData['data'] != null) {
          final applicationData = JobApplicationResponse.fromJson(responseData['data']);
          return Right(NetworkSuccess(
            data: applicationData,
            message: message,
            statusCode: response.statusCode ?? 200,
          ));
        } else if ((response.statusCode ?? 200) >= 200 && (response.statusCode ?? 200) < 300) {
          // If status code is 2xx, treat as success regardless of status field
          final appData = responseData['data'] ?? responseData;
          Map<String, dynamic> dataMap = {};
          if (appData is Map) {
            dataMap = Map<String, dynamic>.from(appData);
          }
          final applicationData = JobApplicationResponse.fromJson(dataMap);
          return Right(NetworkSuccess(
            data: applicationData,
            message: message,
            statusCode: response.statusCode ?? 200,
          ));
        } else {
          return Left(NetworkFailure(
            message: message,
            statusCode: response.statusCode ?? 400,
          ));
        }
      } else {
        // If response is not a map, return error
        return Left(NetworkFailure(
          message: 'Invalid response format',
          statusCode: response.statusCode ?? 400,
        ));
      }
    } on DioException catch (e) {
      print('========== JOB APPLICATION API ERROR (DioException) ==========');
      print('Error Type: ${e.type}');
      print('Error Message: ${e.message}');
      print('Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      print('Stack Trace: ${e.stackTrace}');
      print('===============================================================');
      
      return Left(NetworkFailure(
        message: e.response?.data['message'] ?? 'Failed to submit application: ${e.message}',
        statusCode: e.response?.statusCode ?? 500,
      ));
    } catch (e, stackTrace) {
      print('========== JOB APPLICATION API ERROR (General) ==========');
      print('Error: $e');
      print('Stack Trace: $stackTrace');
      print('=========================================================');
      
      return Left(NetworkFailure(
        message: 'Failed to submit application: $e',
        statusCode: 500,
      ));
    }
  }
}