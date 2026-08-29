import 'dart:async';
import 'dart:io';

import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:giveandtake/core/services/get_user_profile_service.dart';
import 'package:giveandtake/features/auth/presentation/controller/auth_controller.dart';

/// Which set of Non-Renewing Subscriptions to show, based on the logged-in
/// user's account type.
enum SubscriptionAudience { candidate, recruiter, company }

class SubscriptionController extends GetxController {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  final RxBool isStoreAvailable = false.obs;
  final RxBool isLoading = false.obs;

  final RxList<ProductDetails> subscriptions = <ProductDetails>[].obs;
  final RxList<String> notFoundIds = <String>[].obs;

  /// Display order for each audience's plans, matching the corresponding
  /// evpitch.com pricing page. Also doubles as the set of product ids
  /// queried for that audience/platform — the store does not guarantee it
  /// returns products in the order they were queried, so results are
  /// re-sorted to match this every time.
  static const Map<SubscriptionAudience, List<String>>
  _androidProductIdsByAudience = <SubscriptionAudience, List<String>>{
    SubscriptionAudience.candidate: <String>['candidate_monthly'],
    SubscriptionAudience.recruiter: <String>['recruiter_month'],
    SubscriptionAudience.company: <String>['company_month'],
  };

  // Non-Renewing Subscriptions configured in App Store Connect.
  // Auto-renewable subscriptions are intentionally not queried/shown here.
  static const Map<SubscriptionAudience, List<String>>
  _iosProductIdsByAudience = <SubscriptionAudience, List<String>>{
    SubscriptionAudience.candidate: <String>[
      'com.pooelcentral.giveandtake.candidate.premium',
    ],
    SubscriptionAudience.recruiter: <String>[
      'com.pooelcentral.giveandtake.recruiter.payasyougo',
      'com.pooelcentral.giveandtake.recruiter.basic',
      'com.pooelcentral.giveandtake.recruiter.bronze',
      'com.pooelcentral.giveandtake.recruiter.silver',
      'com.pooelcentral.giveandtake.recruiter.gold',
      'com.pooelcentral.giveandtake.recruiter.platinum',
    ],
    SubscriptionAudience.company: <String>[
      'com.pooelcentral.giveandtake.company.payasyougo',
      'com.pooelcentral.giveandtake.company.basic',
      'com.pooelcentral.giveandtake.company.bronze',
      'com.pooelcentral.giveandtake.company.silver',
      'com.pooelcentral.giveandtake.company.gold',
      'com.pooelcentral.giveandtake.company.platinum',
      'company_month',
    ],
  };

  /// The audience resolved for the current user, set once
  /// [loadSubscriptions] has run.
  SubscriptionAudience? audience;

  /// Mirrors the role precedence used by the app drawer's
  /// `_effectiveRole` (see app_drawer.dart): the reactive profile role
  /// first, falling back to the role persisted at login if the profile
  /// hasn't loaded yet. Defaults to candidate, same as the drawer's switch.
  Future<SubscriptionAudience> _resolveAudience() async {
    String role = '';

    if (Get.isRegistered<GetUserProfileService>()) {
      role = (Get.find<GetUserProfileService>().userInfo?.role ?? '')
          .toLowerCase();
    }

    if (role.isEmpty && Get.isRegistered<AuthController>()) {
      try {
        role =
            (await Get.find<AuthController>().authStorageService
                    .getUserRole()) ??
            '';
        role = role.toLowerCase();
      } catch (error) {
        DPrint.log('Could not read stored user role: $error');
      }
    }

    switch (role) {
      case 'recruiter':
        return SubscriptionAudience.recruiter;
      case 'company':
        return SubscriptionAudience.company;
      case 'candidate':
      default:
        return SubscriptionAudience.candidate;
    }
  }

  @override
  void onInit() {
    super.onInit();

    _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) {
        DPrint.log('Purchase stream error: $error');
      },
    );

    initializeSubscriptions();
  }

  Future<void> initializeSubscriptions() async {
    isLoading.value = true;

    try {
      await checkSubscriptionAvailability();

      if (!isStoreAvailable.value) {
        return;
      }

      await loadSubscriptions();
    } catch (error, stackTrace) {
      DPrint.log('Subscription initialization error: $error');
      DPrint.log('$stackTrace');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkSubscriptionAvailability() async {
    final bool available = await _inAppPurchase.isAvailable();

    isStoreAvailable.value = available;
    DPrint.log('Subscription availability: $available');
  }

  Future<List<ProductDetails>> loadSubscriptions() async {
    final SubscriptionAudience resolvedAudience = await _resolveAudience();
    audience = resolvedAudience;
    DPrint.log('Subscription audience resolved: $resolvedAudience');

    final Map<SubscriptionAudience, List<String>> idsByAudience;

    if (Platform.isAndroid) {
      idsByAudience = _androidProductIdsByAudience;
    } else if (Platform.isIOS) {
      idsByAudience = _iosProductIdsByAudience;
    } else {
      throw UnsupportedError(
        'In-app subscriptions are supported only on Android and iOS.',
      );
    }

    final List<String> planDisplayOrder =
        idsByAudience[resolvedAudience] ?? const <String>[];
    final Set<String> subscriptionIds = planDisplayOrder.toSet();

    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(subscriptionIds);

    if (response.error != null) {
      throw StateError(
        'Could not load subscriptions: ${response.error!.message}',
      );
    }

    final List<ProductDetails> orderedProducts = List<ProductDetails>.from(
      response.productDetails,
    )..sort((a, b) {
      final int rankA = planDisplayOrder.indexOf(a.id);
      final int rankB = planDisplayOrder.indexOf(b.id);
      return (rankA == -1 ? planDisplayOrder.length : rankA).compareTo(
        rankB == -1 ? planDisplayOrder.length : rankB,
      );
    });

    subscriptions.assignAll(orderedProducts);
    notFoundIds.assignAll(response.notFoundIDs);

    DPrint.log(
      'Found subscriptions: '
      '${response.productDetails.map((product) => product.id).toList()}',
    );

    DPrint.log('Subscription IDs not found: ${response.notFoundIDs}');

    return response.productDetails;
  }

  Future<void> buySubscription(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: product,
    );

    // Subscriptions use buyNonConsumable in this plugin.
    await _inAppPurchase.buyNonConsumable(
      purchaseParam: purchaseParam,
    );
  }

  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchases,
  ) async {
    for (final PurchaseDetails purchase in purchases) {
      DPrint.log(
        'Purchase update: '
        'id=${purchase.productID}, status=${purchase.status}',
      );

      switch (purchase.status) {
        case PurchaseStatus.pending:
          // Show your loading UI if needed.
          DPrint.log('Purchase is pending');
          break;

        case PurchaseStatus.error:
          DPrint.log(
            'Purchase error: ${purchase.error?.message ?? 'Unknown error'}',
          );
          break;

        case PurchaseStatus.canceled:
          DPrint.log('Purchase cancelled');
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final bool isVerified = await _verifyPurchaseOnServer(purchase);

          if (!isVerified) {
            DPrint.log('Purchase verification failed: ${purchase.productID}');
            return;
          }

          // Update your backend entitlement here:
          // candidate/company/recruiter subscription access.
          await _grantSubscriptionAccess(purchase);

          break;
      }

      // Must complete only after verification/delivery succeeds.
      if (purchase.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchase);
        DPrint.log('Purchase completed: ${purchase.productID}');
      }
    }
  }

  Future<bool> _verifyPurchaseOnServer(
    PurchaseDetails purchase,
  ) async {
    // Send this data to YOUR backend:
    //
    // purchase.productID
    // purchase.purchaseID
    // purchase.verificationData.serverVerificationData
    // purchase.verificationData.localVerificationData
    // purchase.verificationData.source
    //
    // Your backend should verify the subscription with Google Play
    // or App Store before returning true.
    //
    // Do NOT return true permanently in production.
    return true;
  }

  Future<void> _grantSubscriptionAccess(
    PurchaseDetails purchase,
  ) async {
    switch (purchase.productID) {
      case 'candidate_monthly':
      case 'com.pooelcentral.giveandtake.candidate.premium':
        DPrint.log('Grant candidate subscription access');
        break;

      case 'company_month':
      case 'com.pooelcentral.giveandtake.company.basic':
      case 'com.pooelcentral.giveandtake.company.payasyougo':
      case 'com.pooelcentral.giveandtake.company.bronze':
      case 'com.pooelcentral.giveandtake.company.gold':
      case 'com.pooelcentral.giveandtake.company.platinum':
      case 'com.pooelcentral.giveandtake.company.silver':
        DPrint.log('Grant company subscription access');
        break;

      case 'recruiter_month':
      case 'com.pooelcentral.giveandtake.recruiter.basic':
      case 'com.pooelcentral.giveandtake.recruiter.payasyougo':
      case 'com.pooelcentral.giveandtake.recruiter.bronze':
      case 'com.pooelcentral.giveandtake.recruiter.gold':
      case 'com.pooelcentral.giveandtake.recruiter.platinum':
      case 'com.pooelcentral.giveandtake.recruiter.silver':
        DPrint.log('Grant recruiter subscription access');
        break;

      default:
        DPrint.log('Unknown subscription product: ${purchase.productID}');
    }
  }

  @override
  void onClose() {
    _purchaseSubscription?.cancel();
    super.onClose();
  }
}