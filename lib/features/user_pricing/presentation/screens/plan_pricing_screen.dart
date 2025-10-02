import 'package:flutter/material.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/core/theme/app_colors.dart';

import '../widgets/plan_pricing_card.dart';
// Import your model: import 'package:karlfive/models/subscription_plan.dart';

class PlanPricingScreen extends StatefulWidget {
  const PlanPricingScreen({super.key});

  @override
  State<PlanPricingScreen> createState() => _PlanPricingScreenState();
}

class _PlanPricingScreenState extends State<PlanPricingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = true;
  List<dynamic> _plans =
      []; // Replace with List<SubscriptionPlan> when using the model

  @override
  void initState() {
    super.initState();
    _fetchPlans();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchPlans() async {
    // Mock data for demonstration
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _plans = [
        {
          "title": "Candidate Basic Plan",
          "description": "This plan is for entry-level candidates.",
          "price": 9.99,
          "features": ["Apply to 5 jobs per month", "Basic support"],
          "for": "candidate",
        },
        {
          "title": "Candidate Premium Plan",
          "description":
              "Perfect for active job seekers looking for more opportunities.",
          "price": 49.99,
          "features": [
            "A 60-sec elevator pitch",
            "A free CV review and alteration online",
            "Apply to unlimited jobs",
            "Priority support",
          ],
          "for": "candidate",
        },
        {
          "title": "Candidate Pro Plan",
          "description": "Advanced features for serious professionals.",
          "price": 99.99,
          "features": [
            "Everything in Premium",
            "Personal career coach",
            "Interview preparation",
            "LinkedIn profile optimization",
          ],
          "for": "candidate",
        },
      ];
      _isLoading = false;
    });
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
              'Plan & Pricing',
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
                color: Color(0xff8593A3),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 16),
                Column(
                  children: [
                    Center(
                      child: Text(
                        'User Price List',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'For Elevator Video Pitch',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xff4B4B4B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 45),

                // PageView for plans - One card at a time with dynamic height
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _plans.length,
                    itemBuilder: (context, index) {
                      final plan = _plans[index];
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: PlanPricingCard(
                            title: plan['title'],
                            price: plan['price'].toDouble(),
                            description: plan['description'],
                            features: List<String>.from(plan['features']),
                            onSubscribe: () {
                              // Handle subscription
                              print('Subscribe to: ${plan['title']}');
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Page indicator dots
                if (_plans.length > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_plans.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 8 : 6,
                        height: _currentPage == index ? 8 : 6,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Color(0xff3B9EFF)
                              : Color(0xffD9D9D9),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
              ],
            ),
    );
  }
}
