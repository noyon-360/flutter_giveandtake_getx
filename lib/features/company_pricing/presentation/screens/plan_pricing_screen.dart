import 'package:flutter/material.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/payment_option_dialog.dart';
import '../widgets/plan_pricing_card.dart';

class PlanPricingScreen extends StatefulWidget {
  const PlanPricingScreen({super.key});

  @override
  State<PlanPricingScreen> createState() => _PlanPricingScreenState();
}

class _PlanPricingScreenState extends State<PlanPricingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = true;
  List<dynamic> _plans = [];

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
    // Mock data matching API structure with both monthly and yearly plans
    await Future.delayed(Duration(seconds: 1));

    // Raw API data
    List<dynamic> rawPlans = [
      {
        "_id": "68d36f83ea232d04ea923327",
        "title": "Basic Plan",
        "description": "per month",
        "price": 195.99,
        "features": [
          "First post free!",
          "60-Second company's culture Elevator Video Pitch",
          "Intuitive company's dashboard",
          "Seamless job posting/amendments/closure/reopening",
          "Scheduled job posts",
          "Initial online screening of job applicants",
          "One-click update to each job applicant",
          "Select from 7 to 30 days listing",
        ],
        "for": "company",
        "valid": "monthly",
      },
      {
        "_id": "68d3707dea232d04ea923330",
        "title": "Basic Plan",
        "description": "per annum (Up to 24 job posts per annual cycle)",
        "price": 2155.99,
        "features": [
          "12 months for the price of 11 Months!",
          "First post free!",
          "60-second Recruiter's Elevator Video Pitch",
          "Intuitive Recruiter's dashboard",
          "Seamless job posting/amendments/closure/reopening",
          "Scheduled job posts",
          "Initial online screening of job applicants",
          "One-click update to each job applicant",
          "Select from 7 to 30 days listing",
        ],
        "for": "recruiter",
        "valid": "yearly",
      },
      {
        "_id": "68d3736cea232d04ea9233fc",
        "title": "Premium Bronze Plan",
        "description": "per month",
        "price": 270.99,
        "features": [
          "12 months for the price of 11 Months!",
          "First post free!",
          "60-second Recruiter's Elevator Video Pitch",
          "Intuitive Recruiter's dashboard",
          "Seamless job posting/amendments/closure/reopening",
          "Scheduled job posts",
          "Initial online screening of job applicants",
          "One-click update to each job applicant",
          "Select from 7 to 30 days listing",
        ],
        "for": "recruiter",
        "valid": "monthly",
      },
      {
        "_id": "68d3741cea232d04ea923401",
        "title": "Premium Bronze Plan (Up to 36 job posts per annual cycle)",
        "description": "per annum",
        "price": 2980.99,
        "features": [
          "12 months for the price of 11 Months!",
          "First post free!",
          "60-second Recruiter's Elevator Video Pitch",
          "Intuitive Recruiter's dashboard",
          "Seamless job posting/amendments/closure/reopening",
          "Scheduled job posts",
          "Initial online screening of job applicants",
          "One-click update to each job applicant",
          "Select from 7 to 30 days listing",
        ],
        "for": "recruiter",
        "valid": "yearly",
      },
      {
        "_id": "68d37c9aea232d04ea923554",
        "title": "Premium Silver Plan",
        "description": "per month",
        "price": 355.99,
        "features": [
          "12 months for the price of 11 Months!",
          "First post free!",
          "60-second Recruiter's Elevator Video Pitch",
          "Intuitive Recruiter's dashboard",
          "Seamless job posting/amendments/closure/reopening",
          "Scheduled job posts",
          "Initial online screening of job applicants",
          "One-click update to each job applicant",
          "Select from 7 to 30 days listing",
        ],
        "for": "recruiter",
        "valid": "monthly",
      },
      {
        "_id": "68d37d22ea232d04ea923559",
        "title": "Premium Silver Plan (Up to 48 job posts per annual cycle)",
        "description": "per annum",
        "price": 3915.99,
        "features": [
          "12 months for the price of 11 Months!",
          "First post free!",
          "60-second Recruiter's Elevator Video Pitch",
          "Intuitive Recruiter's dashboard",
          "Seamless job posting/amendments/closure/reopening",
          "Scheduled job posts",
          "Initial online screening of job applicants",
          "One-click update to each job applicant",
          "Select from 7 to 30 days listing",
        ],
        "for": "recruiter",
        "valid": "yearly",
      },
      {
        "_id": "68c92828343f6bdf483c2596",
        "title": "Pay as You Go",
        "description": "per Job Advert",
        "price": 99.0,
        "features": [
          "First post free!",
          "60-second Recruiter's Elevator Video Pitch",
          "Intuitive Recruiter's dashboard",
          "Seamless job posting/amendments/closure/reopening",
          "Scheduled job posts",
          "Initial online screening of job applicants",
          "One-click update to each job applicant",
          "Select from 7 to 30 days listing",
        ],
        "for": "recruiter",
        "valid": "PayAsYouGo",
      },
    ];

    // Group plans by base title and pair monthly/yearly
    Map<String, Map<String, dynamic>> planGroups = {};

    for (var plan in rawPlans) {
      String baseTitle = plan['title']
          .toString()
          .replaceAll(RegExp(r'\s*\([^)]*\)'), '')
          .trim();

      if (!planGroups.containsKey(baseTitle)) {
        planGroups[baseTitle] = {
          'title': baseTitle,
          'monthlyPrice': null,
          'yearlyPrice': null,
          'features': plan['features'],
        };
      }

      if (plan['valid'] == 'monthly') {
        planGroups[baseTitle]!['monthlyPrice'] = plan['price'].toDouble();
      } else if (plan['valid'] == 'yearly') {
        planGroups[baseTitle]!['yearlyPrice'] = plan['price'].toDouble();
      } else if (plan['valid'] == 'PayAsYouGo') {
        planGroups[baseTitle]!['monthlyPrice'] = plan['price'].toDouble();
        planGroups[baseTitle]!['yearlyPrice'] = plan['price'].toDouble();
      }
    }

    // Convert to list and reorder to put Pay as You Go first
    List<Map<String, dynamic>> planList = planGroups.values
        .where((plan) => plan['monthlyPrice'] != null)
        .toList();

    // Sort plans: Pay as You Go first, then others
    planList.sort((a, b) {
      if (a['title'].toString().toLowerCase().contains('pay as you go'))
        return -1;
      if (b['title'].toString().toLowerCase().contains('pay as you go'))
        return 1;
      return 0;
    });

    setState(() {
      _plans = planList;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B7FD0),
        //iconTheme: const IconThemeData(color: AppColors.textBlack),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Plan & Pricing',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose the Plan That Fits You Best',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w500,
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
                        'Company Price List',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'For Job Posting & Recruitment',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xff4B4B4B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 45),
                Expanded(
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: _plans.length,
                        itemBuilder: (context, index) {
                          final plan = _plans[index];
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                  ),
                                  child: PlanPricingCard(
                                    title: plan['title'],
                                    monthlyPrice: plan['monthlyPrice']
                                        .toDouble(),
                                    yearlyPrice: plan['yearlyPrice']
                                        ?.toDouble(),
                                    features: List<String>.from(
                                      plan['features'],
                                    ),
                                    isPayAsYouGo: plan['title']
                                        .toString()
                                        .toLowerCase()
                                        .contains('pay as you go'),
                                    onSubscribe: () {
                                      showPaymentMethodDialog(
                                        context,
                                        planTitle: plan['title'],
                                        price: plan['monthlyPrice'].toDouble(),
                                        onPayNow: () {
                                          print(
                                            'Processing payment for: ${plan['title']}',
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 60),
                              ],
                            ),
                          );
                        },
                      ),

                      if (_plans.length > 1)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_plans.length, (index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
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
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
    );
  }
}
