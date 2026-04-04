import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/get_user_profile_service.dart';
import '../../../plan_pricing/presentation/controllers/plan_pricing_controller.dart';
import '../../../plan_pricing/presentation/screens/payment_screen.dart';
import '../../../plan_pricing/presentation/widgets/grouped_plan_card.dart';
import '../../../plan_pricing/presentation/widgets/subscription_type_dialog.dart';

class MyPlanScreen extends StatelessWidget {
  const MyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controllers
    final PlanPricingController controller = Get.put(PlanPricingController());
    final GetUserProfileService userProfileService =
        Get.find<GetUserProfileService>();
    final PageController pageController = PageController();

    // Add listener to page controller for reactive page updates
    pageController.addListener(() {
      if (pageController.hasClients && pageController.page != null) {
        int next = pageController.page!.round();
        if (controller.currentPage != next) {
          controller.updateCurrentPage(next);
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF2B7FD0),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        ),
        title: const Text(
          'My Plan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // const SizedBox(height: 20),

              /// Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F9FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Candidate Price List",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF212121),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Please view our refunds policy in our Terms and Conditions, or ask our Chatbot about refunds.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8593A3),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Current Plan Badge
                    Obx(() {
                      final userPlan = userProfileService.userInfo?.plan;
                      if (userPlan != null) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF3B9EFF),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            "You're currently on our ${userPlan.title} (${userPlan.valid}).",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF212121),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
              // const SizedBox(height: 30),

              // /// Title
              // const Text(
              //   "Your Subscription Plan",
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.w600,
              //     color: Color(0xFF212121),
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              // const SizedBox(height: 8),
              // const Text(
              //   "View and manage your subscription",
              //   style: TextStyle(
              //     fontSize: 12,
              //     fontWeight: FontWeight.w400,
              //     color: Color(0xFF8593A3),
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              const SizedBox(height: 10),

              /// Plan Pricing Cards with PageView
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
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
                    ),
                  );
                }

                if (!controller.hasPlans) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text('No plans available for your role.'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => controller.refreshPlans(),
                            child: const Text('Refresh'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final groupedPlans = controller.groupedPlans;

                return Column(
                  children: [
                    SizedBox(
                      height: 520,
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: groupedPlans.length,
                        itemBuilder: (context, index) {
                          final groupedPlan = groupedPlans[index];

                          // Check if this is the current plan
                          final currentUserPlan =
                              userProfileService.userInfo?.plan;
                          bool isCurrentPlan = false;

                          if (currentUserPlan != null) {
                            // Check if titles match
                            isCurrentPlan =
                                currentUserPlan.title == groupedPlan.title;
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: GroupedPlanCard(
                              groupedPlan: groupedPlan,
                              isCurrentPlan: isCurrentPlan,
                              onSubscribe: () {
                                // Check if plan has both options
                                if (groupedPlan.hasBothOptions) {
                                  // Show dialog to choose between monthly and yearly
                                  showSubscriptionTypeDialog(
                                    context,
                                    planTitle: groupedPlan.title,
                                    monthlyPrice:
                                        groupedPlan.monthlyPlan!.price,
                                    yearlyPrice: groupedPlan.yearlyPlan!.price,
                                    onMonthlySelected: () {
                                      // Navigate to payment screen with monthly plan
                                      Get.to(
                                        () => PaymentScreen(
                                          planTitle:
                                              '${groupedPlan.title} (Monthly)',
                                          amount:
                                              groupedPlan.monthlyPlan!.price,
                                          planId: groupedPlan.monthlyPlan!.id,
                                        ),
                                      );
                                    },
                                    onYearlySelected: () {
                                      // Navigate to payment screen with yearly plan
                                      Get.to(
                                        () => PaymentScreen(
                                          planTitle:
                                              '${groupedPlan.title} (Yearly)',
                                          amount: groupedPlan.yearlyPlan!.price,
                                          planId: groupedPlan.yearlyPlan!.id,
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  // Single option - go directly to payment screen
                                  final plan = groupedPlan.singlePlan!;
                                  Get.to(
                                    () => PaymentScreen(
                                      planTitle:
                                          '${groupedPlan.title} (${plan.valid})',
                                      amount: plan.price,
                                      planId: plan.id,
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),

              // Page indicator dots - at the bottom of the page
              Obx(() {
                if (controller.isLoading.value ||
                    controller.groupedPlans.isEmpty) {
                  return const SizedBox.shrink();
                }

                final groupedPlans = controller.groupedPlans;

                if (groupedPlans.length <= 1) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(groupedPlans.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: controller.currentPage == index ? 8 : 6,
                        height: controller.currentPage == index ? 8 : 6,
                        decoration: BoxDecoration(
                          color: controller.currentPage == index
                              ? const Color(0xff3B9EFF)
                              : const Color(0xffD9D9D9),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                );
              }),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
