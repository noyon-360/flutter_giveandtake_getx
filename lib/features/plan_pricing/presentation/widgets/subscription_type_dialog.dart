import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Shows a dialog to choose between monthly and yearly subscription
void showSubscriptionTypeDialog(
  BuildContext context, {
  required String planTitle,
  required double monthlyPrice,
  required double yearlyPrice,
  required VoidCallback onMonthlySelected,
  required VoidCallback onYearlySelected,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              const Text(
                'Choose your subscription type',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Monthly option
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    onMonthlySelected();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B9EFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Monthly — \$${monthlyPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Yearly option
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    onYearlySelected();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B9EFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Yearly — \$${yearlyPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Cancel button
              TextButton(
                onPressed: () {
                  Get.back(); // Close dialog
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF8593A3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Shows a dialog for single subscription option
void showSingleSubscriptionDialog(
  BuildContext context, {
  required String planTitle,
  required double price,
  required String subscriptionType,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              const Text(
                'Confirm Subscription',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Plan details
              Text(
                planTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF212121),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '\$${price.toStringAsFixed(2)} $subscriptionType',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF8593A3),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Confirm button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B9EFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue to Payment',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Cancel button
              TextButton(
                onPressed: () {
                  Get.back(); // Close dialog
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF8593A3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
