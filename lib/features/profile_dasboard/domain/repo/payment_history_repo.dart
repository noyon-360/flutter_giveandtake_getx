import '../../../../core/network/network_result.dart';
import '../../data/models/payment_history_response_model.dart';

abstract class PaymentHistoryRepo {
  NetworkResult<PaymentHistoryResponseModel> fetchUserPayments({
    required String userId,
    int page = 1,
    int limit = 10,
  });
}
