import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:giveandtake/core/common/widgets/app_scaffold.dart';
import 'package:giveandtake/core/theme/app_colors.dart';

import '../controller/subscription_controller.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final SubscriptionController subscriptionController =
      Get.put(SubscriptionController());

  final PageController _pageController = PageController();
  final RxInt _currentPage = 0.obs;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.hasClients && _pageController.page != null) {
        _currentPage.value = _pageController.page!.round();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.textBlack),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a Subscription',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose the Plan That Fits You Best',
              style: TextStyle(
                fontSize: 10,
                color: const Color(0xff8593A3),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
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
          return const Center(child: CircularProgressIndicator());
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

        final List<ProductDetails> subscriptions =
            subscriptionController.subscriptions;

        return RefreshIndicator(
          onRefresh: subscriptionController.initializeSubscriptions,
          child: Column(
            children: [
              const SizedBox(height: 45),
              Expanded(
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: subscriptions.length,
                      itemBuilder: (context, index) {
                        final ProductDetails product = subscriptions[index];
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                ),
                                child: _SubscriptionPlanCard(
                                  product: product,
                                  onBuy: () async {
                                    try {
                                      await subscriptionController
                                          .buySubscription(product);
                                    } catch (error) {
                                      Get.snackbar(
                                        'Purchase could not start',
                                        error.toString(),
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 60),
                            ],
                          ),
                        );
                      },
                    ),

                    // Page indicator dots
                    if (subscriptions.length > 1)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 16,
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(subscriptions.length, (
                              index,
                            ) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: _currentPage.value == index ? 8 : 6,
                                height: _currentPage.value == index ? 8 : 6,
                                decoration: BoxDecoration(
                                  color: _currentPage.value == index
                                      ? const Color(0xff3B9EFF)
                                      : const Color(0xffD9D9D9),
                                  shape: BoxShape.circle,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }
}

class _SubscriptionPlanCard extends StatelessWidget {
  const _SubscriptionPlanCard({required this.product, required this.onBuy});

  final ProductDetails product;
  final VoidCallback onBuy;

  List<String> get _features {
    final List<String> lines = product.description
        .split(RegExp(r'[\n•]+'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    return lines.isEmpty ? <String>[product.description] : lines;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> features = _features;

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff3B9EFF), Color(0xff2B7FD9)],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan title
          Text(
            product.title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Price
          Text(
            product.price,
            style: const TextStyle(
              fontSize: 36,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),

          const SizedBox(height: 6),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'What you will get',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.white.withOpacity(0.5), thickness: 1),
          const SizedBox(height: 16),

          // Features list (derived from the store product description)
          ...features.asMap().entries.map((entry) {
            final bool isLast = entry.key == features.length - 1;
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Color(0xff3B9EFF),
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!isLast) const SizedBox(height: 12),
              ],
            );
          }),

          const SizedBox(height: 18),

          // Subscribe button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onBuy,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xff3B9EFF),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Subscribe',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreUnavailableView extends StatelessWidget {
  const _StoreUnavailableView({required this.onRetry});

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
            const Icon(Icons.subscriptions_outlined, size: 56),
            const SizedBox(height: 16),
            Text(
              'No subscriptions available',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(missingText, textAlign: TextAlign.center),
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
