import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/paypal_services.dart';

class PaypalWebViewScreen extends StatefulWidget {
  final String planTitle;
  final double amount;
  final String? orderId;
  final Function(String)? onFinish;

  const PaypalWebViewScreen({
    Key? key,
    required this.planTitle,
    required this.amount,
    this.orderId,
    this.onFinish,
  }) : super(key: key);

  @override
  State<PaypalWebViewScreen> createState() => _PaypalWebViewScreenState();
}

class _PaypalWebViewScreenState extends State<PaypalWebViewScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  final PaypalServices services = PaypalServices();
  late WebViewController? _webViewController;

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();

    // Initialize WebViewController
    _webViewController = null;

    Future.delayed(Duration.zero, () async {
      try {
        print('🔵 PayPal: Getting access token...');
        accessToken = await services.getAccessToken();

        if (accessToken == null) {
          throw Exception(
            'Failed to get PayPal access token. Please check your credentials.',
          );
        }

        print('✅ PayPal: Access token received');
        print('🔵 PayPal: Creating payment...');

        final transactions = getOrderParams();
        print('🔵 PayPal: Transaction params: $transactions');

        final res = await services.createPaypalPayment(
          transactions,
          accessToken!,
        );

        if (res == null) {
          throw Exception(
            'Failed to create PayPal payment. No response from PayPal API.',
          );
        }

        print('✅ PayPal: Payment created successfully');
        print('🔵 PayPal: Approval URL: ${res["approvalUrl"]}');
        print('🔵 PayPal: Execute URL: ${res["executeUrl"]}');

        if (res["approvalUrl"] == null || res["approvalUrl"]!.isEmpty) {
          throw Exception('No approval URL received from PayPal');
        }

        setState(() {
          checkoutUrl = res["approvalUrl"];
          executeUrl = res["executeUrl"];
        });

        // Initialize WebViewController with the checkout URL
        if (checkoutUrl != null) {
          print('🔵 PayPal: Initializing WebView with URL: $checkoutUrl');
          _webViewController = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onPageStarted: (String url) {
                  print('🔵 WebView: Page started loading: $url');
                },
                onPageFinished: (String url) {
                  print('✅ WebView: Page finished loading: $url');
                },
                onWebResourceError: (WebResourceError error) {
                  print('❌ WebView Error: ${error.description}');
                  Get.snackbar(
                    'WebView Error',
                    error.description,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                },
                onNavigationRequest: (NavigationRequest request) {
                  print('🔵 Navigation: ${request.url}');
                  if (request.url.contains(returnURL)) {
                    final uri = Uri.parse(request.url);
                    final payerID = uri.queryParameters['PayerID'];
                    if (payerID != null &&
                        executeUrl != null &&
                        accessToken != null) {
                      print('✅ Payment approved! Executing payment...');
                      services
                          .executePayment(executeUrl!, payerID, accessToken!)
                          .then((id) {
                            if (id != null) {
                              print('✅ Payment executed successfully! ID: $id');
                              // Payment successful
                              Get.back();
                              Get.snackbar(
                                'Success',
                                'Payment completed successfully!',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                              if (widget.onFinish != null) {
                                widget.onFinish!(id);
                              }
                            } else {
                              print('❌ Payment execution failed');
                              Get.back();
                              Get.snackbar(
                                'Error',
                                'Payment execution failed',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          })
                          .catchError((error) {
                            print('❌ Execute payment error: $error');
                            Get.back();
                            Get.snackbar(
                              'Error',
                              'Failed to execute payment: $error',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          });
                    } else {
                      Navigator.of(context).pop();
                    }
                    return NavigationDecision.prevent;
                  }
                  if (request.url.contains(cancelURL)) {
                    print('⚠️ Payment cancelled by user');
                    Get.back();
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
            ..loadRequest(Uri.parse(checkoutUrl!));

          print('✅ WebView initialized successfully');
          setState(() {});
        }
      } catch (e, stackTrace) {
        print('❌ PayPal Error: ${e.toString()}');
        print('❌ Stack trace: $stackTrace');

        if (mounted) {
          Get.back(); // Close the loading screen
          Get.snackbar(
            'PayPal Error',
            e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 10),
          );
        }
      }
    });
  }

  Map<String, dynamic> getOrderParams() {
    // Calculate amounts
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
          "description": "Payment for $widget.planTitle subscription",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE",
          },
          "item_list": {"items": items},
        },
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL},
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    if (checkoutUrl != null && _webViewController != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
          title: const Text('PayPal Payment'),
        ),
        body: WebViewWidget(controller: _webViewController!),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const Text('PayPal Payment'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
  }
}
