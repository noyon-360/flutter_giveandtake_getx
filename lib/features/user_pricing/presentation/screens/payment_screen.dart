import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/user_pricing/presentation/screens/plan_pricing_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String planTitle;
  final double amount;

  const PaymentScreen({super.key, required this.planTitle, this.amount = 0.00});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;

  Future<void> _handlePayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
    });

    // Show success message
    Get.snackbar(
      'Payment Completed',
      'Payment succeeded for ${widget.planTitle}!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Navigate to home after successful payment
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(() => PlanPricingScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.textBlack),
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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

                  const Spacer(),

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
        ],
      ),
      // bottomNavigationBar: AppBottomNavBar(currentIndex: 0),
    );
  }
}
