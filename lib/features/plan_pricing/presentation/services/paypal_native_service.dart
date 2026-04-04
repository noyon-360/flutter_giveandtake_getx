import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PaypalNativeService {
  static const MethodChannel _channel = MethodChannel(
    'com.betopia.giveandtake/paypal',
  );

  /// Initialize the PayPal Native SDK
  Future<void> initPayPal({
    required String clientId,
    required String returnUrl,
    bool isSandbox = true,
  }) async {
    try {
      await _channel.invokeMethod('initPayPal', {
        'clientId': clientId,
        'returnUrl': returnUrl,
        'isSandbox': isSandbox,
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to init PayPal: '${e.message}'.");
      rethrow;
    }
  }

  /// Start the PayPal payment flow
  /// Returns a map with 'orderId' and 'payerId' on success
  Future<Map<String, dynamic>?> startPayment({required String orderId}) async {
    try {
      final result = await _channel.invokeMethod('startPayment', {
        'orderId': orderId,
      });
      if (result != null) {
        return Map<String, dynamic>.from(result);
      }
      return null;
    } on PlatformException catch (e) {
      debugPrint("Failed to start payment: '${e.message}'.");
      rethrow;
    }
  }
}
