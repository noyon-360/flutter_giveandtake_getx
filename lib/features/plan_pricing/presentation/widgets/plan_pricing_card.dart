// widgets/plan_pricing_card.dart
import 'package:flutter/material.dart';

class PlanPricingCard extends StatelessWidget {
  final String title;
  final double price;
  final String description;
  final List<String> features;
  final String valid;
  final VoidCallback? onSubscribe;

  const PlanPricingCard({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.features,
    required this.valid,
    this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
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
          // Plan title (dynamic)
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Price (dynamic)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Per $valid',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // "What the user will get" text
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'What the user will get',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Description (dynamic)
          Text(
            description,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withOpacity(0.5), thickness: 1),
          const SizedBox(height: 16),

          // Features list (dynamic - renders based on array length)
          ...features.asMap().entries.map((entry) {
            final isLast = entry.key == features.length - 1;
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: Color(0xff3B9EFF),
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: TextStyle(
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
          }).toList(),

          const SizedBox(height: 18),

          // Subscribe button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSubscribe,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xff3B9EFF),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: Text(
                'Get the premium',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
