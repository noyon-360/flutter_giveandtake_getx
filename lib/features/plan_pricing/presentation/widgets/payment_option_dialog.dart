import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/common/constants/app_images.dart';
import 'package:giveandtake/core/theme/app_colors.dart';
import 'package:giveandtake/core/services/get_user_profile_service.dart';
import 'package:giveandtake/features/plan_pricing/presentation/screens/payment_screen.dart';
import 'package:giveandtake/features/plan_pricing/presentation/screens/plan_pricing_screen.dart';
import 'package:giveandtake/features/plan_pricing/presentation/controllers/paypal_controller.dart';

class PaymentMethodDialog extends StatefulWidget {
  final String planTitle;
  final double price;
  final String? planId;
  final VoidCallback? onPayNow;

  const PaymentMethodDialog({
    super.key,
    required this.planTitle,
    required this.price,
    this.planId,
    this.onPayNow,
  });

  @override
  State<PaymentMethodDialog> createState() => _PaymentMethodDialogState();
}

class _PaymentMethodDialogState extends State<PaymentMethodDialog> {
  String _selectedMethod = 'PayPal';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title + Close
            Center(
              child: const Text(
                "Select Payment Method",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            // PayPal option
            GestureDetector(
              onTap: () => setState(() => _selectedMethod = 'PayPal'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedMethod == "PayPal"
                        ? Colors.blue
                        : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Image.asset(AppImages.paypalImage, height: 30),
                    const Spacer(),
                    Radio<String>(
                      value: "PayPal",
                      groupValue: _selectedMethod,
                      onChanged: (v) => setState(() => _selectedMethod = v!),
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Pay Now button
            SizedBox(
              width: 129,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLightBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () async {
                  if (_selectedMethod == 'PayPal') {
                    // Close dialog first
                    if (mounted) Navigator.of(context).pop();

                    // Check if platform is Android for native SDK
                    if (Platform.isAndroid) {
                      // Get userId from user profile service
                      final userProfileService =
                          Get.find<GetUserProfileService>();
                      final userId = userProfileService.userInfo?.id ?? '';

                      if (userId.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'User not logged in. Please log in and try again.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      if (widget.planId == null || widget.planId!.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Invalid plan selected. Please try again.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      // Show loading indicator
                      Get.dialog(
                        Center(child: CircularProgressIndicator()),
                        barrierDismissible: false,
                      );

                      // Directly call native PayPal flow for Android
                      final paypalController = Get.find<PaypalController>();
                      await paypalController.startNativePayment(
                        amount: widget.price,
                        userId: userId,
                        planId: widget.planId!,
                        seasonId: null, // Optional: Add if needed
                        onSuccess: (orderId) {
                          // Close loading dialog
                          if (Get.isDialogOpen == true) Get.back();

                          // Show success snackbar
                          Get.snackbar(
                            'Success',
                            'Payment completed successfully!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 2),
                          );

                          // Navigate to Plan Pricing screen as user requested
                          Future.delayed(const Duration(seconds: 2), () {
                            Get.offAll(() => PlanPricingScreen());
                          });
                        },
                        onError: (error) {
                          // Close loading dialog
                          if (Get.isDialogOpen == true) Get.back();

                          // Show error snackbar
                          Get.snackbar(
                            'Payment Error',
                            error,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        },
                      );
                    } else {
                      // Fallback to PaymentScreen for iOS/Web (WebView flow)
                      Get.to(
                        PaymentScreen(
                          planTitle: widget.planTitle,
                          amount: widget.price,
                          planId: widget.planId,
                        ),
                      );
                    }
                  } else {
                    // Fallback to existing PaymentScreen for other payment methods
                    Get.to(
                      PaymentScreen(
                        planTitle: widget.planTitle,
                        amount: widget.price,
                        planId: widget.planId,
                      ),
                    );
                  }
                },
                child: const Text(
                  "Pay Now",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

void showPaymentMethodDialog(
  BuildContext context, {
  required String planTitle,
  required double price,
  String? planId,
  VoidCallback? onPayNow,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => PaymentMethodDialog(
      planTitle: planTitle,
      price: price,
      planId: planId,
      onPayNow: onPayNow,
    ),
  );
}
