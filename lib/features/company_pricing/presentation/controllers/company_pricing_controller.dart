import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../plan_pricing/data/models/grouped_subscription_plan.dart';
import '../../../plan_pricing/data/models/subscription_plan_model.dart';

class CompanyPricingController extends BaseController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  final RxList<SubscriptionPlan> _allPlans = <SubscriptionPlan>[].obs;
  final RxList<GroupedSubscriptionPlan> _groupedPlans =
      <GroupedSubscriptionPlan>[].obs;
  final RxInt _currentPage = 0.obs;

  List<SubscriptionPlan> get allPlans => _allPlans;
  List<GroupedSubscriptionPlan> get groupedPlans => _groupedPlans;
  int get currentPage => _currentPage.value;

  @override
  void onInit() {
    super.onInit();
    fetchCompanyPlans();
  }

  Future<void> fetchCompanyPlans() async {
    try {
      setLoading(true);
      clearError();

      print(
        '🐞 DEBUG [Company]: Fetching plans from: ${ApiConstants.subscription.getPlans}',
      );

      final result = await _apiClient.get<List<SubscriptionPlan>>(
        ApiConstants.subscription.getPlans,
        fromJsonT: (data) {
          print('🐞 DEBUG [Company]: Raw API Response: $data');
          return (data as List<dynamic>)
              .map(
                (json) =>
                    SubscriptionPlan.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        },
      );

      result.fold(
        (failure) {
          setError(failure.message);
          setLoading(false);
          print('🐞 DEBUG [Company]: API Error: ${failure.message}');
        },
        (success) {
          _allPlans.value = success.data;

          // Filter only 'company' role plans
          final companyPlans = success.data
              .where(
                (plan) => plan.for_.toLowerCase() == 'company',
              )
              .toList();

          print(
            '🐞 DEBUG [Company]: Total plans: ${success.data.length}',
          );
          print(
            '🐞 DEBUG [Company]: Available roles: ${success.data.map((p) => p.for_).toSet().toList()}',
          );
          print(
            '🐞 DEBUG [Company]: Company plans: ${companyPlans.length}',
          );

          // Group plans by base title (strip trailing parenthetical suffixes)
          _groupedPlans.value = _groupCompanyPlans(companyPlans);

          setLoading(false);
        },
      );
    } catch (e) {
      setError('An unexpected error occurred: $e');
      setLoading(false);
      print('🐞 DEBUG [Company]: Exception: $e');
    }
  }

  /// Groups raw company plans into [GroupedSubscriptionPlan] items.
  ///
  /// Plans that share the same *base* title (ignoring anything in parentheses)
  /// are paired together as monthly / yearly variants.
  List<GroupedSubscriptionPlan> _groupCompanyPlans(
    List<SubscriptionPlan> plans,
  ) {
    final Map<String, List<SubscriptionPlan>> groupMap = {};

    for (final plan in plans) {
      // Strip parenthetical suffixes, e.g. "Basic Plan (Up to 24 ...)" → "Basic Plan"
      final baseTitle = plan.title
          .replaceAll(RegExp(r'\s*\([^)]*\)'), '')
          .trim();

      groupMap.putIfAbsent(baseTitle, () => []).add(plan);
    }

    final List<GroupedSubscriptionPlan> grouped = [];

    groupMap.forEach((baseTitle, plansList) {
      SubscriptionPlan? monthly;
      SubscriptionPlan? yearly;

      for (final plan in plansList) {
        final validLower = plan.valid.toLowerCase();
        if (validLower == 'monthly') {
          monthly = plan;
        } else if (validLower == 'yearly') {
          yearly = plan;
        } else {
          // PayAsYouGo or other single-type plans
          monthly = plan;
        }
      }

      grouped.add(
        GroupedSubscriptionPlan(
          title: baseTitle,
          titleColor: plansList.first.titleColor,
          features: plansList.first.features,
          monthlyPlan: monthly,
          yearlyPlan: yearly,
        ),
      );
    });

    // Sort: PayAsYouGo first, then rest
    grouped.sort((a, b) {
      final aIsPayg = a.title.toLowerCase().contains('pay as you go');
      final bIsPayg = b.title.toLowerCase().contains('pay as you go');
      if (aIsPayg) return -1;
      if (bIsPayg) return 1;
      return 0;
    });

    return grouped;
  }

  Future<void> refreshPlans() async {
    await fetchCompanyPlans();
  }

  void updateCurrentPage(int page) {
    _currentPage.value = page;
  }

  bool get hasPlans => _groupedPlans.isNotEmpty;
}
