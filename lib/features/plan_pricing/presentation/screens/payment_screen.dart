import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../../../core/services/get_user_profile_service.dart';
import '../../../Home/presentation/screen/home_screen.dart';
import '../../data/models/paypal_confirm_payment_response.dart';
import '../controllers/paypal_controller.dart';
import '../services/paypal_services.dart';
import 'paypal_webview_screen.dart';
import 'plan_pricing_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String planTitle;
  final double amount;
  final String? orderId;
  final String? approveUrl;
  final String? planId;

  const PaymentScreen({
    super.key,
    required this.planTitle,
    this.amount = 0.00,
    this.orderId,
    this.approveUrl,
    this.planId,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  bool _showCardForm = false;
  bool _isCardPaymentProcessing = false;
  bool _showCardFieldsWebView = false;
  bool _isCapturing = false;
  String?
  _backendOrderId; // Store the orderId from backend create-order endpoint
  WebViewController? _cardFieldsController;

  // Cache userId and token during initState to avoid retrieval issues later
  String? _cachedUserId;
  String? _cachedToken;

  // Form controllers
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _postcodeController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  bool _deliverToBillingAddress = true;
  String _selectedCountry = 'GB'; // Default UK
  String? _selectedCounty;

  // Countries and Counties lists
  List<Map<String, String>> _countries = [];
  List<String> _counties = [];

  @override
  void initState() {
    super.initState();
    _loadCountries();
    // Load user credentials asynchronously - don't await to avoid blocking init
    _loadUserCredentials().then((_) {
      print('✅ User credentials loaded and cached');
    });
  }

  // Load and cache user credentials during init
  Future<void> _loadUserCredentials() async {
    print('🔍 DEBUG: _loadUserCredentials called');

    // IMPORTANT: Always try secure storage first as it's the source of truth
    try {
      final authStorageService = AuthStorageService();
      final storedUserId = await authStorageService.getUserId();
      final storedToken = await authStorageService.getRefreshToken();

      print('🔍 DEBUG: Retrieved from SecureStorage:');
      print('   userId: $storedUserId');
      print(
        '   token: ${storedToken != null ? "exists (${storedToken.length} chars)" : "null"}',
      );

      if (storedUserId != null && storedUserId.isNotEmpty) {
        _cachedUserId = storedUserId;
      }
      if (storedToken != null && storedToken.isNotEmpty) {
        _cachedToken = storedToken;
      }

      if (_cachedUserId != null && _cachedUserId!.isNotEmpty) {
        print('✅ Cached credentials from SecureStorage:');
        print('   userId: $_cachedUserId');
        print('   token length: ${_cachedToken?.length}');
        return;
      }
    } catch (e) {
      print('❌ Failed to load from SecureStorage: $e');
    }

    // Fallback: Try GetUserProfileService (in-memory cache)
    try {
      print('🔍 DEBUG: Attempting fallback to GetUserProfileService');
      final userProfileService = Get.find<GetUserProfileService>();
      if (userProfileService.userInfo != null) {
        _cachedUserId = userProfileService.userInfo!.id;
        _cachedToken = userProfileService.userInfo!.refreshToken;
        print('✅ Cached credentials from GetUserProfileService:');
        print('   userId: $_cachedUserId');
        print('   token length: ${_cachedToken?.length}');
        return;
      } else {
        print('⚠️ GetUserProfileService.userInfo is null');
      }
    } catch (e) {
      print('⚠️ GetUserProfileService not available: $e');
    }

    print('❌ WARNING: Could not load user credentials from any source!');
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _postcodeController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    try {
      // Call PayPal GraphQL API to get checkout details including countries
      final response = await http.post(
        Uri.parse('https://www.sandbox.paypal.com/graphql?GetCheckoutDetails'),
        headers: {
          'Content-Type': 'application/json',
          'x-app-name': 'standardcardfields',
        },
        body: json.encode({
          'query': '''
            query GetCheckoutDetails {
              checkoutSession {
                allowedCardIssuingCountries {
                  countryCode
                  countryName
                }
              }
            }
          ''',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null &&
            data['data']['checkoutSession'] != null &&
            data['data']['checkoutSession']['allowedCardIssuingCountries'] !=
                null) {
          final countries =
              data['data']['checkoutSession']['allowedCardIssuingCountries']
                  as List;

          setState(() {
            _countries = countries.map((country) {
              final code = country['countryCode'] as String;
              final name = country['countryName'] as String;
              // Get flag emoji based on country code
              final flag = _getCountryFlag(code);
              return {'code': code, 'name': name, 'flag': flag};
            }).toList();
          });

          _loadCountiesForCountry(_selectedCountry);
          return;
        }
      }

      // Fallback to mock data if API fails
      _loadMockCountries();
    } catch (e) {
      print('⚠️ Error loading countries from PayPal: $e');
      // Fallback to mock data
      _loadMockCountries();
    }
  }

  String _getCountryFlag(String countryCode) {
    // Convert country code to flag emoji
    const flagOffset = 0x1F1E6;
    const asciiOffset = 0x41;

    final firstChar = countryCode.toUpperCase().codeUnitAt(0);
    final secondChar = countryCode.toUpperCase().codeUnitAt(1);

    return String.fromCharCode(flagOffset + firstChar - asciiOffset) +
        String.fromCharCode(flagOffset + secondChar - asciiOffset);
  }

  void _loadMockCountries() {
    // Fallback: Simulating API response with common countries
    setState(() {
      _countries = [
        {'code': 'GB', 'name': 'United Kingdom', 'flag': '🇬🇧'},
        {'code': 'US', 'name': 'United States', 'flag': '🇺🇸'},
        {'code': 'CA', 'name': 'Canada', 'flag': '🇨🇦'},
        {'code': 'AU', 'name': 'Australia', 'flag': '🇦🇺'},
        {'code': 'DE', 'name': 'Germany', 'flag': '🇩🇪'},
        {'code': 'FR', 'name': 'France', 'flag': '🇫🇷'},
        {'code': 'IT', 'name': 'Italy', 'flag': '🇮🇹'},
        {'code': 'ES', 'name': 'Spain', 'flag': '🇪🇸'},
        {'code': 'NL', 'name': 'Netherlands', 'flag': '🇳🇱'},
        {'code': 'SE', 'name': 'Sweden', 'flag': '🇸🇪'},
      ];
      _loadCountiesForCountry(_selectedCountry);
    });
  }

  Future<void> _loadCountiesForCountry(String countryCode) async {
    try {
      // Call PayPal GraphQL API to get counties/states for selected country
      final response = await http.post(
        Uri.parse(
          'https://www.sandbox.paypal.com/graphql?fetch_griffin_data_en_${countryCode.toLowerCase()}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-app-name': 'standardcardfields',
        },
        body: json.encode({
          'query': '''
            query GetRegions(\$countryCode: String!) {
              regions(countryCode: \$countryCode) {
                code
                name
              }
            }
          ''',
          'variables': {'countryCode': countryCode},
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data']['regions'] != null) {
          final regions = data['data']['regions'] as List;

          setState(() {
            _counties = regions
                .map((region) => region['name'] as String)
                .toList();

            // Reset selected county when country changes
            if (!_counties.contains(_selectedCounty)) {
              _selectedCounty = null;
            }
          });
          return;
        }
      }

      // Fallback to mock data if API fails
      _loadMockCounties(countryCode);
    } catch (e) {
      print('⚠️ Error loading counties from PayPal: $e');
      // Fallback to mock data
      _loadMockCounties(countryCode);
    }
  }

  void _loadMockCounties(String countryCode) {
    // Fallback: Simulating county/state data based on country
    if (countryCode == 'GB') {
      setState(() {
        _counties = [
          'Aberdeenshire',
          'Angus',
          'Argyll and Bute',
          'Bedfordshire',
          'Berkshire',
          'Bristol',
          'Buckinghamshire',
          'Cambridgeshire',
          'Cheshire',
          'Cornwall',
          'Cumbria',
          'Derbyshire',
          'Devon',
          'Dorset',
          'Durham',
          'East Sussex',
          'Essex',
          'Gloucestershire',
          'Greater London',
          'Greater Manchester',
          'Hampshire',
          'Hertfordshire',
          'Kent',
          'Lancashire',
          'Leicestershire',
          'Lincolnshire',
          'Merseyside',
          'Norfolk',
          'North Yorkshire',
          'Northamptonshire',
          'Nottinghamshire',
          'Oxfordshire',
          'Shropshire',
          'Somerset',
          'South Yorkshire',
          'Staffordshire',
          'Suffolk',
          'Surrey',
          'Tyne and Wear',
          'Warwickshire',
          'West Midlands',
          'West Sussex',
          'West Yorkshire',
          'Wiltshire',
          'Worcestershire',
        ];
      });
    } else if (countryCode == 'US') {
      setState(() {
        _counties = [
          'Alabama',
          'Alaska',
          'Arizona',
          'Arkansas',
          'California',
          'Colorado',
          'Connecticut',
          'Delaware',
          'Florida',
          'Georgia',
        ];
      });
    } else {
      setState(() {
        _counties = [];
      });
    }

    // Reset selected county when country changes
    if (!_counties.contains(_selectedCounty)) {
      _selectedCounty = null;
    }
  }

  Future<void> _handlePayPalPayment() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Step 1: Call backend create-order endpoint first
      final paypalController = Get.find<PaypalController>();
      print('🔵 PayPal Payment: Creating order via backend...');
      final orderResponse = await paypalController.createOrder(widget.amount);

      if (orderResponse == null || orderResponse.orderId.isEmpty) {
        throw Exception('Failed to create order from backend');
      }

      // Store the backend orderId
      _backendOrderId = orderResponse.orderId;
      print(
        '✅ PayPal Payment: Backend order created with OrderId: $_backendOrderId',
      );

      // Step 2: Get the approve URL from the response
      final approveUrl = orderResponse.approveUrl;

      if (approveUrl == null || approveUrl.isEmpty) {
        throw Exception('No approve URL found in order response');
      }

      print('✅ PayPal Payment: Approve URL: $approveUrl');

      // Step 3: Navigate to PayPal WebView with the approve URL
      setState(() {
        _isProcessing = false;
      });

      Get.to(
        () => PaypalWebViewScreen(
          planTitle: widget.planTitle,
          amount: widget.amount,
          orderId: _backendOrderId,
          approveUrl: approveUrl,
          onFinish: (transactionId) {
            _onPaymentSuccess(transactionId);
          },
        ),
      )?.then((_) {
        setState(() {
          _isProcessing = false;
        });
      });
    } catch (e) {
      print('❌ PayPal Payment Error: $e');
      setState(() {
        _isProcessing = false;
      });
      Get.snackbar(
        'Error',
        'Failed to start PayPal payment: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _capturePayment(String orderId) async {
    setState(() {
      _isCapturing = true;
      _showCardFieldsWebView = false; // Hide webview to show loading
    });

    print('🔍 DEBUG: Starting _capturePayment method');

    // Try multiple ways to get userId and token
    String userId = '';
    String token = '';

    // Method 0: Try cached credentials first (loaded during initState)
    if (_cachedUserId != null && _cachedUserId!.isNotEmpty) {
      userId = _cachedUserId!;
      token = _cachedToken ?? '';
      print('✅ Method 0 - Using CACHED credentials:');
      print('   userId: $userId');
      print('   token length: ${token.length}');
    }

    // Method 1: Try GetUserProfileService if cache is empty
    if (userId.isEmpty) {
      try {
        print('🔍 DEBUG: Attempting Method 1 - GetUserProfileService');
        final userProfileService = Get.find<GetUserProfileService>();
        print('🔍 DEBUG: GetUserProfileService retrieved');
        print('🔍 DEBUG: userInfo: ${userProfileService.userInfo}');

        if (userProfileService.userInfo != null) {
          userId = userProfileService.userInfo!.id;
          token = userProfileService.userInfo!.refreshToken;
          print('✅ Method 1 - GetUserProfileService SUCCESS:');
          print('   userId: $userId');
          print('   token length: ${token.length}');
        } else {
          print('⚠️ Method 1: userInfo is null');
        }
      } catch (e) {
        print('❌ Method 1 failed with exception: $e');
      }
    }

    // Method 2: If userId is still empty, try AuthStorageService from Get
    if (userId.isEmpty) {
      try {
        print(
          '🔍 DEBUG: Attempting Method 2 - AuthStorageService via Get.find',
        );
        final authStorageService = Get.find<AuthStorageService>();
        print('🔍 DEBUG: AuthStorageService retrieved');

        final storedUserId = await authStorageService.getUserId();
        final storedToken = await authStorageService.getRefreshToken();

        print('🔍 DEBUG: Retrieved from storage:');
        print('   userId: $storedUserId');
        print(
          '   token: ${storedToken != null ? "exists (${storedToken.length} chars)" : "null"}',
        );

        if (storedUserId != null && storedUserId.isNotEmpty) {
          userId = storedUserId;
        }
        if (storedToken != null && storedToken.isNotEmpty) {
          token = storedToken;
        }

        if (userId.isNotEmpty) {
          print('✅ Method 2 - AuthStorageService (Get.find) SUCCESS:');
          print('   userId: $userId');
          print('   token length: ${token.length}');
        } else {
          print('⚠️ Method 2: userId is still empty after retrieval');
        }
      } catch (e) {
        print('❌ Method 2 failed with exception: $e');
      }
    }

    // Method 3: If still empty, try direct SecureStorage access
    if (userId.isEmpty) {
      try {
        print(
          '🔍 DEBUG: Attempting Method 3 - Direct AuthStorageService instance',
        );
        final authService = AuthStorageService();

        final storedUserId = await authService.getUserId();
        final storedToken = await authService.getRefreshToken();

        print('🔍 DEBUG: Retrieved from direct storage:');
        print('   userId: $storedUserId');
        print(
          '   token: ${storedToken != null ? "exists (${storedToken.length} chars)" : "null"}',
        );

        if (storedUserId != null && storedUserId.isNotEmpty) {
          userId = storedUserId;
        }
        if (storedToken != null && storedToken.isNotEmpty) {
          token = storedToken;
        }

        if (userId.isNotEmpty) {
          print('✅ Method 3 - Direct AuthStorageService SUCCESS:');
          print('   userId: $userId');
          print('   token length: ${token.length}');
        } else {
          print('⚠️ Method 3: userId is still empty after retrieval');
        }
      } catch (e) {
        print('❌ Method 3 failed with exception: $e');
      }
    }

    // Final validation
    if (userId.isEmpty) {
      print('❌ CRITICAL: Unable to retrieve userId from any method');
      print('🔍 DEBUG: All methods exhausted. Current state:');
      print('   userId: "$userId" (empty: ${userId.isEmpty})');
      print(
        '   token: "${token.isEmpty ? "empty" : "exists (${token.length} chars)"}"',
      );

      setState(() {
        _isCapturing = false;
      });
      Get.snackbar(
        'Error',
        'Unable to retrieve user information. Please login again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Use the backend orderId that was stored when create-order was called
    final captureOrderId = _backendOrderId ?? orderId;

    print('');
    print('═════════════════════════════════════════════════════════');
    print('� CAPTURE PAYMENT REQUEST');
    print('═════════════════════════════════════════════════════════');
    print('🔵 API Endpoint: ${ApiConstants.paypal.captureOrder}');
    print('🔵 Method: POST');
    print('─────────────────────────────────────────────────────────');
    print('🔵 Headers:');
    print('   Content-Type: application/json');
    print(
      '   Authorization: Bearer ${token.isNotEmpty ? "${token.substring(0, 20)}..." : "EMPTY"}',
    );
    print('─────────────────────────────────────────────────────────');
    print('🔵 Request Body:');
    print('   OrderId: $captureOrderId');
    print('   UserId: $userId');
    print('   PlanId: ${widget.planId}');
    print('─────────────────────────────────────────────────────────');
    final requestBody = {
      "orderId": captureOrderId,
      "userId": userId,
      "planId": widget.planId,
    };
    print('🔵 Full JSON Request:');
    print(JsonEncoder.withIndent('  ').convert(requestBody));
    print('═════════════════════════════════════════════════════════');

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.paypal.captureOrder),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      );

      print('');
      print('═════════════════════════════════════════════════════════');
      print('📥 CAPTURE PAYMENT RESPONSE');
      print('═════════════════════════════════════════════════════════');
      print('✅ Status Code: ${response.statusCode}');
      print('─────────────────────────────────────────────────────────');
      print('✅ Response Headers:');
      response.headers.forEach((key, value) {
        print('   $key: $value');
      });
      print('─────────────────────────────────────────────────────────');
      print('✅ Response Body:');
      try {
        // Try to parse and pretty print JSON
        final responseJson = json.decode(response.body);
        print(JsonEncoder.withIndent('  ').convert(responseJson));
      } catch (_) {
        // If not valid JSON, print as is
        print(response.body);
      }
      print('═════════════════════════════════════════════════════════');
      print('');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Payment Captured Successfully');

        Get.snackbar(
          'Success',
          'Payment captured successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Navigate to Home Screen
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(() => const HomeScreen());
        });
      } else {
        print('');
        print('═════════════════════════════════════════════════════════');
        print('❌ CAPTURE PAYMENT FAILED');
        print('═════════════════════════════════════════════════════════');
        print('❌ Status Code: ${response.statusCode}');
        print('❌ Reason: ${response.reasonPhrase ?? "Unknown"}');
        print('❌ Response Body: ${response.body}');
        print('═════════════════════════════════════════════════════════');
        print('');
        throw Exception(
          'Failed to capture payment: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e, stackTrace) {
      print('');
      print('═════════════════════════════════════════════════════════');
      print('❌ CAPTURE PAYMENT EXCEPTION');
      print('═════════════════════════════════════════════════════════');
      print('❌ Error Type: ${e.runtimeType}');
      print('❌ Error Message: $e');
      print('─────────────────────────────────────────────────────────');
      print('❌ Stack Trace:');
      print(stackTrace.toString());
      print('═════════════════════════════════════════════════════════');
      print('');

      setState(() {
        _isCapturing = false;
      });
      Get.snackbar(
        'Error',
        'Failed to capture payment: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _handleDebitCardPayment() async {
    if (_showCardFieldsWebView) {
      // If already showing, hide it
      setState(() {
        _showCardFieldsWebView = false;
        _cardFieldsController = null;
      });
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Step 1: Call backend create-order endpoint first
      final paypalController = Get.find<PaypalController>();
      print('🔵 Card Payment: Creating order via backend...');
      final orderResponse = await paypalController.createOrder(widget.amount);

      if (orderResponse == null || orderResponse.orderId.isEmpty) {
        throw Exception('Failed to create order from backend');
      }

      // Store the backend orderId
      _backendOrderId = orderResponse.orderId;
      print(
        '✅ Card Payment: Backend order created with OrderId: $_backendOrderId',
      );

      // Step 2: Get access token for PayPal Sandbox
      final services = PaypalServices();
      print('🔵 Card Payment: Getting access token...');
      final accessToken = await services.getAccessToken();

      if (accessToken == null) {
        throw Exception('Failed to get Access Token');
      }

      print('✅ Card Payment: Access token received');

      // Store access token for later use
      final String paypalAccessToken = accessToken;

      // Step 3: Load the PayPal card fields webview with the orderId
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final sessionID = 'uid_${timestamp}_session';
      final buttonSessionID = 'uid_${timestamp}_button';

      // Construct the URL using the backend orderId
      final cardFieldsUrl =
          'https://www.sandbox.paypal.com/smart/card-fields'
          '?token=$_backendOrderId'
          '&sessionID=$sessionID'
          '&buttonSessionID=$buttonSessionID'
          '&locale.x=en_GB'
          '&commit=true'
          '&style.submitButton.display=true'
          '&hasShippingCallback=false'
          '&env=sandbox'
          '&country.x=US'
          '&sdkMeta=eyJ1cmwiOiJodHRwczovL3d3dy5wYXlwYWwuY29tL3Nkay9qcz9jbGllbnQtaWQ9QVhtd0wtbW50S0dxVEFiNl9EYVk1bzZxaDVSMFVUeHVNa3dESnNnVWxIVzcyVy14NXQ0U1pzZ1NOaTlYT2ZiR1lveGxBSGlYbFNzam5CX0wmY3VycmVuY3k9VVNEJmludGVudD1jYXB0dXJlJmRpc2FibGUtZnVuZGluZz1wYXlsYXRlcix2ZW5tbyIsImF0dHJzIjp7ImRhdGEtc2RrLWludGVncmF0aW9uLXNvdXJjZSI6ImJ1dHRvbi1mYWN0b3J5IiwiZGF0YS11aWQiOiJ1aWRfYWViamZudXNpdXhmbXNhZ3FtbGpodGNtdWd3YWRoIn19'
          '&disable-card=';

      print('🔵 Loading card fields URL: $cardFieldsUrl');

      // Initialize WebView controller
      final controller = WebViewController();

      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..addJavaScriptChannel(
          'PayPalPayment',
          onMessageReceived: (JavaScriptMessage message) async {
            print('✅ PayPalPayment Channel Message: ${message.message}');
            // User has submitted payment in the webview
            // Now we need to call confirm-payment-source endpoint
            await _confirmPaymentSource(_backendOrderId!, paypalAccessToken);
          },
        )
        ..addJavaScriptChannel(
          'PayPalClose',
          onMessageReceived: (JavaScriptMessage message) {
            // Handle close button click from WebView
            setState(() {
              _showCardFieldsWebView = false;
              _cardFieldsController = null;
            });
          },
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              print('🔵 Card Fields: Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('✅ Card Fields: Page finished loading: $url');

              // Inject JavaScript to intercept form submission
              controller.runJavaScript('''
                (function() {
                    // Intercept fetch requests for payment submission
                    var origFetch = window.fetch;
                    window.fetch = function(url, options) {
                        return origFetch.apply(this, arguments).then(function(response) {
                            if (url.toString().includes('graphql?fetch_credit_form_submit')) {
                                response.clone().json().then(function(data) {
                                    // Check for successful payment mutation
                                    if (data && data.data && data.data.approveGuestPaymentWithCreditCard) {
                                        // Send signal to Flutter
                                        window.PayPalPayment.postMessage(JSON.stringify(data));
                                    }
                                }).catch(function(e) { /* ignore json parse error */ });
                            }
                            return response;
                        });
                    };
                    
                    // Hide close button if exists
                    var style = document.createElement('style');
                    style.innerHTML = '.close-button { display: none !important; }'; 
                    document.head.appendChild(style);
                })();
              ''');

              // Inject JavaScript to detect close button clicks
              controller.runJavaScript('''
                setTimeout(function() {
                  var observer = new MutationObserver(function(mutations) {
                    var closeButtons = document.querySelectorAll('[aria-label*="close"], [aria-label*="Close"], button[class*="close"], a[class*="close"], .close-button, #close-button');
                    closeButtons.forEach(function(btn) {
                      btn.addEventListener('click', function(e) {
                        window.PayPalClose.postMessage('close');
                      });
                    });
                  });
                  observer.observe(document.body, { childList: true, subtree: true });
                  
                  // Initial check
                  var closeButtons = document.querySelectorAll('[aria-label*="close"], [aria-label*="Close"], button[class*="close"], a[class*="close"], .close-button, #close-button');
                  closeButtons.forEach(function(btn) {
                    btn.addEventListener('click', function(e) {
                      window.PayPalClose.postMessage('close');
                    });
                  });
                }, 1000);
              ''');
            },
            onWebResourceError: (WebResourceError error) {
              print('❌ Card Fields Error: ${error.description}');
            },
            onNavigationRequest: (NavigationRequest request) {
              print('🔵 Navigation request: ${request.url}');

              // Check for success/cancel URLs
              if (request.url.contains('return.example.com')) {
                // Payment flow completed, will be handled by JS channel
                return NavigationDecision.prevent;
              }

              if (request.url.contains('cancel.example.com')) {
                setState(() {
                  _showCardFieldsWebView = false;
                  _cardFieldsController = null;
                });
                Get.snackbar(
                  'Cancelled',
                  'Payment was cancelled',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(cardFieldsUrl));

      setState(() {
        _cardFieldsController = controller;
        _showCardFieldsWebView = true;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      print('❌ Error initiating card payment: $e');
      Get.snackbar(
        'Error',
        'Failed to initiate payment. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _confirmPaymentSource(String orderId, String accessToken) async {
    setState(() {
      _isCapturing = true;
      _showCardFieldsWebView = false; // Hide webview to show loading
    });

    try {
      print('🔵 Confirming payment source for order: $orderId');

      // Prepare payment source data (with sample card data for testing)
      final paymentSourceData = {
        "card": {
          "number": "4032037064388131",
          "expiry": "2035-12",
          "name": "John Doe",
          "billing_address": {
            "address_line_1": "2211 N First Street",
            "address_line_2": "17.3.160",
            "admin_area_1": "CA",
            "admin_area_2": "San Jose",
            "postal_code": "95131",
            "country_code": "US",
          },
          "attributes": {
            "verification": {"method": "SCA_WHEN_REQUIRED"},
          },
        },
      };

      final services = PaypalServices();
      final response = await services.confirmPaymentSource(
        orderId: orderId,
        accessToken: accessToken,
        paymentSource: paymentSourceData,
      );

      if (response == null) {
        throw Exception('Failed to confirm payment source');
      }

      print('✅ Payment source confirmed successfully');
      print('🔵 Response: ${json.encode(response)}');

      // Parse the response
      final confirmResponse = PaypalConfirmPaymentResponse.fromJson(response);

      // Check if status requires payer action (3D Secure)
      if (confirmResponse.status == 'PAYER_ACTION_REQUIRED') {
        print('🔵 Payer action required - opening 3D Secure verification');

        // Find the payer-action link
        final payerActionLink = confirmResponse.links.firstWhere(
          (link) => link.rel == 'payer-action',
          orElse: () => PaypalLink(href: '', rel: '', method: ''),
        );

        if (payerActionLink.href.isNotEmpty) {
          // Open 3D Secure verification in webview
          await _handle3DSecure(payerActionLink.href, orderId, accessToken);
        } else {
          throw Exception('Payer action link not found');
        }
      } else {
        // Payment confirmed, proceed to capture
        await _capturePayment(orderId);
      }
    } catch (e) {
      print('❌ Error confirming payment source: $e');
      setState(() {
        _isCapturing = false;
      });
      Get.snackbar(
        'Error',
        'Failed to confirm payment. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _handle3DSecure(
    String verificationUrl,
    String orderId,
    String accessToken,
  ) async {
    print('🔵 Loading 3D Secure verification URL: $verificationUrl');

    // Create a new webview for 3D Secure
    final controller = WebViewController();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('🔵 3D Secure: Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('✅ 3D Secure: Page finished loading: $url');

            // Check if verification is complete
            if (url.contains('success') || url.contains('complete')) {
              print('✅ 3D Secure verification completed');
              // Proceed to capture payment
              _capturePayment(orderId);
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('❌ 3D Secure Error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            print('🔵 3D Secure navigation: ${request.url}');

            // Check for completion signals
            if (request.url.contains('success') ||
                request.url.contains('complete') ||
                request.url.contains('return.example.com')) {
              // Verification complete, proceed to capture
              Future.delayed(const Duration(milliseconds: 500), () {
                _capturePayment(orderId);
              });
              return NavigationDecision.prevent;
            }

            if (request.url.contains('cancel') ||
                request.url.contains('error')) {
              setState(() {
                _isCapturing = false;
                _showCardFieldsWebView = false;
              });
              Get.snackbar(
                'Cancelled',
                '3D Secure verification was cancelled',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(verificationUrl));

    // Show the 3D Secure webview
    setState(() {
      _cardFieldsController = controller;
      _showCardFieldsWebView = true;
    });
  }

  void _onPaymentSuccess(String transactionId) {
    setState(() {
      _isProcessing = false;
    });

    // Payment completed successfully
    Get.snackbar(
      'Payment Completed',
      'Payment succeeded for ${widget.planTitle}!\nTransaction ID: $transactionId',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    // Navigate back to plan pricing screen after delay
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(() => PlanPricingScreen());
    });
  }

  Future<void> _processCardPayment() async {
    // Validate all fields
    if (_cardNumberController.text.isEmpty ||
        _expiryController.text.isEmpty ||
        _cvvController.text.isEmpty ||
        _firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _address1Controller.text.isEmpty ||
        _cityController.text.isEmpty ||
        _postcodeController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isCardPaymentProcessing = true;
    });

    // TODO: Implement PayPal GraphQL API call
    // For now, simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isCardPaymentProcessing = false;
    });

    Get.snackbar(
      'Payment Processing',
      'Card payment functionality will be implemented with PayPal GraphQL API',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header - Payment title
                  const Text(
                    'Payment',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0070BA),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  const Text(
                    'Complete your secure payment using our trusted\npayment methods.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF2C2C2C),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Pay with PayPal section
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Pay with PayPal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // PayPal Button (Yellow)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _handlePayPalPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC439),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 0,
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Color(0xFF003087),
                                ),
                              ),
                            )
                          : Image.asset(
                              'assets/images/paypal_logo.png',
                              height: 24,
                              errorBuilder: (context, error, stackTrace) {
                                return const Text(
                                  'PayPal',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF003087),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Debit or Credit Card Button (Black)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleDebitCardPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C2E2F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: const Icon(
                              Icons.credit_card,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Debit or Credit Card',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // PayPal Card Fields WebView (Inline) - Below the button, full width
            if (_showCardFieldsWebView && _cardFieldsController != null)
              Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1500, // Increased height to avoid internal scroll
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: WebViewWidget(controller: _cardFieldsController!),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),

            // Loading Indicator for Capture
            if (_isCapturing)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF0070BA),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Processing Payment...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Card Payment Form (Expandable)
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: _showCardForm
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: const SizedBox.shrink(),
                    secondChild: _buildCardPaymentForm(),
                  ),

                  const SizedBox(height: 8),

                  // Summary Section
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment Details
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Payment Details:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Plan ID
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '•  ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(text: 'Plan ID: '),
                                TextSpan(
                                  text:
                                      widget.orderId ??
                                      '68f5d69263f7f2594042c309',
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Charges info
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '•  ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Charges include Applicable VAT/GST and/or Sales Taxes',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Total Amount
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                        bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '\$${widget.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0070BA),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Safe & secure payment
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Safe & secure payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Description text
                  const Text(
                    'Your payment information is processed securely. We do not store your credit card details.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF4A4A4A),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Payment method icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Visa/Mastercard
                      Container(
                        width: 70,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1A1F71), Color(0xFFED1C24)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/visa_card.png',
                            height: 30,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.credit_card,
                                color: Colors.white,
                                size: 24,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // PayPal
                      Container(
                        width: 70,
                        height: 45,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xFFE0E0E0),
                            width: 1,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/paypal_logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                'PP',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0070BA),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Generic Card
                      Container(
                        width: 70,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF79E1B), Color(0xFFFF6B00)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.credit_card,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Security Badge
                      Container(
                        width: 70,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0070BA),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.security,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardPaymentForm() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 24),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showCardForm = false;
                  });
                },
                icon: const Icon(Icons.close, size: 24),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Card Number
          TextField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Card number',
              hintStyle: const TextStyle(color: Color(0xFF999999)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Expiry and CVV
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiryController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    hintText: 'Expires',
                    hintStyle: const TextStyle(color: Color(0xFF999999)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Security code',
                    hintStyle: const TextStyle(color: Color(0xFF999999)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Billing address header
          Row(
            children: [
              const Text(
                'Billing address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              // Country flag and dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCCCCCC)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Text(
                      _countries.firstWhere(
                            (c) => c['code'] == _selectedCountry,
                            orElse: () => {'flag': '�'},
                          )['flag'] ??
                          '🌍',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 4),
                    DropdownButton<String>(
                      value: _selectedCountry,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                      items: _countries.isEmpty
                          ? [
                              const DropdownMenuItem(
                                value: 'GB',
                                child: Text(''),
                              ),
                            ]
                          : _countries.map((country) {
                              return DropdownMenuItem<String>(
                                value: country['code'],
                                child: Row(
                                  children: [
                                    Text(
                                      country['flag'] ?? '🌍',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      country['name'] ?? '',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCountry = value ?? 'GB';
                          _loadCountiesForCountry(_selectedCountry);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // First name and Last name
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    hintText: 'First name',
                    hintStyle: const TextStyle(color: Color(0xFF999999)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    hintText: 'Last name',
                    hintStyle: const TextStyle(color: Color(0xFF999999)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Address line 1
          TextField(
            controller: _address1Controller,
            decoration: InputDecoration(
              hintText: 'Address line 1',
              hintStyle: const TextStyle(color: Color(0xFF999999)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Address line 2
          TextField(
            controller: _address2Controller,
            decoration: InputDecoration(
              hintText: 'Address line 2',
              hintStyle: const TextStyle(color: Color(0xFF999999)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Town/City
          TextField(
            controller: _cityController,
            decoration: InputDecoration(
              hintText: 'Town/City',
              hintStyle: const TextStyle(color: Color(0xFF999999)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // County (Optional) - Dropdown
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFCCCCCC)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedCounty,
              decoration: const InputDecoration(
                hintText: 'County (Optional)',
                hintStyle: TextStyle(color: Color(0xFF999999)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down),
              isExpanded: true,
              items: [
                if (_counties.isEmpty)
                  const DropdownMenuItem<String>(
                    value: '',
                    child: Text(
                      'County (Optional)',
                      style: TextStyle(color: Color(0xFF999999)),
                    ),
                  ),
                ..._counties.map((county) {
                  return DropdownMenuItem<String>(
                    value: county,
                    child: Text(county),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCounty = value;
                });
              },
            ),
          ),
          const SizedBox(height: 12),

          // Postcode
          TextField(
            controller: _postcodeController,
            decoration: InputDecoration(
              hintText: 'Postcode',
              hintStyle: const TextStyle(color: Color(0xFF999999)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Mobile
          TextField(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Mobile',
              hintStyle: const TextStyle(color: Color(0xFF999999)),
              prefixText: '+44  ',
              prefixStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Email
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: const TextStyle(color: Color(0xFF999999)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Deliver to billing address checkbox
          Row(
            children: [
              Checkbox(
                value: _deliverToBillingAddress,
                onChanged: (value) {
                  setState(() {
                    _deliverToBillingAddress = value ?? true;
                  });
                },
                activeColor: const Color(0xFF0070BA),
              ),
              const Expanded(
                child: Text(
                  'Deliver to billing address',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Terms and conditions
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
                height: 1.4,
              ),
              children: [
                const TextSpan(text: 'You acknowledge the '),
                TextSpan(
                  text: 'terms',
                  style: const TextStyle(
                    color: Color(0xFF0070BA),
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(
                  text:
                      ' of the service PayPal provides to the seller and agree to the ',
                ),
                TextSpan(
                  text: 'Privacy Statement',
                  style: const TextStyle(
                    color: Color(0xFF0070BA),
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: '. No PayPal account required.'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Pay button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isCardPaymentProcessing ? null : _processCardPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0070BA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              child: _isCardPaymentProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Text(
                      'Pay \$${widget.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),

          // Powered by PayPal
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Powered by ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6C6C6C),
                ),
              ),
              Image.asset(
                'assets/images/paypal_logo.png',
                height: 14,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'PayPal',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0070BA),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
