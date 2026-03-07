import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../../../core/services/get_user_profile_service.dart';
import '../../../plan_pricing/data/models/paypal_confirm_payment_response.dart';
import '../../../plan_pricing/presentation/controllers/paypal_controller.dart';
import '../../../plan_pricing/presentation/services/paypal_services.dart';
import 'paypal_webview_screen.dart';
import 'plan_pricing_screen(company).dart';

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
  String? _backendOrderId;
  WebViewController? _cardFieldsController;

  // For company flow we use companyId (sent as 'userId' in capture body)
  String? _cachedCompanyId;
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
  String _selectedCountry = 'GB';
  String? _selectedCounty;

  List<Map<String, String>> _countries = [];
  List<String> _counties = [];

  @override
  void initState() {
    super.initState();
    _loadCountries();
    _loadCompanyCredentials().then((_) {
      print('✅ [Company PaymentScreen] Company credentials loaded');
    });
  }

  // ─── Load company ID ────────────────────────────────────────────────────────

  Future<void> _loadCompanyCredentials() async {
    print('🔍 [Company PaymentScreen] Loading company credentials...');

    // Use AuthStorageService — same source as plan_pricing userId
    try {
      final authService = AuthStorageService();
      final storedId = await authService.getUserId();
      if (storedId != null && storedId.isNotEmpty) {
        _cachedCompanyId = storedId;
        print('✅ [Company] AuthStorageService: companyId=$_cachedCompanyId');
        return;
      }
    } catch (e) {
      print('⚠️ [Company] AuthStorageService failed: $e');
    }

    // Fallback: GetUserProfileService
    try {
      final userProfileService = Get.find<GetUserProfileService>();
      final id = userProfileService.userInfo?.id ?? '';
      if (id.isNotEmpty) {
        _cachedCompanyId = id;
        print('✅ [Company] GetUserProfileService fallback: id=$_cachedCompanyId');
        return;
      }
    } catch (e) {
      print('⚠️ [Company] GetUserProfileService failed: $e');
    }

    if (_cachedCompanyId == null || _cachedCompanyId!.isEmpty) {
      print('❌ [Company PaymentScreen] WARNING: Could not load companyId!');
    }
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

  // ─── Countries / Counties ───────────────────────────────────────────────────

  Future<void> _loadCountries() async {
    try {
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
            _countries = countries.map((c) {
              final code = c['countryCode'] as String;
              final name = c['countryName'] as String;
              return {
                'code': code,
                'name': name,
                'flag': _getCountryFlag(code),
              };
            }).toList();
          });
          _loadCountiesForCountry(_selectedCountry);
          return;
        }
      }
      _loadMockCountries();
    } catch (e) {
      _loadMockCountries();
    }
  }

  String _getCountryFlag(String countryCode) {
    const flagOffset = 0x1F1E6;
    const asciiOffset = 0x41;
    final first = countryCode.toUpperCase().codeUnitAt(0);
    final second = countryCode.toUpperCase().codeUnitAt(1);
    return String.fromCharCode(flagOffset + first - asciiOffset) +
        String.fromCharCode(flagOffset + second - asciiOffset);
  }

  void _loadMockCountries() {
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
            _counties = regions.map((r) => r['name'] as String).toList();
            if (!_counties.contains(_selectedCounty)) _selectedCounty = null;
          });
          return;
        }
      }
      _loadMockCounties(countryCode);
    } catch (e) {
      _loadMockCounties(countryCode);
    }
  }

  void _loadMockCounties(String countryCode) {
    if (countryCode == 'GB') {
      setState(() {
        _counties = [
          'Aberdeenshire', 'Angus', 'Argyll and Bute', 'Bedfordshire',
          'Berkshire', 'Bristol', 'Buckinghamshire', 'Cambridgeshire',
          'Cheshire', 'Cornwall', 'Cumbria', 'Derbyshire', 'Devon', 'Dorset',
          'Durham', 'East Sussex', 'Essex', 'Gloucestershire', 'Greater London',
          'Greater Manchester', 'Hampshire', 'Hertfordshire', 'Kent',
          'Lancashire', 'Leicestershire', 'Lincolnshire', 'Merseyside',
          'Norfolk', 'North Yorkshire', 'Northamptonshire', 'Nottinghamshire',
          'Oxfordshire', 'Shropshire', 'Somerset', 'South Yorkshire',
          'Staffordshire', 'Suffolk', 'Surrey', 'Tyne and Wear', 'Warwickshire',
          'West Midlands', 'West Sussex', 'West Yorkshire', 'Wiltshire',
          'Worcestershire',
        ];
      });
    } else if (countryCode == 'US') {
      setState(() {
        _counties = [
          'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado',
          'Connecticut', 'Delaware', 'Florida', 'Georgia',
        ];
      });
    } else {
      setState(() {
        _counties = [];
      });
    }
    if (!_counties.contains(_selectedCounty)) _selectedCounty = null;
  }

  // ─── PayPal Button Flow ──────────────────────────────────────────────────────

  Future<void> _handlePayPalPayment() async {
    setState(() => _isProcessing = true);

    try {
      final paypalController = Get.find<PaypalController>();
      print('🔵 [Company PayPal]: Creating order via backend...');
      final orderResponse = await paypalController.createOrder(widget.amount);

      if (orderResponse == null || orderResponse.orderId.isEmpty) {
        throw Exception('Failed to create order from backend');
      }

      _backendOrderId = orderResponse.orderId;
      print('✅ [Company PayPal]: OrderId: $_backendOrderId');

      final approveUrl = orderResponse.approveUrl;
      if (approveUrl == null || approveUrl.isEmpty) {
        throw Exception('No approve URL found in order response');
      }

      setState(() => _isProcessing = false);

      Get.to(
        () => CompanyPaypalWebViewScreen(
          planTitle: widget.planTitle,
          amount: widget.amount,
          orderId: _backendOrderId,
          approveUrl: approveUrl,
          onFinish: (transactionId) {
            _onPaymentSuccess(transactionId);
          },
        ),
      )?.then((_) => setState(() => _isProcessing = false));
    } catch (e) {
      print('❌ [Company PayPal] Error: $e');
      setState(() => _isProcessing = false);
      Get.snackbar(
        'Error',
        'Failed to start PayPal payment: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ─── Capture Payment (sends companyId as 'userId') ──────────────────────────

  Future<void> _capturePayment(String orderId) async {
    setState(() {
      _isCapturing = true;
      _showCardFieldsWebView = false;
    });

    print('🔍 [Company] Starting _capturePayment...');

    String companyId = _cachedCompanyId ?? '';
    String token = _cachedToken ?? '';

    // Re-try from AuthStorageService if cache is empty
    if (companyId.isEmpty) {
      try {
        final authService = AuthStorageService();
        companyId = await authService.getUserId() ?? '';
        print('✅ [Company] Re-fetched companyId: $companyId');
      } catch (e) {
        print('⚠️ [Company] Re-fetch from AuthStorageService failed: $e');
      }
    }

    // Last resort token fallback
    if (token.isEmpty) {
      try {
        final userProfileService = Get.find<GetUserProfileService>();
        token = userProfileService.userInfo?.refreshToken ?? '';
      } catch (_) {}
    }

    if (companyId.isEmpty) {
      print('❌ [Company] CRITICAL: companyId not found');
      setState(() => _isCapturing = false);
      Get.snackbar(
        'Error',
        'Unable to retrieve company information. Please login again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final captureOrderId = _backendOrderId ?? orderId;

    print('');
    print('═════════════════════════════════════════════════════════');
    print('🏢 COMPANY CAPTURE PAYMENT REQUEST');
    print('═════════════════════════════════════════════════════════');
    print('🔵 API Endpoint: ${ApiConstants.paypal.captureOrder}');
    print('🔵 OrderId: $captureOrderId');
    print('🔵 CompanyId (as userId): $companyId');
    print('🔵 PlanId: ${widget.planId}');
    print('═════════════════════════════════════════════════════════');

    // Backend expects 'userId' key — value is companyId for company flow
    final requestBody = {
      "orderId": captureOrderId,
      "userId": companyId,
      "planId": widget.planId,
    };

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.paypal.captureOrder),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      );

      print('📥 [Company] Capture Response: ${response.statusCode}');
      try {
        print(JsonEncoder.withIndent('  ').convert(json.decode(response.body)));
      } catch (_) {
        print(response.body);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ [Company] Payment Captured Successfully');
        Get.snackbar(
          'Success',
          'Payment captured successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(() => const PlanPricingScreen());
        });
      } else {
        throw Exception(
          'Failed to capture payment: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e, stackTrace) {
      print('❌ [Company] Capture Exception: $e');
      print(stackTrace.toString());
      setState(() => _isCapturing = false);
      Get.snackbar(
        'Error',
        'Failed to capture payment: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ─── Debit/Credit Card Flow ──────────────────────────────────────────────────

  Future<void> _handleDebitCardPayment() async {
    if (_showCardFieldsWebView) {
      setState(() {
        _showCardFieldsWebView = false;
        _cardFieldsController = null;
      });
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final paypalController = Get.find<PaypalController>();
      print('🔵 [Company Card]: Creating order via backend...');
      final orderResponse = await paypalController.createOrder(widget.amount);

      if (orderResponse == null || orderResponse.orderId.isEmpty) {
        throw Exception('Failed to create order from backend');
      }

      _backendOrderId = orderResponse.orderId;
      print('✅ [Company Card]: OrderId: $_backendOrderId');

      final services = PaypalServices();
      print('🔵 [Company Card]: Getting access token...');
      final accessToken = await services.getAccessToken();
      if (accessToken == null) throw Exception('Failed to get Access Token');

      print('✅ [Company Card]: Access token received');

      final String paypalAccessToken = accessToken;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final sessionID = 'uid_${timestamp}_session';
      final buttonSessionID = 'uid_${timestamp}_button';

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

      print('🔵 [Company Card]: Loading card fields URL: $cardFieldsUrl');

      final controller = WebViewController();
      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..addJavaScriptChannel(
          'PayPalPayment',
          onMessageReceived: (JavaScriptMessage message) async {
            print(
              '✅ [Company Card] PayPalPayment Channel: ${message.message}',
            );
            await _confirmPaymentSource(_backendOrderId!, paypalAccessToken);
          },
        )
        ..addJavaScriptChannel(
          'PayPalClose',
          onMessageReceived: (JavaScriptMessage message) {
            setState(() {
              _showCardFieldsWebView = false;
              _cardFieldsController = null;
            });
          },
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) =>
                print('🔵 [Company Card Fields]: Page started: $url'),
            onPageFinished: (String url) {
              print('✅ [Company Card Fields]: Page finished: $url');
              controller.runJavaScript('''
                (function() {
                    var origFetch = window.fetch;
                    window.fetch = function(url, options) {
                        return origFetch.apply(this, arguments).then(function(response) {
                            if (url.toString().includes('graphql?fetch_credit_form_submit')) {
                                response.clone().json().then(function(data) {
                                    if (data && data.data && data.data.approveGuestPaymentWithCreditCard) {
                                        window.PayPalPayment.postMessage(JSON.stringify(data));
                                    }
                                }).catch(function(e) {});
                            }
                            return response;
                        });
                    };
                    var style = document.createElement('style');
                    style.innerHTML = '.close-button { display: none !important; }';
                    document.head.appendChild(style);
                })();
              ''');
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
                  var closeButtons = document.querySelectorAll('[aria-label*="close"], [aria-label*="Close"], button[class*="close"], a[class*="close"], .close-button, #close-button');
                  closeButtons.forEach(function(btn) {
                    btn.addEventListener('click', function(e) {
                      window.PayPalClose.postMessage('close');
                    });
                  });
                }, 1000);
              ''');
            },
            onWebResourceError: (WebResourceError error) =>
                print('❌ [Company Card Fields] Error: ${error.description}'),
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.contains('return.example.com')) {
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
      setState(() => _isProcessing = false);
      print('❌ [Company Card] Error: $e');
      Get.snackbar(
        'Error',
        'Failed to initiate payment. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _confirmPaymentSource(
    String orderId,
    String accessToken,
  ) async {
    setState(() {
      _isCapturing = true;
      _showCardFieldsWebView = false;
    });

    try {
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

      if (response == null) throw Exception('Failed to confirm payment source');

      print('✅ [Company] Payment source confirmed');

      final confirmResponse = PaypalConfirmPaymentResponse.fromJson(response);

      if (confirmResponse.status == 'PAYER_ACTION_REQUIRED') {
        final payerActionLink = confirmResponse.links.firstWhere(
          (link) => link.rel == 'payer-action',
          orElse: () => PaypalLink(href: '', rel: '', method: ''),
        );
        if (payerActionLink.href.isNotEmpty) {
          await _handle3DSecure(payerActionLink.href, orderId, accessToken);
        } else {
          throw Exception('Payer action link not found');
        }
      } else {
        await _capturePayment(orderId);
      }
    } catch (e) {
      print('❌ [Company] confirmPaymentSource error: $e');
      setState(() => _isCapturing = false);
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
    final controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) =>
              print('🔵 [Company 3DS]: Page started: $url'),
          onPageFinished: (String url) {
            print('✅ [Company 3DS]: Page finished: $url');
            if (url.contains('success') || url.contains('complete')) {
              _capturePayment(orderId);
            }
          },
          onWebResourceError: (WebResourceError error) =>
              print('❌ [Company 3DS] Error: ${error.description}'),
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('success') ||
                request.url.contains('complete') ||
                request.url.contains('return.example.com')) {
              Future.delayed(
                const Duration(milliseconds: 500),
                () => _capturePayment(orderId),
              );
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

    setState(() {
      _cardFieldsController = controller;
      _showCardFieldsWebView = true;
    });
  }

  void _onPaymentSuccess(String transactionId) {
    setState(() => _isProcessing = false);

    Get.snackbar(
      'Payment Completed',
      'Payment succeeded for ${widget.planTitle}!\nTransaction ID: $transactionId',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(() => const PlanPricingScreen());
    });
  }

  Future<void> _processCardPayment() async {
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

    setState(() => _isCardPaymentProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isCardPaymentProcessing = false);

    Get.snackbar(
      'Payment Processing',
      'Card payment functionality will be implemented with PayPal GraphQL API',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon:
              const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
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
                  // Header
                  const Text(
                    'Payment',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0070BA),
                    ),
                  ),
                  const SizedBox(height: 12),
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

                  // Pay with PayPal label
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
                              errorBuilder: (context, error, stackTrace) =>
                                  const Text(
                                'PayPal',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF003087),
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Debit/Credit Card Button (Black)
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

            // Card Fields WebView (inline)
            if (_showCardFieldsWebView && _cardFieldsController != null)
              Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1500,
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

            // Capturing loader
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
                  // Card form (expandable)
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: _showCardForm
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: const SizedBox.shrink(),
                    secondChild: _buildCardPaymentForm(),
                  ),

                  const SizedBox(height: 8),

                  // Summary
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

                  // Plan ID row
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '•  ',
                          style: TextStyle(fontSize: 14, color: Colors.black),
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
                                      widget.orderId ?? widget.planId ?? '',
                                  style:
                                      const TextStyle(fontFamily: 'monospace'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '•  ',
                          style: TextStyle(fontSize: 14, color: Colors.black),
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

                  // Total
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
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.credit_card,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
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
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Text(
                              'PP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0070BA),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 24),
              IconButton(
                onPressed: () => setState(() => _showCardForm = false),
                icon: const Icon(Icons.close, size: 24),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Card number
          TextField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration('Card number'),
          ),
          const SizedBox(height: 12),

          // Expiry + CVV
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiryController,
                  keyboardType: TextInputType.datetime,
                  decoration: _inputDecoration('Expires'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Security code'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Billing address header + country dropdown
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
                            orElse: () => {'flag': '🌍'},
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
                          : _countries.map((c) {
                              return DropdownMenuItem<String>(
                                value: c['code'],
                                child: Row(
                                  children: [
                                    Text(
                                      c['flag'] ?? '🌍',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      c['name'] ?? '',
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

          // First + Last name
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _firstNameController,
                  decoration: _inputDecoration('First name'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _lastNameController,
                  decoration: _inputDecoration('Last name'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _address1Controller,
            decoration: _inputDecoration('Address line 1'),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _address2Controller,
            decoration: _inputDecoration('Address line 2'),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _cityController,
            decoration: _inputDecoration('Town/City'),
          ),
          const SizedBox(height: 12),

          // County dropdown
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
                ..._counties.map(
                  (county) => DropdownMenuItem<String>(
                    value: county,
                    child: Text(county),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _selectedCounty = value),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _postcodeController,
            decoration: _inputDecoration('Postcode'),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            decoration:
                _inputDecoration('Mobile').copyWith(prefixText: '+44  '),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration('Email'),
          ),
          const SizedBox(height: 16),

          // Deliver to billing address
          Row(
            children: [
              Checkbox(
                value: _deliverToBillingAddress,
                onChanged: (value) =>
                    setState(() => _deliverToBillingAddress = value ?? true),
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

          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
                height: 1.4,
              ),
              children: [
                TextSpan(text: 'You acknowledge the '),
                TextSpan(
                  text: 'terms',
                  style: TextStyle(
                    color: Color(0xFF0070BA),
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text:
                      ' of the service PayPal provides to the seller and agree to the ',
                ),
                TextSpan(
                  text: 'Privacy Statement',
                  style: TextStyle(
                    color: Color(0xFF0070BA),
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: '. No PayPal account required.'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Pay button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed:
                  _isCardPaymentProcessing ? null : _processCardPayment,
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
                errorBuilder: (context, error, stackTrace) => const Text(
                  'PayPal',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0070BA),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF999999)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}
