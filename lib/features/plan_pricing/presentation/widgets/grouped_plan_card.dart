import 'package:flutter/material.dart';

import '../../data/models/grouped_subscription_plan.dart';

class GroupedPlanCard extends StatelessWidget {
  final GroupedSubscriptionPlan groupedPlan;
  final VoidCallback? onSubscribe;
  final bool isCurrentPlan;

  const GroupedPlanCard({
    super.key,
    required this.groupedPlan,
    this.onSubscribe,
    this.isCurrentPlan = false,
  });

  Color _getTitleColor() {
    if (groupedPlan.titleColor != null) {
      try {
        return Color(
          int.parse(groupedPlan.titleColor!.replaceFirst('#', '0xff')),
        );
      } catch (e) {
        return const Color(0xff44ca46); // Default green
      }
    }
    return const Color(0xff44ca46); // Default green
  }

  bool _isFreeOrZeroPrice() {
    // Check if plan is free (price = 0)
    if (groupedPlan.singlePlan != null) {
      return groupedPlan.singlePlan!.price == 0;
    }
    // If has both options, check if both are free (unlikely but safe check)
    if (groupedPlan.hasBothOptions) {
      return groupedPlan.monthlyPlan!.price == 0 &&
          groupedPlan.yearlyPlan!.price == 0;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = _getTitleColor();
    final isFree = _isFreeOrZeroPrice();

    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan title with color and current badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  groupedPlan.title,
                  style: TextStyle(
                    fontSize: 18,
                    color: titleColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isCurrentPlan)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B9EFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Current',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Price section
          if (groupedPlan.hasBothOptions) ...[
            // Both monthly and yearly prices
            Text(
              '\$${groupedPlan.monthlyPlan!.price.toStringAsFixed(2)} per month',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF212121),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '\$${groupedPlan.yearlyPlan!.price.toStringAsFixed(2)} per annum',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF212121),
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else ...[
            // Single price
            Text(
              '\$${groupedPlan.singlePlan!.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                color: Color(0xFF212121),
                fontWeight: FontWeight.w700,
              ),
            ),
            if (groupedPlan.singlePlan!.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                groupedPlan.singlePlan!.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8593A3),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],

          const SizedBox(height: 20),

          // "What you will get" section
          const Text(
            'What you will get',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF8593A3),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Features list
          ...groupedPlan.features.asMap().entries.map((entry) {
            final isLast = entry.key == groupedPlan.features.length - 1;
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3B9EFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF212121),
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!isLast) const SizedBox(height: 12),
              ],
            );
          }).toList(),

          const SizedBox(height: 24),

          // Subscribe button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: (isCurrentPlan || isFree) ? null : onSubscribe,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF3B9EFF), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                disabledBackgroundColor: Colors.transparent,
                disabledForegroundColor: const Color(0xFF3B9EFF),
              ),
              child: Text(
                isCurrentPlan
                    ? 'Current Plan'
                    : isFree
                    ? 'Free'
                    : 'Subscribe',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF3B9EFF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
