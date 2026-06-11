import 'package:get/get.dart';
import 'package:giveandtake/features/Home/presentation/controllers/home_controller.dart';
import 'package:giveandtake/features/auth/presentation/controller/auth_controller.dart';
import 'package:giveandtake/features/company/presentation/controller/company_account_controller.dart';
import 'package:giveandtake/features/company/presentation/controller/company_details_controller.dart';
import 'package:giveandtake/features/company_pricing/presentation/controllers/company_pricing_controller.dart';
import 'package:giveandtake/features/create_job/presentation/controller/category_controller.dart';
import 'package:giveandtake/features/job_listing/presentation/controller/job_listing_controller.dart';
import 'package:giveandtake/features/messaging/presentation/controller/messaging_controller.dart';
import 'package:giveandtake/features/notifications/presentation/controller/notifications_controller.dart';
import 'package:giveandtake/features/plan_pricing/presentation/controllers/paypal_controller.dart';
import 'package:giveandtake/features/plan_pricing/presentation/controllers/plan_pricing_controller.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/country_city_controller.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/recruiter_controller.dart';
import 'package:giveandtake/features/search/presentation/controller/search_controller.dart';

void setupController() {
  // Auth Controller
  Get.lazyPut<AuthController>(
    () => AuthController(Get.find(), Get.find()),
    fenix: true,
  );

  Get.lazyPut<RecruiterController>(
    () => RecruiterController(Get.find(), Get.find()),
    fenix: true,
  );

  // Job Listing Controller
  Get.lazyPut<JobListingController>(
    () => JobListingController(getJobsUseCase: Get.find()),
    fenix: true,
  );

  // Plan Pricing Controller
  Get.lazyPut<PlanPricingController>(
    () => PlanPricingController(),
    fenix: true,
  );

  // Company Pricing Controller
  Get.lazyPut<CompanyPricingController>(
    () => CompanyPricingController(),
    fenix: true,
  );

  // PayPal Controller
  Get.lazyPut<PaypalController>(
    () => PaypalController(Get.find()),
    fenix: true,
  );

  // Home Controller
  Get.lazyPut<HomeController>(() => HomeController(Get.find()), fenix: true);
  Get.lazyPut<NotificationsController>(
    () => NotificationsController(Get.find(), Get.find(), Get.find()),
    fenix: true,
  );
  Get.lazyPut<MessagingController>(
    () => MessagingController(Get.find(), Get.find(), Get.find()),
    fenix: true,
  );

  // Category Controller
  Get.lazyPut<CategoryController>(
    () => CategoryController(Get.find()),
    fenix: true,
  );
  Get.lazyPut<CompanyAccountController>(
    () => CompanyAccountController(Get.find(), Get.find()),
    fenix: true,
  );

  Get.lazyPut<CompanyDetailsController>(
    () => CompanyDetailsController(Get.find(), Get.find()),
    fenix: true,
  );
  Get.lazyPut<LocationController>(() => LocationController(), fenix: true);

  // Global search (drawer typeahead + full results screen)
  Get.lazyPut<GlobalSearchController>(
    () => GlobalSearchController(Get.find()),
    fenix: true,
  );
}
