import 'dart:async';
import 'dart:io';

import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionController extends GetxController {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  final RxBool isStoreAvailable = false.obs;
  final RxBool isLoading = false.obs;

  final RxList<ProductDetails> subscriptions = <ProductDetails>[].obs;
  final RxList<String> notFoundIds = <String>[].obs;

  static const Set<String> _androidSubscriptionIds = <String>{
    'candidate_monthly',
    'company_month',
    'recruiter_month',
  };

  static const Set<String> _iosSubscriptionIds = <String>{
    'com.pooelcentral.giveandtake.candidate.anual',
    'com.pooelcentral.giveandtake.candidate.monthly',
  };

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
    final Set<String> subscriptionIds;

    if (Platform.isAndroid) {
      subscriptionIds = _androidSubscriptionIds;
    } else if (Platform.isIOS) {
      subscriptionIds = _iosSubscriptionIds;
    } else {
      throw UnsupportedError(
        'In-app subscriptions are supported only on Android and iOS.',
      );
    }

    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(subscriptionIds);

    if (response.error != null) {
      throw StateError(
        'Could not load subscriptions: ${response.error!.message}',
      );
    }

    subscriptions.assignAll(response.productDetails);
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
      case 'com.pooelcentral.giveandtake.candidate.anual':
      case 'com.pooelcentral.giveandtake.candidate.monthly':
        DPrint.log('Grant candidate subscription access');
        break;

      case 'company_month':
        DPrint.log('Grant company subscription access');
        break;

      case 'recruiter_month':
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