import 'package:flutter/material.dart';

class PlanPricingCard extends StatelessWidget {
  final String title;
  final double monthlyPrice;
  final double? yearlyPrice;
  final List<String> features;
  final bool isPayAsYouGo;
  final VoidCallback? onSubscribe;

  const PlanPricingCard({
    super.key,
    required this.title,
    required this.monthlyPrice,
    this.yearlyPrice,
    required this.features,
    this.isPayAsYouGo = false,
    this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    if (isPayAsYouGo) {
      // Special design for Pay as You Go
      return Container(
        width: MediaQuery.of(context).size.width * 0.85,
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plan title (no blue header)
              Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              // Price with description
              Text(
                '\$${monthlyPrice.toStringAsFixed(2)} per Job Advert (30 Days Post)',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xff8593A3),
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 20),

              // "What you'll get" header
              Text(
                'What you\'ll get',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
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
                        child: Icon(Icons.check, color: Colors.white, size: 12),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.value.trim(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 24),

              // Subscribe button
              Center(
                child: SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: onSubscribe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xff3B9EFF),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: BorderSide(color: Color(0xff3B9EFF), width: 1),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Regular design for other plans (restored to your original design)
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
                        color: Color(0xff3B9EFF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\$${monthlyPrice.toStringAsFixed(2)} per month/',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      '\$${(yearlyPrice ?? (monthlyPrice * 12)).toStringAsFixed(2)} per annum',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
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
                    color: Colors.black,
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
                      backgroundColor: Colors.white,
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
