import '../../../../core/base/base_controller.dart';
import '../../data/models/paypal_create_order_request.dart';
import '../../data/models/paypal_create_order_response.dart';
import '../../domain/repositories/paypal_repository.dart';
import '../services/paypal_native_service.dart';
import '../services/paypal_services.dart';

class PaypalController extends BaseController {
  final PaypalRepository _paypalRepository;

  PaypalController(this._paypalRepository);

  final PaypalServices _paypalServices = PaypalServices();
  final PaypalNativeService _paypalNativeService = PaypalNativeService();

  /// Create PayPal order and return the response with approve URL
  Future<PaypalCreateOrderResponse?> createOrder(double amount) async {
    setLoading(true);
    clearError();

    try {
      final request = PaypalCreateOrderRequest(
        amount: amount.toStringAsFixed(2),
      );

      // Print endpoint
      print('═════════════════════════════════════════════════════════');
      print('🔵 API Endpoint: {{base_url}}/payments/paypal/create-order');
      print('═════════════════════════════════════════════════════════');

      // Print request model
      print('🔵 Request Model:');
      print('   Amount: ${request.toJson()['amount']}');
      print('   Full Request: ${request.toJson()}');
      print('─────────────────────────────────────────────────────────');

      final result = await _paypalRepository.createOrder(request);

      return result.fold(
        (failure) {
          print('❌ API Response - Error:');
          print('   Status: FAILED');
          print('   Error Message: ${failure.message}');
          print('═════════════════════════════════════════════════════════');
          setError(failure.message);
          return null;
        },
        (success) {
          print('✅ API Response - Success:');
          print('   Status: SUCCESS');
          print('   OrderId: ${success.data.orderId}');
          print('   Links Count: ${success.data.links.length}');
          if (success.data.links.isNotEmpty) {
            for (int i = 0; i < success.data.links.length; i++) {
              print('   Link ${i + 1}:');
              print('      Rel: ${success.data.links[i].rel}');
              print('      Href: ${success.data.links[i].href}');
              print('      Method: ${success.data.links[i].method}');
            }
          }
          print('   Full Response: ${success.data.toJson()}');
          print('═════════════════════════════════════════════════════════');
          return success.data;
        },
      );
    } catch (e) {
      print('❌ API Response - Exception:');
      print('   Error: $e');
      print('═════════════════════════════════════════════════════════');
      setError('Failed to create PayPal order: $e');
      return null;
    } finally {
      setLoading(false);
    }
  }

  Future<void> startNativePayment({
    required double amount,
    required String userId,
    required String planId,
    String? seasonId,
    required Function(String orderId) onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      setLoading(true);

      print('🔵 PayPal Native: Starting payment flow...');
      print(
        '🔵 PayPal Native: Amount: $amount, UserId: $userId, PlanId: $planId',
      );

      // 1. Create Order via Backend
      print('🔵 PayPal Native: Creating order via backend...');
      final request = PaypalCreateOrderRequest(
        amount: amount.toStringAsFixed(2),
      );

      print('🔵 PayPal Native: Request payload: ${request.toJson()}');

      final result = await _paypalRepository.createOrder(request);

      String? orderId;
      await result.fold(
        (failure) {
          print('❌ PayPal Native: Failed to create order - ${failure.message}');
          throw Exception(failure.message);
        },
        (success) async {
          orderId = success.data.orderId;
          print('✅ PayPal Native: Order created successfully');
          print('🔵 PayPal Native: OrderId: $orderId');
          print('🔵 PayPal Native: Response: ${success.data.toJson()}');
        },
      );

      if (orderId == null || orderId!.isEmpty) {
        throw Exception("Failed to get orderId from backend");
      }

      // 2. Init Native SDK
      print('🔵 PayPal Native: Initializing Native SDK...');
      await _paypalNativeService.initPayPal(
        clientId: _paypalServices.clientId,
        returnUrl: "com.pooelcentral.giveandtake://paypalpay",
      );
      print('✅ PayPal Native: SDK initialized');

      // 3. Start Payment with the orderId from backend
      print('🔵 PayPal Native: Starting payment with orderId: $orderId');
      final paymentResult = await _paypalNativeService.startPayment(
        orderId: orderId!,
      );

      print('🔵 PayPal Native: Payment result: $paymentResult');

      if (paymentResult != null && paymentResult['orderId'] != null) {
        print('✅ PayPal Native: Payment approved');

        // 4. Capture Order via Backend
        print('🔵 PayPal Native: Capturing order via backend...');
        final captured = await _paypalServices.captureOrderBackend(
          orderId: paymentResult['orderId'],
          userId: userId,
          planId: planId,
          seasonId: seasonId,
        );

        if (captured) {
          print('✅ PayPal Native: Payment captured successfully');
          onSuccess(paymentResult['orderId']);
        } else {
          print('❌ PayPal Native: Failed to capture payment');
          onError("Failed to capture payment");
        }
      } else {
        print('❌ PayPal Native: Payment process incomplete');
        onError("Payment process incomplete");
      }
    } catch (e) {
      print('❌ PayPal Native: Exception - $e');
      onError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
