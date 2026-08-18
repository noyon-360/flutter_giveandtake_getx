import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../controller/subscription_controller.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final SubscriptionController subscriptionController =
      Get.put(SubscriptionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a subscription'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Restore purchases',
            icon: const Icon(Icons.restore),
            onPressed: () async {
              try {
                await subscriptionController.restorePurchases();

                if (mounted) {
                  Get.snackbar(
                    'Restore started',
                    'Checking your previous purchases...',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              } catch (error) {
                Get.snackbar(
                  'Restore failed',
                  error.toString(),
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (subscriptionController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!subscriptionController.isStoreAvailable.value) {
          return _StoreUnavailableView(
            onRetry: subscriptionController.initializeSubscriptions,
          );
        }

        if (subscriptionController.subscriptions.isEmpty) {
          return _NoSubscriptionsView(
            missingIds: subscriptionController.notFoundIds,
            onRetry: subscriptionController.initializeSubscriptions,
          );
        }

        return RefreshIndicator(
          onRefresh: subscriptionController.initializeSubscriptions,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: subscriptionController.subscriptions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) {
              final ProductDetails product =
                  subscriptionController.subscriptions[index];

              return _SubscriptionCard(
                product: product,
                onBuy: () async {
                  try {
                    await subscriptionController.buySubscription(product);
                  } catch (error) {
                    Get.snackbar(
                      'Purchase could not start',
                      error.toString(),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              );
            },
          ),
        );
      }),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({
    required this.product,
    required this.onBuy,
  });

  final ProductDetails product;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              product.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (product.description.isNotEmpty)
              Text(
                product.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Text(
                  product.price,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onBuy,
                  child: const Text('Subscribe'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreUnavailableView extends StatelessWidget {
  const _StoreUnavailableView({
    required this.onRetry,
  });

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.storefront_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Subscriptions are unavailable',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Check your internet connection and Google Play Store or App Store setup, then try again.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () async => onRetry(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoSubscriptionsView extends StatelessWidget {
  const _NoSubscriptionsView({
    required this.missingIds,
    required this.onRetry,
  });

  final List<String> missingIds;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final String missingText = missingIds.isEmpty
        ? 'No subscription products were returned by the store.'
        : 'Products not found:\n${missingIds.join('\n')}';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.subscriptions_outlined,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              'No subscriptions available',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              missingText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () async => onRetry(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reload'),
            ),
          ],
        ),
      ),
    );
  }
}