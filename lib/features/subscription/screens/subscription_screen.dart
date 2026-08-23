import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:giveandtake/core/common/widgets/app_scaffold.dart';
import 'package:giveandtake/core/theme/app_colors.dart';

import '../controller/subscription_controller.dart';

/// Where a plan sends the user when the billing cycle they picked has no
/// matching product configured in App Store/Play Console yet.
const String _kWebFallbackUrl = 'https://evpitch.com/company-pricing';

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

  Future<void> _buyProduct(ProductDetails product) async {
    try {
      await subscriptionController.buySubscription(product);
    } catch (error) {
      Get.snackbar(
        'Purchase could not start',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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
                                  allSubscriptions: subscriptions,
                                  onBuyProduct: _buyProduct,
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

const Color _kPlanBlue = Color(0xff2E7DD1);
const Color _kPriceBlack = Color(0xff1A1A1A);
const Color _kMutedGray = Color(0xff8593A3);
const Color _kFeatureGray = Color(0xff4A4A4A);

/// Display-only content for each Non-Renewing Subscription plan.
///
/// Apple's In-App Purchase description field is capped at 45 characters,
/// far too short for the full feature lists shown in the app, so the
/// title/annual price/feature copy is kept here and only the purchasable
/// monthly [ProductDetails.price] comes from the store.
class _PlanContent {
  const _PlanContent({
    required this.title,
    required this.features,
    this.annualPrice,
    this.annualNote,
    this.annualProductId,
  });

  final String title;
  final List<String> features;
  final String? annualPrice;
  final String? annualNote;

  /// The Store Connect/Play Console product id for the annual cycle, if one
  /// has been configured. None of the current plans have an annual product
  /// yet, so this stays null until one is added — at which point the
  /// matching id here is all that's needed to route "Annual" through the
  /// native purchase flow instead of the web fallback.
  final String? annualProductId;
}

const List<String> _kStandardFeatures = <String>[
  '12 Months for the price of 11 Months!',
  'All job posts free until April 2026!',
  '60-Second company Elevator Video Pitch©',
  'Intuitive company dashboard',
  'Seamless job posting/closure/reopening',
  'Scheduled job posts',
  'Job applicants online screening',
  'One-click applicant updates',
];

const String _kYearlyNote = '(Yearly plan — web purchase only)';

final Map<String, _PlanContent> _kPlanContentById = <String, _PlanContent>{
  'com.pooelcentral.giveandtake.company.payasyougo': const _PlanContent(
    title: 'Pay as You Go',
    features: <String>[
      'All job posts free until April 2026!',
      '60-Second company Elevator Video Pitch©',
      'Intuitive company dashboard',
      'Seamless job posting/closure/reopening',
      'Scheduled posts',
      'Job applicants online screening',
      'One-click applicant updates',
    ],
  ),
  'com.pooelcentral.giveandtake.company.basic': const _PlanContent(
    title: 'Basic Plan (Up to 24 job posts per annual cycle)',
    annualPrice: '\$2155.99 per annum',
    annualNote: _kYearlyNote,
    features: _kStandardFeatures,
  ),
  'com.pooelcentral.giveandtake.company.bronze': const _PlanContent(
    title: 'Premium Bronze Plan (Up to 36 job posts per annual cycle)',
    annualPrice: '\$2980.99 per annum',
    annualNote: _kYearlyNote,
    features: _kStandardFeatures,
  ),
  'com.pooelcentral.giveandtake.company.silver': const _PlanContent(
    title: 'Premium Silver Plan (Up to 48 job posts per annual cycle)',
    annualPrice: '\$3915.99 per annum',
    annualNote: _kYearlyNote,
    features: _kStandardFeatures,
  ),
  'com.pooelcentral.giveandtake.company.gold': const _PlanContent(
    title: 'Premium Gold Plan (Up to 60 job posts per annual cycle)',
    annualPrice: '\$4839.99 per annum',
    annualNote: _kYearlyNote,
    features: _kStandardFeatures,
  ),
  'com.pooelcentral.giveandtake.company.platinum': const _PlanContent(
    title: 'Premium Platinum Plan (Unlimited job posts per annual cycle)',
    annualPrice: '\$12319.99 per annum',
    annualNote: _kYearlyNote,
    features: <String>[
      '12 Months for the price of 11 Months!',
      'All job posts free until April 2026!',
      '60-Second company Elevator Video Pitch©',
      'Intuitive company dashboard',
      'Seamless job posting/closure/reopening',
      'Scheduled job posts',
      'Job applicants online screening',
      'One-click job applicant updates',
    ],
  ),
};

class _SubscriptionPlanCard extends StatelessWidget {
  const _SubscriptionPlanCard({
    required this.product,
    required this.allSubscriptions,
    required this.onBuyProduct,
  });

  final ProductDetails product;

  /// Every product the store actually returned, used to check whether the
  /// billing cycle the user picks (monthly/annual) has a real, purchasable
  /// product before starting an in-app purchase for it.
  final List<ProductDetails> allSubscriptions;
  final Future<void> Function(ProductDetails product) onBuyProduct;

  ProductDetails? _findProductById(String? id) {
    if (id == null) {
      return null;
    }
    for (final ProductDetails candidate in allSubscriptions) {
      if (candidate.id == id) {
        return candidate;
      }
    }
    return null;
  }

  Future<void> _openWebFallback() async {
    final Uri uri = Uri.parse(_kWebFallbackUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _handleSubscribeTap(BuildContext context, _PlanContent content) {
    // Only Pay As You Go (and any plan without a known annual price) skips
    // straight to purchasing the single available product.
    if (content.annualPrice == null) {
      onBuyProduct(product);
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return _PaymentOptionDialog(
          planTitle: content.title,
          monthlyLabel: '${product.price} per month',
          annualLabel: content.annualPrice!,
          onMonthly: () {
            Navigator.of(dialogContext).pop();
            // The monthly product is exactly what's already loaded here —
            // that's why this card exists — so it's always purchasable.
            onBuyProduct(product);
          },
          onAnnual: () async {
            Navigator.of(dialogContext).pop();
            final ProductDetails? annualProduct = _findProductById(
              content.annualProductId,
            );
            if (annualProduct != null) {
              await onBuyProduct(annualProduct);
            } else {
              // No annual product configured in the store yet — send the
              // user to complete the annual purchase on the website.
              await _openWebFallback();
            }
          },
        );
      },
    );
  }

  _PlanContent get _content {
    final _PlanContent? predefined = _kPlanContentById[product.id];
    if (predefined != null) {
      return predefined;
    }

    // Fallback for any plan not covered above (e.g. company_month): parse
    // whatever feature text the store returns instead of showing nothing.
    final List<String> lines = product.description
        .split(RegExp(r'[\n•]+'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    return _PlanContent(
      title: product.title,
      features: lines.isEmpty ? <String>[product.description] : lines,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _PlanContent content = _content;

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffE5E9F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan title
          Text(
            content.title,
            style: const TextStyle(
              fontSize: 15,
              color: _kPlanBlue,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),

          // Price (monthly price comes from the store; annual is informational)
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '${product.price} per month',
                style: const TextStyle(
                  fontSize: 20,
                  color: _kPriceBlack,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (content.annualPrice != null) ...[
                const Text(
                  '  /  ',
                  style: TextStyle(
                    fontSize: 18,
                    color: _kPriceBlack,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  content.annualPrice!,
                  style: const TextStyle(
                    fontSize: 20,
                    color: _kPriceBlack,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
          if (content.annualNote != null) ...[
            const SizedBox(height: 4),
            Text(
              content.annualNote!,
              style: const TextStyle(fontSize: 11, color: _kMutedGray),
            ),
          ],

          const SizedBox(height: 18),
          const Text(
            'What you will get',
            style: TextStyle(
              fontSize: 12,
              color: _kMutedGray,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Full features list — all points from the plan are always shown.
          ...content.features.map((feature) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.verified, color: _kPlanBlue, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      feature,
                      style: const TextStyle(
                        fontSize: 13,
                        color: _kFeatureGray,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 8),

          // Subscribe button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _handleSubscribeTap(context, content),
              style: OutlinedButton.styleFrom(
                foregroundColor: _kPlanBlue,
                side: const BorderSide(color: _kPlanBlue, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Subscribe',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Select Payment Option" dialog shown when a plan has both a monthly
/// (in-app purchase) and an annual price to choose from.
class _PaymentOptionDialog extends StatelessWidget {
  const _PaymentOptionDialog({
    required this.planTitle,
    required this.monthlyLabel,
    required this.annualLabel,
    required this.onMonthly,
    required this.onAnnual,
  });

  final String planTitle;
  final String monthlyLabel;
  final String annualLabel;
  final VoidCallback onMonthly;
  final VoidCallback onAnnual;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Payment Option for $planTitle',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _kPriceBlack,
              ),
            ),
            const SizedBox(height: 20),

            _PaymentOptionButton(
              label: 'Monthly: $monthlyLabel',
              onTap: onMonthly,
            ),
            const SizedBox(height: 12),
            _PaymentOptionButton(
              label: 'Annual: $annualLabel',
              onTap: onAnnual,
            ),

            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 14, color: _kMutedGray),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentOptionButton extends StatelessWidget {
  const _PaymentOptionButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: _kPlanBlue,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
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
