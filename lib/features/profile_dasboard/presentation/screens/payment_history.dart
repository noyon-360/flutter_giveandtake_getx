import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/network/services/auth_storage_service.dart';
import '../../data/models/payment_history_response_model.dart';
import '../controller/payment_history_controller.dart';
import '../services/receipt_pdf_service.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentHistoryController ctrl = Get.put(PaymentHistoryController());
    final AuthStorageService authStorageService = AuthStorageService();
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        authStorageService.getUserId().then((userId) {
          if (userId != null) {
            ctrl.loadMore(userId);
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
        title: const Text(
          'Payment History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              authStorageService.getUserId().then((userId) {
                if (userId != null) {
                  ctrl.refreshPayments(userId);
                }
              });
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<String?>(
          future: authStorageService.getUserId(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data == null) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('Unable to load user data'),
                ),
              );
            }

            final userId = snapshot.data!;
            ctrl.fetchUserPayments(userId, isRefresh: true);

            return Obx(() {
              if (ctrl.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (ctrl.error.value != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${ctrl.error.value}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ctrl.refreshPayments(userId),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final transactions = ctrl.transactions;

              if (transactions.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text(
                      'No payment transactions found',
                      style: TextStyle(fontSize: 14, color: Color(0xFF595959)),
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...transactions.map(
                      (transaction) => _buildTransactionCard(transaction),
                    ),
                    if (ctrl.isLoadingMore.value)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    if (!ctrl.hasMore && transactions.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'No more transactions',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF595959),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildTransactionCard(PaymentTransaction transaction) {
    final String transactionId = transaction.transactionId.isNotEmpty
        ? transaction.transactionId
        : 'N/A';

    String formattedDate = 'N/A';
    try {
      final date = DateTime.parse(transaction.createdAt);
      formattedDate = DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      formattedDate = 'N/A';
    }

    final String plan = transaction.planId?.title ?? 'N/A';
    final double amount = transaction.amount;
    final String status = transaction.paymentStatus;
    final bool isRefunded = transaction.planStatus.toLowerCase() == 'refunded';
    final bool isCompleted =
        status.toLowerCase() == 'complete' ||
        status.toLowerCase() == 'completed';

    Color statusBgColor = const Color(0xFFF3F4F6);
    Color statusTextColor = const Color(0xFF374151);
    String displayStatus = status.capitalizeFirst ?? 'N/A';

    if (isCompleted) {
      statusBgColor = const Color(0xFFD1FAE5);
      statusTextColor = const Color(0xFF065F46);
      displayStatus = 'Completed';
    } else if (isRefunded) {
      statusBgColor = const Color(0xFFFEE2E2);
      statusTextColor = const Color(0xFF991B1B);
      displayStatus = 'Refunded';
    } else if (status.toLowerCase() == 'pending') {
      statusBgColor = const Color(0xFFDCEDFF);
      statusTextColor = const Color(0xFF1E40AF);
      displayStatus = 'Pending';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Plan (left) + Status (right)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Plan',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plan,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      displayStatus,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Middle Row 1: Transaction ID (left) + Amount (right)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transaction ID',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transactionId,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF212121),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Amount',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Bottom Row: Date (left) + Buttons (right)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF595959),
                ),
              ),
              Row(
                children: [
                  // Download Receipt Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        Get.snackbar(
                          'Generating Receipt',
                          'Creating PDF receipt for $transactionId...',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue.shade50,
                          duration: const Duration(seconds: 1),
                        );

                        await ReceiptPdfService.generateAndDownloadReceipt(
                          transaction,
                        );

                        Get.snackbar(
                          'Success',
                          'Receipt downloaded successfully!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.shade50,
                          duration: const Duration(seconds: 2),
                        );
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'Failed to generate receipt: ${e.toString()}',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.shade50,
                          duration: const Duration(seconds: 3),
                        );
                      }
                    },
                    icon: const Icon(Icons.download, size: 14),
                    label: const Text(
                      'Download',
                      style: TextStyle(fontSize: 10),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B7FD0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      minimumSize: const Size(0, 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Refund Button
                  ElevatedButton(
                    onPressed: isRefunded
                        ? null
                        : () {
                            Get.snackbar(
                              'Refund Request',
                              'Processing refund request for $transactionId',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.orange.shade50,
                              duration: const Duration(seconds: 2),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRefunded
                          ? Colors.grey.shade300
                          : const Color(0xFFFF6B6B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      minimumSize: const Size(0, 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      isRefunded ? 'Refunded' : 'Refund',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
