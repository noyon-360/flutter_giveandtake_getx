import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../plan_pricing/presentation/widgets/subscription_type_dialog.dart';
import '../controllers/company_pricing_controller.dart';
import '../widgets/payment_option_dialog.dart';
import '../widgets/plan_pricing_card.dart';

class PlanPricingScreen extends GetView<CompanyPricingController> {
  const PlanPricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialised
    if (!Get.isRegistered<CompanyPricingController>()) {
      Get.put(CompanyPricingController());
    }

    final PageController pageController = PageController();

    // Sync page controller → reactive page index
    pageController.addListener(() {
      if (pageController.hasClients && pageController.page != null) {
        final next = pageController.page!.round();
        if (controller.currentPage != next) {
          controller.updateCurrentPage(next);
        }
      }
    });

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B7FD0),
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
            const Text(
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${controller.errorMessage.value}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshPlans(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!controller.hasPlans) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No plans available for company.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshPlans(),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        final plans = controller.groupedPlans;

        return Column(
          children: [
            const SizedBox(height: 16),
            // Header
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
                const Text(
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

            // PageView with indicator overlay
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                    controller: pageController,
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      final grouped = plans[index];
                      final isPayAsYouGo = grouped.title
                          .toLowerCase()
                          .contains('pay as you go');

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              child: PlanPricingCard(
                                title: grouped.title,
                                monthlyPrice:
                                    grouped.monthlyPlan?.price ?? 0.0,
                                yearlyPrice: grouped.yearlyPlan?.price,
                                features: grouped.features,
                                isPayAsYouGo: isPayAsYouGo,
                                onSubscribe: () {
                                  if (grouped.hasBothOptions) {
                                    // Show monthly/yearly choice dialog first
                                    showSubscriptionTypeDialog(
                                      context,
                                      planTitle: grouped.title,
                                      monthlyPrice:
                                          grouped.monthlyPlan!.price,
                                      yearlyPrice:
                                          grouped.yearlyPlan!.price,
                                      onMonthlySelected: () {
                                        showPaymentMethodDialog(
                                          context,
                                          planTitle: grouped.title,
                                          price: grouped.monthlyPlan!.price,
                                          planId: grouped.monthlyPlan!.id,
                                        );
                                      },
                                      onYearlySelected: () {
                                        showPaymentMethodDialog(
                                          context,
                                          planTitle: grouped.title,
                                          price: grouped.yearlyPlan!.price,
                                          planId: grouped.yearlyPlan!.id,
                                        );
                                      },
                                    );
                                  } else {
                                    // Single billing cycle — go straight to payment
                                    final plan = grouped.singlePlan!;
                                    showPaymentMethodDialog(
                                      context,
                                      planTitle: grouped.title,
                                      price: plan.price,
                                      planId: plan.id,
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 60),
                          ],
                        ),
                      );
                    },
                  ),

                  // Page indicator dots
                  if (plans.length > 1)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 16,
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(plans.length, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              width:
                                  controller.currentPage == index ? 8 : 6,
                              height:
                                  controller.currentPage == index ? 8 : 6,
                              decoration: BoxDecoration(
                                color: controller.currentPage == index
                                    ? const Color(0xff3B9EFF)
                                    : const Color(0xffD9D9D9),
                                shape: BoxShape.circle,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        );
      }),
    );
  }
}
