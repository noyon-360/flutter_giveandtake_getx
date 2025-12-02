import 'package:get/get.dart';
import 'package:karlfive/features/Home/presentation/controllers/home_controller.dart';
import 'package:karlfive/features/auth/presentation/controller/auth_controller.dart';
import 'package:karlfive/features/company/presentation/controller/company_account_controller.dart';
import 'package:karlfive/features/create_job/presentation/controller/category_controller.dart';
import 'package:karlfive/features/job_listing/presentation/controller/job_listing_controller.dart';
import 'package:karlfive/features/plan_pricing/presentation/controllers/paypal_controller.dart';
import 'package:karlfive/features/plan_pricing/presentation/controllers/plan_pricing_controller.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/country_city_controller.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/recruiter_controller.dart';

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

  // PayPal Controller
  Get.lazyPut<PaypalController>(
    () => PaypalController(Get.find()),
    fenix: true,
  );

  // Home Controller
  Get.lazyPut<HomeController>(
    () => HomeController(Get.find()),
    fenix: true,
  );

  // Category Controller
  Get.lazyPut<CategoryController>(
    () => CategoryController(Get.find()),
    fenix: true,
  );
  Get.lazyPut<CompanyAccountController>(
    () => CompanyAccountController(Get.find()),
    fenix: true,
  );
  Get.lazyPut<LocationController>(
    () => LocationController(),
    fenix: true,
  );
}
