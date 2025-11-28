import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../plan_pricing/presentation/controllers/plan_pricing_controller.dart';
import '../../../plan_pricing/presentation/widgets/payment_option_dialog.dart';
import '../../../plan_pricing/presentation/widgets/plan_pricing_card.dart';

class MyPlanScreen extends StatelessWidget {
  const MyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the PlanPricingController
    final PlanPricingController controller = Get.put(PlanPricingController());
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
        title: const Text(
          'My Plan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// Current Plan Title
              const Text(
                "Your Subscription Plan",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "View and manage your subscription",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF8593A3),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

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

                final plans = controller.filteredPlans;

                return Column(
                  children: [
                    SizedBox(
                      height: 480,
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: plans.length,
                        itemBuilder: (context, index) {
                          final plan = plans[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: PlanPricingCard(
                              title: plan.title,
                              price: plan.price,
                              description: plan.description,
                              features: plan.features,
                              valid: plan.valid,
                              onSubscribe: () {
                                showPaymentMethodDialog(
                                  context,
                                  planTitle: plan.title,
                                  price: plan.price,
                                  onPayNow: () {
                                    print('Processing payment for: ${plan.title}');
                                  },
                                );
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
                if (controller.isLoading.value || !controller.hasPlans) {
                  return const SizedBox.shrink();
                }

                final plans = controller.filteredPlans;

                if (plans.length <= 1) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(plans.length, (index) {
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
