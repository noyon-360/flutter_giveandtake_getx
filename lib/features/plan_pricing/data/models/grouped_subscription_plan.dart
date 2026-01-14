import 'subscription_plan_model.dart';

/// Represents a subscription plan that may have both monthly and yearly options
class GroupedSubscriptionPlan {
  final String title;
  final String? titleColor;
  final List<String> features;
  final SubscriptionPlan? monthlyPlan;
  final SubscriptionPlan? yearlyPlan;

  GroupedSubscriptionPlan({
    required this.title,
    this.titleColor,
    required this.features,
    this.monthlyPlan,
    this.yearlyPlan,
  });

  /// Check if this plan has both monthly and yearly options
  bool get hasBothOptions => monthlyPlan != null && yearlyPlan != null;

  /// Check if this plan has only one option
  bool get hasOnlyOneOption => !hasBothOptions;

  /// Get the single plan (used when only one option is available)
  SubscriptionPlan? get singlePlan => monthlyPlan ?? yearlyPlan;

  /// Factory method to group plans by title
  static List<GroupedSubscriptionPlan> groupPlans(
    List<SubscriptionPlan> plans,
  ) {
    final Map<String, List<SubscriptionPlan>> groupedMap = {};

    // Group plans by title
    for (var plan in plans) {
      if (!groupedMap.containsKey(plan.title)) {
        groupedMap[plan.title] = [];
      }
      groupedMap[plan.title]!.add(plan);
    }

    // Convert grouped map to GroupedSubscriptionPlan list
    final List<GroupedSubscriptionPlan> groupedPlans = [];

    groupedMap.forEach((title, plansList) {
      SubscriptionPlan? monthly;
      SubscriptionPlan? yearly;

      // Separate monthly and yearly plans
      for (var plan in plansList) {
        if (plan.valid.toLowerCase() == 'monthly') {
          monthly = plan;
        } else if (plan.valid.toLowerCase() == 'yearly') {
          yearly = plan;
        } else {
          // For other types like PayAsYouGo, treat as single plan
          monthly = plan;
        }
      }

      // Use features from the first plan (they should be the same for same title)
      final features = plansList.first.features;
      final titleColor = plansList.first.titleColor;

      groupedPlans.add(
        GroupedSubscriptionPlan(
          title: title,
          titleColor: titleColor,
          features: features,
          monthlyPlan: monthly,
          yearlyPlan: yearly,
        ),
      );
    });

    return groupedPlans;
  }
}
