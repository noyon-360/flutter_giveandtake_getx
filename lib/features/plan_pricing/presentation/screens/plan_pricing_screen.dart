import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import '../controllers/plan_pricing_controller.dart';
import '../widgets/plan_pricing_card.dart';
import '../widgets/payment_option_dialog.dart';

class PlanPricingScreen extends GetView<PlanPricingController> {
  const PlanPricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    if (!Get.isRegistered<PlanPricingController>()) {
      Get.put(PlanPricingController());
    }

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
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${controller.errorMessage.value}',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshPlans(),
                  child: Text('Retry'),
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
                Text('No plans available for your role.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshPlans(),
                  child: Text('Refresh'),
                ),
              ],
            ),
          );
        }

        final plans = controller.filteredPlans;

        return Column(
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

            // PageView for plans with dynamic indicator positioning
            Expanded(
              child: Stack(
                children: [
                  // PageView for plans
                  PageView.builder(
                    controller: pageController,
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              child: PlanPricingCard(
                                title: plan.title,
                                price: plan.price,
                                description: plan.description,
                                features: plan.features,
                                onSubscribe: () {
                                  // Show payment options dialog
                                  showPaymentMethodDialog(
                                    context,
                                    planTitle: plan.title,
                                    price: plan.price,
                                    onPayNow: () {
                                      // Handle payment processing here
                                      print(
                                        'Processing payment for: ${plan.title}',
                                      );
                                      // You can add your payment processing logic here
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 60,
                            ), // Space for indicators + padding
                          ],
                        ),
                      );
                    },
                  ),

                  // Page indicator dots - positioned dynamically
                  if (plans.length > 1)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 16, // 16px from bottom of available space
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(plans.length, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: controller.currentPage == index ? 8 : 6,
                              height: controller.currentPage == index ? 8 : 6,
                              decoration: BoxDecoration(
                                color: controller.currentPage == index
                                    ? Color(0xff3B9EFF)
                                    : Color(0xffD9D9D9),
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
