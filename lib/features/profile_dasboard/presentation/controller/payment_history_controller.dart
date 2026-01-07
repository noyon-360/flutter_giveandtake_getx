import 'package:get/get.dart';

import '../../data/models/payment_history_response_model.dart';
import '../../data/repo/payment_history_repo_impl.dart';

class PaymentHistoryController extends GetxController {
  final PaymentHistoryRepoImpl _repo = PaymentHistoryRepoImpl();

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final error = RxnString();
  final transactions = <PaymentTransaction>[].obs;
  final meta = Rxn<PaymentMeta>();

  int currentPage = 1;
  final int itemsPerPage = 10;
  bool hasMore = true;

  Future<void> fetchUserPayments(
    String userId, {
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore = true;
      transactions.clear();
    }

    if (isRefresh) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    error.value = null;

    print(
      '💳 [PaymentHistory] Fetching payments for user: $userId, page: $currentPage',
    );

    final result = await _repo.fetchUserPayments(
      userId: userId,
      page: currentPage,
      limit: itemsPerPage,
    );

    result.fold(
      (fail) {
        print('❌ [PaymentHistory] Failed to fetch payments: ${fail.message}');
        error.value = fail.message;
        isLoading.value = false;
        isLoadingMore.value = false;
      },
      (success) {
        final data = success.data;
        meta.value = data.meta;

        if (isRefresh) {
          transactions.assignAll(data.transactions);
        } else {
          transactions.addAll(data.transactions);
        }

        hasMore = currentPage < (data.meta.totalPages);

        print('✅ [PaymentHistory] Payments fetched successfully!');
        print('💳 [PaymentHistory] Transactions count: ${transactions.length}');
        print(
          '💳 [PaymentHistory] Current page: ${data.meta.currentPage}/${data.meta.totalPages}',
        );
        print('💳 [PaymentHistory] Total items: ${data.meta.totalItems}');
        print('💳 [PaymentHistory] Has more: $hasMore');

        isLoading.value = false;
        isLoadingMore.value = false;
      },
    );
  }

  Future<void> loadMore(String userId) async {
    if (isLoadingMore.value || !hasMore) {
      print('⚠️ [PaymentHistory] Already loading or no more data');
      return;
    }

    currentPage++;
    await fetchUserPayments(userId, isRefresh: false);
  }

  Future<void> refreshPayments(String userId) async {
    print('🔄 [PaymentHistory] Refreshing payment history');
    await fetchUserPayments(userId, isRefresh: true);
  }
}
