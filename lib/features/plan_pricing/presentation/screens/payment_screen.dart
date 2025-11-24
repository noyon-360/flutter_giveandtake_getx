import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/plan_pricing/presentation/screens/plan_pricing_screen.dart';
import 'package:karlfive/features/plan_pricing/presentation/screens/paypal_webview_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String planTitle;
  final double amount;
  final String? orderId;
  final String? approveUrl;

  const PaymentScreen({
    super.key,
    required this.planTitle,
    this.amount = 0.00,
    this.orderId,
    this.approveUrl,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;

  Future<void> _handlePayment() async {
    // Navigate to PayPal WebView for payment
    Get.to(
      () => PaypalWebViewScreen(
        planTitle: widget.planTitle,
        amount: widget.amount,
        orderId: widget.orderId,
        onFinish: (transactionId) {
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
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.textBlack),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Details",
              style: TextStyle(
                color: AppColors.textBlack,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Compare plans and choose the one that best \nfits your hiring or job-seeking needs.",
              style: TextStyle(color: AppColors.textBlack, fontSize: 12),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 28),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Summary",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Show Order ID if available
                    if (widget.orderId != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "PayPal Order ID:",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textBlack,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.orderId!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue.shade700,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    Text(
                      "Recurring Payment Terms:",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(height: 7.5),
                    Text(
                      "  •  Charges includes Applicable VAT/GST and/or Sale Taxes ",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Divider(color: Color(0xff282828)),
                    Row(
                      children: [
                        Text(
                          "Total:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textBlack,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "\$${widget.amount.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Color(0xff282828)),
                    const SizedBox(height: 30),
                    Text(
                      "Safe & secure payment :",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "By clicking the Pay button, you are agreeing to our Terms of Service and Privacy Statement. You are also authorizing us to charge your credit/debit card at the price above now and before each new subscription term. For any questions please contact support@tipnenka.com",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textBlack,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Loading indicator
                    if (_isProcessing)
                      const Center(child: CircularProgressIndicator()),

                    // Responsive spacing instead of Spacer inside scrollable
                    SizedBox(height: MediaQuery.of(context).size.height * 0.12),

                    // Pay Now button
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          minimumSize: Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: _isProcessing ? null : _handlePayment,
                        child: _isProcessing
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                "Pay Now \$${widget.amount.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: AppBottomNavBar(currentIndex: 0),
    );
  }
}
