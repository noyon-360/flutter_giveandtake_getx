import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/constants/app_images.dart';
import '../../../../core/theme/app_colors.dart';
import '../screens/payment_screen.dart';

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
            // Title
            const Center(
              child: Text(
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
                    color: _selectedMethod == 'PayPal'
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
                      value: 'PayPal',
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

                    // Navigate to PaymentScreen (yellow PayPal button + card flow)
                    // Same as plan_pricing iOS/fallback path — no native SDK
                    Get.to(
                      () => PaymentScreen(
                        planTitle: widget.planTitle,
                        amount: widget.price,
                        planId: widget.planId,
                      ),
                    );
                  } else {
                    // Fallback for other payment methods
                    Get.to(
                      () => PaymentScreen(
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
