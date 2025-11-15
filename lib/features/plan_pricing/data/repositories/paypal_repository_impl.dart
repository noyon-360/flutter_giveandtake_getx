import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/repositories/paypal_repository.dart';
import '../models/paypal_create_order_request.dart';
import '../models/paypal_create_order_response.dart';

class PaypalRepositoryImpl implements PaypalRepository {
  final ApiClient _apiClient;

  PaypalRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<PaypalCreateOrderResponse> createOrder(
    PaypalCreateOrderRequest request,
  ) {
    return _apiClient.post<PaypalCreateOrderResponse>(
      ApiConstants.paypal.createOrder,
      data: request.toJson(),
      fromJsonT: (json) => PaypalCreateOrderResponse.fromJson(json),
    );
  }
}
