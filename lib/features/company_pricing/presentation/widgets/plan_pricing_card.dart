import 'package:flutter/material.dart';
import 'package:karlfive/core/theme/app_colors.dart';

class PlanPricingCard extends StatelessWidget {
  final String title;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<String> features;
  final VoidCallback? onSubscribe;

  const PlanPricingCard({
    super.key,
    required this.title,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.features,
    this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\$${monthlyPrice.toStringAsFixed(2)} per month/',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      '\$${(yearlyPrice).toStringAsFixed(2)} per annum',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Divider(height: 1, color: Colors.grey[300]),
                const SizedBox(height: 8),

                Text(
                  'What you\'ll get',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textBlack,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 12),

                // Features list
                ...features.asMap().entries.map((entry) {
                  final isLast = entry.key == features.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          margin: EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            color: Color(0xff3B9EFF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.value.trim(),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onSubscribe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryWhite,
                      foregroundColor: Color(0xff8593A3),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Color(0xff8593A3)),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Sign up to ${_getPlanType()}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPlanType() {
    if (title.toLowerCase().contains('basic')) return 'basic';
    if (title.toLowerCase().contains('bronze')) return 'bronze';
    if (title.toLowerCase().contains('silver')) return 'silver';
    if (title.toLowerCase().contains('pay as you go')) return 'pay as you go';
    return 'plan';
  }
}
