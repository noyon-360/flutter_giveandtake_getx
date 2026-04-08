import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:giveandtake/core/contracts/web/job_application_contract.dart';

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
  JobApplicationRepositoryImpl({SecureStoreServices? secureStoreServices})
    : _secureStoreServices = secureStoreServices ?? SecureStoreServices();

  final SecureStoreServices _secureStoreServices;

  Future<Dio> _authorizedDio({bool isMultipart = false}) async {
    final dio = Dio();
    dio.options.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': isMultipart ? 'multipart/form-data' : 'application/json',
    });

    final token = await _secureStoreServices.retrieveData(KeyConstants.accessToken);
    if (token != null && token.isNotEmpty) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
    return dio;
  }

  @override
  NetworkResult<String> uploadResume({
    required File file,
    required String userId,
  }) async {
    try {
      final dio = await _authorizedDio(isMultipart: true);
      final payload = JobApplicationPayloadBuilder.buildResumeUpload(
        ResumeUploadInput(
          userId: userId,
          file: file,
        ),
      );

      final response = await dio.post(
        ApiConstants.resume.uploadResume,
        data: await payload.toFormData(),
      );

      final responseData = response.data;
      final data = responseData is Map<String, dynamic>
          ? responseData['data']
          : null;
      final resumeId =
          (data is Map<String, dynamic> ? data['_id'] ?? data['id'] : null)
              ?.toString();

      if ((response.statusCode ?? 500) >= 200 &&
          (response.statusCode ?? 500) < 300 &&
          resumeId != null &&
          resumeId.isNotEmpty) {
        return Right(
          NetworkSuccess(
            data: resumeId,
            message:
                responseData is Map<String, dynamic> && responseData['message'] != null
                ? responseData['message'].toString()
                : 'Resume uploaded successfully',
            statusCode: response.statusCode ?? 200,
          ),
        );
      }

      return Left(
        NetworkFailure(
          message: responseData is Map<String, dynamic>
              ? (responseData['message']?.toString() ??
                    'Failed to upload resume')
              : 'Failed to upload resume',
          statusCode: response.statusCode ?? 400,
        ),
      );
    } on DioException catch (e) {
      return Left(
        NetworkFailure(
          message: e.response?.data is Map<String, dynamic>
              ? (e.response?.data['message']?.toString() ??
                    'Failed to upload resume')
              : 'Failed to upload resume',
          statusCode: e.response?.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return Left(
        NetworkFailure(
          message: 'Failed to upload resume: $e',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  NetworkResult<JobApplicationResponse> submitApplication(
    JobApplicationRequest request,
  ) async {
    try {
      final dio = await _authorizedDio();
      final response = await dio.post(
        ApiConstants.jobs.applyJob,
        data: request.toJson(),
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final statusCode = response.statusCode ?? 200;
        final message = responseData['message']?.toString() ??
            'Application submitted successfully';
        final data = responseData['data'] is Map<String, dynamic>
            ? responseData['data'] as Map<String, dynamic>
            : <String, dynamic>{};

        if (statusCode >= 200 && statusCode < 300) {
          return Right(
            NetworkSuccess(
              data: JobApplicationResponse.fromJson(data),
              message: message,
              statusCode: statusCode,
            ),
          );
        }

        return Left(
          NetworkFailure(
            message: message,
            statusCode: statusCode,
          ),
        );
      }

      return Left(
        NetworkFailure(
          message: 'Invalid response format',
          statusCode: response.statusCode ?? 400,
        ),
      );
    } on DioException catch (e) {
      return Left(
        NetworkFailure(
          message: e.response?.data is Map<String, dynamic>
              ? (e.response?.data['message']?.toString() ??
                    'Failed to submit application')
              : 'Failed to submit application',
          statusCode: e.response?.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return Left(
        NetworkFailure(
          message: 'Failed to submit application: $e',
          statusCode: 500,
        ),
      );
    }
  }
}
