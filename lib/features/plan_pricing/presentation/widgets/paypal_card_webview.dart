import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalCardWebView extends StatefulWidget {
  final String orderId;
  final String userId;
  final String planId;
  final double amount;
  final Function(String transactionId)? onFinish;

  const PaypalCardWebView({
    super.key,
    required this.orderId,
    required this.userId,
    required this.planId,
    required this.amount,
    this.onFinish,
  });

  @override
  State<PaypalCardWebView> createState() => _PaypalCardWebViewState();
}

class _PaypalCardWebViewState extends State<PaypalCardWebView> {
  late WebViewController _controller;
  bool _isLoading = true;

  // These should be updated to match the redirect URLs used by the web implementation
  final String returnURL = 'return.example.com';
  final String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    // Construct the URL exactly as seen in the web version
    final String paymentUrl =
        'http://10.10.5.67:3000/payment?orderId=${widget.orderId}&userId=${widget.userId}&planId=${widget.planId}&amount=${widget.amount}';

    print('🔵 PayPal Card: Loading URL: $paymentUrl');

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
            print('🔵 WebView: Page started: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            print('✅ WebView: Page finished: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('❌ WebView Error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            print('🔵 Navigation Request: ${request.url}');
            
            // Check for success/cancel URLs if the web implementation redirects
            // Intercept redirects to success page
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              // Extract transactionId if possible, or use orderId as fallback
              final transactionId = uri.queryParameters['transactionId'] ?? widget.orderId;
              
              if (widget.onFinish != null) {
                widget.onFinish!(transactionId);
              }
              Get.back();
              return NavigationDecision.prevent;
            }
            
            if (request.url.contains(cancelURL)) {
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
      ..loadRequest(Uri.parse(paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Drag handle for bottom sheet
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header with close button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PayPal Card Payment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0070BA), // PayPal Blue
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // WebView content
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF0070BA),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
