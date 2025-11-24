import '../../../../core/base/base_controller.dart';
import '../../data/models/paypal_create_order_request.dart';
import '../../data/models/paypal_create_order_response.dart';
import '../../domain/repositories/paypal_repository.dart';

class PaypalController extends BaseController {
  final PaypalRepository _paypalRepository;

  PaypalController(this._paypalRepository);

  /// Create PayPal order and return the response with approve URL
  Future<PaypalCreateOrderResponse?> createOrder(double amount) async {
    setLoading(true);
    clearError();

    try {
      final request = PaypalCreateOrderRequest(
        amount: amount.toStringAsFixed(2),
      );

      final result = await _paypalRepository.createOrder(request);

      return result.fold(
        (failure) {
          setError(failure.message);
          return null;
        },
        (success) {
          return success.data;
        },
      );
    } catch (e) {
      setError('Failed to create PayPal order: $e');
      return null;
    } finally {
      setLoading(false);
    }
  }
}
