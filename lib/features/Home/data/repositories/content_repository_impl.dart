import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/constants/key_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../../../core/network/network_result.dart';
import '../../../../core/network/services/secure_store_services.dart';
import '../../domain/repositories/content_repository.dart';
import '../models/content_response.dart';

class ContentRepositoryImpl implements ContentRepository {
  final SecureStoreServices _secureStoreServices = SecureStoreServices();

  ContentRepositoryImpl();

  @override
  NetworkResult<ContentResponse> getContentByType(String type) async {
    try {
      // Get the dio instance directly to bypass BaseResponse parsing
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

      final response = await dio.get(
        ApiConstants.content.getContentByType(type),
      );

      final responseData = response.data;
      
      // Handle the custom response format: {status: "success", data: {...}}
      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final contentData = ContentResponse.fromJson(responseData['data']);
        return Right(NetworkSuccess(
          data: contentData,
          message: responseData['message'] ?? 'Content retrieved successfully',
          statusCode: response.statusCode ?? 200,
        ));
      } else {
        return Left(NetworkFailure(
          message: responseData['message'] ?? 'Failed to fetch content',
          statusCode: response.statusCode ?? 400,
        ));
      }
    } catch (e) {
      return Left(NetworkFailure(
        message: 'Failed to fetch content: $e',
        statusCode: 500,
      ));
    }
  }
}
