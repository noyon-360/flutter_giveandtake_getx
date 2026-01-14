import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/constants/key_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../../../core/network/network_result.dart';
import '../../../../core/network/services/secure_store_services.dart';
import '../../data/models/payment_history_response_model.dart';
import '../../domain/repo/payment_history_repo.dart';

class PaymentHistoryRepoImpl implements PaymentHistoryRepo {
  final SecureStoreServices _secureStoreServices = SecureStoreServices();

  @override
  NetworkResult<PaymentHistoryResponseModel> fetchUserPayments({
    required String userId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final endpoint = ApiConstants.payment.getUserPayments(
        userId,
        page,
        limit,
      );

      // Create Dio instance
      final dio = Dio();

      // Get auth token
      final token = await _secureStoreServices.retrieveData(
        KeyConstants.accessToken,
      );

      // Make request with Dio directly to access both 'data' and 'meta'
      final response = await dio.get(
        endpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      // Check success
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['success'] != true) {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to fetch payments',
            statusCode: response.statusCode ?? 400,
          ),
        );
      }

      // Parse the full response with both 'data' and 'meta'
      final model = PaymentHistoryResponseModel.fromJson(responseData);

      return Right(
        NetworkSuccess(
          data: model,
          message: responseData['message'] ?? 'Success',
          statusCode: response.statusCode ?? 200,
        ),
      );
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data?['message'] ?? e.message ?? 'Network error',
          statusCode: e.response?.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return Left(
        UnknownFailure(message: 'Failed to fetch payment history: $e'),
      );
    }
  }
}
