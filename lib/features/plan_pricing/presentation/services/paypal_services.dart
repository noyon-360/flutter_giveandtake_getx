import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http_auth/http_auth.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/network/constants/api_constants.dart';

import '../../../../core/services/get_user_profile_service.dart';

class PaypalServices {
  String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
  // String domain = "https://api.paypal.com"; // for production mode

  // TODO: Replace with your own PayPal credentials
  String clientId =
      'AXmwL-mntKGqTAb6_DaY5o6qh5R0UTxuMkwDJsgUlHW72W-x5t4SZsgSNi9XOfbGYoxlAHiXlSsjnB_L';
  String secret =
      'EN4NbRoPhpyoGY1ob0AmquesiQo917d0nSl5bMUwCwydtG2aNgsxVqlL1fAghwk0-K4h08pBMrDuxHF8';

  // for getting the access token from PayPal
  Future<String?> getAccessToken() async {
    try {
      print('═════════════════════════════════════════════════════════');
      print('🔵 API Endpoint: https://api.sandbox.paypal.com/v1/oauth2/token');
      print('═════════════════════════════════════════════════════════');
      print('🔵 Request Model:');
      print('   Grant Type: client_credentials');
      print('   ClientId: ${clientId.substring(0, 10)}...');
      print('─────────────────────────────────────────────────────────');

      var client = BasicAuthClient(clientId, secret);
      var response = await client.post(
        Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'),
      );

      print('✅ API Response - Get Access Token:');
      print('   Status Code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        print('   Response: ${convert.jsonEncode(body)}');
        print('═════════════════════════════════════════════════════════');
        return body["access_token"];
      } else {
        final body = convert.jsonDecode(response.body);
        print('❌ API Response - Error:');
        print('   Status: FAILED');
        print('   Error: ${body.toString()}');
        print('═════════════════════════════════════════════════════════');
        throw Exception(
          'Failed to get PayPal access token: ${body["error_description"] ?? body.toString()}',
        );
      }
    } catch (e) {
      print('❌ API Response - Exception:');
      print('   Error: $e');
      print('═════════════════════════════════════════════════════════');
      rethrow;
    }
  }

  // for creating the payment request with PayPal
  Future<Map<String, String>?> createPaypalPayment(
    Map<String, dynamic> transactions,
    String accessToken,
  ) async {
    try {
      print('═════════════════════════════════════════════════════════');
      print('🔵 API Endpoint: https://api.sandbox.paypal.com/v1/payments/payment');
      print('═════════════════════════════════════════════════════════');
      print('🔵 Request Model:');
      print('   Method: POST');
      print('   Full Request: ${convert.jsonEncode(transactions)}');
      print('─────────────────────────────────────────────────────────');

      var response = await http.post(
        Uri.parse("$domain/v1/payments/payment"),
        body: convert.jsonEncode(transactions),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('✅ API Response - Create Payment:');
      print('   Status Code: ${response.statusCode}');
      print('   Response Body: ${response.body}');

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";

          final item = links.firstWhere(
            (o) => o["rel"] == "approval_url",
            orElse: () => null,
          );
          if (item != null) {
            approvalUrl = item["href"];
          }

          final item1 = links.firstWhere(
            (o) => o["rel"] == "execute",
            orElse: () => null,
          );
          if (item1 != null) {
            executeUrl = item1["href"];
          }

          // Extract token from approvalUrl
          String token = "";
          try {
            if (approvalUrl.isNotEmpty) {
              final uri = Uri.parse(approvalUrl);
              token = uri.queryParameters['token'] ?? "";
            }
          } catch (e) {
            print("Error extracting token: $e");
          }

          print('   Approval URL: $approvalUrl');
          print('   Execute URL: $executeUrl');
          print('   Token: $token');
          print('═════════════════════════════════════════════════════════');

          return {
            "executeUrl": executeUrl,
            "approvalUrl": approvalUrl,
            "token": token,
            "id": body["id"] ?? ""
          };
        }
        print('⚠️ No links found in response');
        print('═════════════════════════════════════════════════════════');
        throw Exception('No payment links received from PayPal');
      } else {
        print('❌ API Response - Error:');
        print('   Status: FAILED');
        print('   Error: ${body["message"]}');
        print('═════════════════════════════════════════════════════════');
        throw Exception(body["message"] ?? 'Failed to create PayPal payment');
      }
    } catch (e) {
      print('❌ API Response - Exception:');
      print('   Error: $e');
      print('═════════════════════════════════════════════════════════');
      rethrow;
    }
  }

  // for executing the payment transaction
  Future<String?> executePayment(
    String url,
    String payerId,
    String accessToken,
  ) async {
    try {
      print('═════════════════════════════════════════════════════════');
      print('🔵 API Endpoint: $url');
      print('═════════════════════════════════════════════════════════');
      print('🔵 Request Model:');
      print('   Payer ID: $payerId');
      print('   Full Request: ${convert.jsonEncode({"payer_id": payerId})}');
      print('─────────────────────────────────────────────────────────');

      var response = await http.post(
        Uri.parse(url),
        body: convert.jsonEncode({"payer_id": payerId}),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('✅ API Response - Execute Payment:');
      print('   Status Code: ${response.statusCode}');
      print('   Response Body: ${response.body}');
      print('═════════════════════════════════════════════════════════');

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return body["id"];
      }
      return null;
    } catch (e) {
      print('❌ API Response - Exception:');
      print('   Error: $e');
      print('═════════════════════════════════════════════════════════');
      rethrow;
    }
  }
  // Create Order (v2) for Native Checkout
  Future<String?> createOrderV2(
    double amount,
    String accessToken,
  ) async {
    try {
      print('═════════════════════════════════════════════════════════');
      print('🔵 API Endpoint: https://api.sandbox.paypal.com/v2/checkout/orders');
      print('═════════════════════════════════════════════════════════');
      
      final requestBody = {
        "intent": "CAPTURE",
        "purchase_units": [
          {
            "amount": {
              "currency_code": "USD",
              "value": amount.toStringAsFixed(2),
            }
          }
        ]
      };

      print('🔵 Request Model:');
      print('   Amount: $amount USD');
      print('   Full Request: ${convert.jsonEncode(requestBody)}');
      print('─────────────────────────────────────────────────────────');

      var response = await http.post(
        Uri.parse("$domain/v2/checkout/orders"),
        body: convert.jsonEncode(requestBody),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('✅ API Response - Create Order V2:');
      print('   Status Code: ${response.statusCode}');
      print('   Response Body: ${response.body}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        print('═════════════════════════════════════════════════════════');
        return body["id"];
      } else {
        final body = convert.jsonDecode(response.body);
        print('❌ API Response - Error:');
        print('   Status: FAILED');
        print('   Error: ${body.toString()}');
        print('═════════════════════════════════════════════════════════');
        throw Exception(body["message"] ?? 'Failed to create PayPal order');
      }
    } catch (e) {
      print('❌ API Response - Exception:');
      print('   Error: $e');
      print('═════════════════════════════════════════════════════════');
      rethrow;
    }
  }

  // Capture Order (v2)
  Future<bool> captureOrder(
    String orderId,
    String accessToken,
  ) async {
    try {
      print('═════════════════════════════════════════════════════════');
      print('🔵 API Endpoint: https://api.sandbox.paypal.com/v2/checkout/orders/$orderId/capture');
      print('═════════════════════════════════════════════════════════');
      print('🔵 Request Model:');
      print('   OrderId: $orderId');
      print('─────────────────────────────────────────────────────────');

      var response = await http.post(
        Uri.parse("$domain/v2/checkout/orders/$orderId/capture"),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('✅ API Response - Capture Order V2:');
      print('   Status Code: ${response.statusCode}');
      print('   Response Body: ${response.body}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('═════════════════════════════════════════════════════════');
        return true;
      } else {
         try {
             final body = convert.jsonDecode(response.body);
             print('❌ API Response - Error:');
             print('   Status: FAILED');
             print('   Error: ${body.toString()}');
         } catch (_) {
             print('❌ API Response - Error:');
             print('   Status: FAILED');
             print('   Error: ${response.body}');
         }
         print('═════════════════════════════════════════════════════════');
        // throw Exception('Failed to capture PayPal order');
        return false;
      }
    } catch (e) {
      print('❌ API Response - Exception:');
      print('   Error: $e');
      print('═════════════════════════════════════════════════════════');
      rethrow;
    }
  }
  // Capture Order via Backend API
  Future<bool> captureOrderBackend({
    required String orderId,
    required String userId,
    required String planId,
    String? seasonId,
  }) async {
    try {
      print('🔵 Backend API: Capturing order $orderId...');

      // Get user token from secure storage
      final userProfileService = Get.find<GetUserProfileService>();
      final token = userProfileService.userInfo?.refreshToken ?? '';

      final body = {
        "orderId": orderId,
        "userId": userId,
        "planId": planId,
        if (seasonId != null && seasonId.isNotEmpty) "seasonId": seasonId,
      };

      var response = await http.post(
        Uri.parse('${ApiConstants.paypal.captureOrder}'),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(body),
      );

      print('🔵 Backend API: Capture response status: ${response.statusCode}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Backend API: Order captured successfully.');
        return true;
      } else {
         try {
             final body = convert.jsonDecode(response.body);
             print('❌ Backend API: Failed to capture - ${body.toString()}');
         } catch (_) {
             print('❌ Backend API: Failed to capture - ${response.body}');
         }
        return false;
      }
    } catch (e) {
      print('❌ Backend API: Exception capturing order: $e');
      rethrow;
    }
  }
}
