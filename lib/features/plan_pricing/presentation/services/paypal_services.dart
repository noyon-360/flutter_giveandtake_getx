import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http_auth/http_auth.dart';

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
      print('🔵 PayPal API: Requesting access token...');
      print('🔵 PayPal API: Using clientId: ${clientId.substring(0, 10)}...');

      var client = BasicAuthClient(clientId, secret);
      var response = await client.post(
        Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'),
      );

      print('🔵 PayPal API: Token response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        print('✅ PayPal API: Access token received successfully');
        return body["access_token"];
      } else {
        final body = convert.jsonDecode(response.body);
        print('❌ PayPal API: Failed to get token - ${body.toString()}');
        throw Exception(
          'Failed to get PayPal access token: ${body["error_description"] ?? body.toString()}',
        );
      }
    } catch (e) {
      print('❌ PayPal API: Exception getting token: $e');
      rethrow;
    }
  }

  // for creating the payment request with PayPal
  Future<Map<String, String>?> createPaypalPayment(
    Map<String, dynamic> transactions,
    String accessToken,
  ) async {
    try {
      print('🔵 PayPal API: Creating payment...');
      print(
        '🔵 PayPal API: Transaction data: ${convert.jsonEncode(transactions)}',
      );

      var response = await http.post(
        Uri.parse("$domain/v1/payments/payment"),
        body: convert.jsonEncode(transactions),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('🔵 PayPal API: Payment response status: ${response.statusCode}');
      print('🔵 PayPal API: Payment response body: ${response.body}');

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

          print('✅ PayPal API: Payment created successfully');
          print('🔵 PayPal API: Approval URL: $approvalUrl');
          print('🔵 PayPal API: Execute URL: $executeUrl');

          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        print('⚠️ PayPal API: No links found in response');
        throw Exception('No payment links received from PayPal');
      } else {
        print('❌ PayPal API: Payment creation failed - ${body["message"]}');
        throw Exception(body["message"] ?? 'Failed to create PayPal payment');
      }
    } catch (e) {
      print('❌ PayPal API: Exception creating payment: $e');
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
      var response = await http.post(
        Uri.parse(url),
        body: convert.jsonEncode({"payer_id": payerId}),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      );

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return body["id"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
