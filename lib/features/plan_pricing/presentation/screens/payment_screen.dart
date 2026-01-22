import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:karlfive/core/network/services/auth_storage_service.dart';
import 'package:karlfive/core/services/get_user_profile_service.dart';
import 'package:karlfive/features/plan_pricing/presentation/screens/paypal_webview_screen.dart';
import 'package:karlfive/features/plan_pricing/presentation/screens/paypal_webview_screen.dart';
import 'package:karlfive/features/plan_pricing/presentation/screens/plan_pricing_screen.dart';
import 'package:karlfive/features/Home/presentation/screen/home_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:karlfive/core/network/constants/api_constants.dart';
import '../controllers/paypal_controller.dart';
import '../services/paypal_services.dart';

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
  String? _currentPayPalOrderId;
  String? _backendOrderId; // Store the orderId from backend create-order endpoint
  String? _cardFieldsUrl;
  WebViewController? _cardFieldsController;

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
  bool _isLoadingCountries = false;

  @override
  void initState() {
    super.initState();
    _loadCountries();
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
    setState(() {
      _isLoadingCountries = true;
    });

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
            _isLoadingCountries = false;
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
      _isLoadingCountries = false;
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
      print('✅ PayPal Payment: Backend order created with OrderId: $_backendOrderId');

      // Step 2: Continue with the existing PayPal flow
      if (Platform.isAndroid) {
        final userProfileService = Get.find<GetUserProfileService>();
        final userId = userProfileService.userInfo?.id ?? '';
        
        await paypalController.startNativePayment(
          amount: widget.amount,
          userId: userId,
          planId: widget.planId ?? '',
          seasonId: null, // Optional: Add seasonId if available
          onSuccess: (orderId) {
            setState(() {
              _isProcessing = false;
            });
            
            // Show success snackbar
            Get.snackbar(
              'Success',
              'Payment completed successfully!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
            
            // Navigate to Home Screen
            Future.delayed(const Duration(seconds: 2), () {
              Get.offAll(() => const HomeScreen());
            });
          },
          onError: (error) {
            setState(() {
              _isProcessing = false;
            });
            Get.snackbar(
              'PayPal Error',
              error,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          },
        );
      } else {
        // Navigate to PayPal WebView for payment (iOS / Web fallback)
        Get.to(
          () => PaypalWebViewScreen(
            planTitle: widget.planTitle,
            amount: widget.amount,
            orderId: widget.orderId,
            onFinish: (transactionId) {
              _onPaymentSuccess(transactionId);
            },
          ),
        )?.then((_) {
          setState(() {
            _isProcessing = false;
          });
        });
      }
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

    // Try multiple ways to get userId
    String userId = '';
    String token = '';
    
    // Method 1: Try GetUserProfileService first
    try {
      final userProfileService = Get.find<GetUserProfileService>();
      userId = userProfileService.userInfo?.id ?? '';
      token = userProfileService.userInfo?.refreshToken ?? '';
      print('🔵 Method 1 - GetUserProfileService: userId=$userId');
    } catch (e) {
      print('⚠️ Method 1 failed: $e');
    }
    
    // Method 2: If userId is still empty, try AuthStorageService
    if (userId.isEmpty) {
      try {
        final authStorageService = Get.find<AuthStorageService>();
        userId = await authStorageService.getUserId() ?? '';
        token = await authStorageService.getRefreshToken() ?? '';
        print('🔵 Method 2 - AuthStorageService: userId=$userId');
      } catch (e) {
        print('⚠️ Method 2 failed: $e');
      }
    }
    
    // Method 3: If still empty, try direct SecureStorage access
    if (userId.isEmpty) {
      try {
        final authService = AuthStorageService();
        userId = await authService.getUserId() ?? '';
        token = await authService.getRefreshToken() ?? '';
        print('🔵 Method 3 - Direct AuthStorageService: userId=$userId');
      } catch (e) {
        print('⚠️ Method 3 failed: $e');
      }
    }

    // Use the backend orderId that was stored when create-order was called
    final captureOrderId = _backendOrderId ?? orderId;
    
    print('═════════════════════════════════════════════════════════');
    print('🔵 API Endpoint: {{base_url}}/payments/paypal/capture-order');
    print('═════════════════════════════════════════════════════════');
    print('🔵 Request Model:');
    print('   OrderId: $captureOrderId');
    print('   UserId: $userId');
    print('   PlanId: ${widget.planId}');
    print('   Full Request: ${json.encode({
      "orderId": captureOrderId,
      "userId": userId,
      "planId": widget.planId,
    })}');
    print('─────────────────────────────────────────────────────────');

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.paypal.captureOrder),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "orderId": captureOrderId,
          "userId": userId,
          "planId": widget.planId,
        }),
      );

      print('✅ API Response - Capture Payment:');
      print('   Status Code: ${response.statusCode}');
      print('   Response Body: ${response.body}');
      print('═════════════════════════════════════════════════════════');

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
        throw Exception('Failed to capture payment: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API Response - Exception:');
      print('   Error: $e');
      print('═════════════════════════════════════════════════════════');
      setState(() {
        _isCapturing = false;
      });
      Get.snackbar(
        'Error',
        'Failed to capture payment. Please contact support.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Map<String, dynamic> _getOrderParams() {
    String totalAmount = widget.amount.toStringAsFixed(2);
    String subTotalAmount = widget.amount.toStringAsFixed(2);
    String shippingCost = '0';

    List items = [
      {
        "name": widget.planTitle,
        "quantity": 1,
        "price": widget.amount.toStringAsFixed(2),
        "currency": "USD",
      },
    ];

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": "USD",
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": "0",
            },
          },
          "description": "Payment for ${widget.planTitle} subscription",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE",
          },
          "item_list": {"items": items},
        },
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {
        "return_url": "return.example.com",
        "cancel_url": "cancel.example.com"
      },
    };
    return temp;
  }

  Future<void> _handleDebitCardPayment() async {
    if (_showCardFieldsWebView) {
      // If already showing, hide it
      setState(() {
        _showCardFieldsWebView = false;
        _cardFieldsUrl = null;
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
      print('✅ Card Payment: Backend order created with OrderId: $_backendOrderId');
      
      // Step 2: Continue with existing PayPal card payment flow
      final services = PaypalServices();
      print('🔵 Card Payment: Getting access token...');
      final accessToken = await services.getAccessToken();
      
      if (accessToken != null) {
        print('✅ Card Payment: Access token received');
        final transactions = _getOrderParams();
        print('🔵 Card Payment: Creating PayPal payment...');
        final res = await services.createPaypalPayment(transactions, accessToken);
        
        if (res != null && res['token'] != null && res['token']!.isNotEmpty) {
           String token = res['token']!;
           _currentPayPalOrderId = token; // Store PayPal token
           print('✅ Card Payment: PayPal token received: $token');
            
           // Generate session IDs
           final timestamp = DateTime.now().millisecondsSinceEpoch;
           final sessionID = 'uid_${timestamp}_session';
           final buttonSessionID = 'uid_${timestamp}_button';

           // Construct the URL with the exact parameters from requirements
           final cardFieldsUrl =
              'https://www.sandbox.paypal.com/smart/card-fields'
              '?token=$token'
              '&sessionID=$sessionID'
              '&buttonSessionID=$buttonSessionID'
              '&locale.x=en_GB'
              '&commit=true'
              '&style.submitButton.display=true'
              '&hasShippingCallback=false'
              '&env=sandbox'
              '&country.x=GB'
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
              onMessageReceived: (JavaScriptMessage message) {
                print('✅ PayPalPayment Channel Message: ${message.message}');
                // We received a success signal from our injected JS
                // Navigate to capture payment
                // Use the stored token/orderId
                if (_currentPayPalOrderId != null) {
                   _capturePayment(_currentPayPalOrderId!);
                }
              },
            )
            ..addJavaScriptChannel(
              'PayPalClose',
              onMessageReceived: (JavaScriptMessage message) {
                // Handle close button click from WebView
                setState(() {
                  _showCardFieldsWebView = false;
                  _cardFieldsUrl = null;
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
                  
                  // Inject JavaScript to intercept GraphQL requests
                  controller.runJavaScript('''
                    (function() {
                        var origFetch = window.fetch;
                        window.fetch = function(url, options) {
                            return origFetch.apply(this, arguments).then(function(response) {
                                if (url.toString().includes('graphql?fetch_credit_form_submit')) {
                                     response.clone().json().then(function(data) {
                                        // Check for successful payment mutation
                                        if (data && data.data && data.data.approveGuestPaymentWithCreditCard) {
                                            // Send whole data or just a success signal
                                            window.PayPalPayment.postMessage(JSON.stringify(data));
                                        }
                                     }).catch(function(e) { /* ignore json parse error */ });
                                }
                                return response;
                            });
                        };
                        
                        // Also try to hide the close button if possible to force flow completion
                        var style = document.createElement('style');
                        style.innerHTML = '.close-button { display: none !important; }'; 
                        document.head.appendChild(style);
                    })();
                  ''');

                  // Inject JavaScript to detect close button clicks
                  controller.runJavaScript('''
                    // Try to find and intercept close/cancel button clicks
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
                  
                  // Check for success/cancel URLs logic (similar to PaypalWebViewScreen)
                  if (request.url.contains('return.example.com')) {
                     // Handle success!
                     // The token/orderId was used to create the session. 
                     // In the web flow, we often capture using the OrderID we created initially.
                     // The token passed to the URL is the OrderID (or related to it).
                     // We extracted 'token' in _handleDebitCardPayment which was used as the OrderID in create-order response.
                     // We should pass THAT orderId (token) to capture.
                     // IMPORTANT: We need access to the 'token' variable from the outer scope here.
                     // Since we can't easily access local variable 'token' here without modifying structure,
                     // We will rely on extracting it from the URL if present, or better: 
                     // Store the 'currentOrderId' in the class state when we create it.
                     
                     // For now, let's assume we need to store it. 
                     // But wait, allow me to just call _capturePayment with the token we have.
                     // Ah, I cannot access 'token' from inside this callback easily if it's local.
                     // I will update the state to store _currentPayPalOrderId.
                     _capturePayment(_currentPayPalOrderId ?? '');
                     return NavigationDecision.prevent;
                  }
                  
                  if (request.url.contains('cancel.example.com')) {
                    setState(() {
                      _showCardFieldsWebView = false;
                      _cardFieldsUrl = null;
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
            _cardFieldsUrl = cardFieldsUrl;
            _cardFieldsController = controller;
            _showCardFieldsWebView = true;
            _isProcessing = false;
          });
        } else {
          throw Exception('Failed to get payment token from PayPal');
        }
      } else {
        throw Exception('Failed to get Access Token');
      }
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
                          border: Border.all(color: Colors.white, width: 1.5),
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
                      child: WebViewWidget(
                        controller: _cardFieldsController!,
                      ),
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
                       valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0070BA)),
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
                                  widget.orderId ?? '68f5d69263f7f2594042c309',
                              style: const TextStyle(fontFamily: 'monospace'),
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
