import '../../../../core/network/network_result.dart';
import '../../data/models/paypal_create_order_request.dart';
import '../../data/models/paypal_create_order_response.dart';

abstract class PaypalRepository {
  NetworkResult<PaypalCreateOrderResponse> createOrder(
    PaypalCreateOrderRequest request,
  );
}
