import 'package:get/get.dart';
import 'package:karlfive/features/Home/data/repositories/content_repository_impl.dart';
import 'package:karlfive/features/Home/domain/repositories/content_repository.dart';
import 'package:karlfive/features/auth/data/repo/auth_repo_impl.dart';
import 'package:karlfive/features/auth/domain/repo/auth_repo.dart';
import 'package:karlfive/features/company/data/repo/company_impl.dart';
import 'package:karlfive/features/company/domain/repo/company_repo.dart';
import 'package:karlfive/features/create_job/data/repo/category_rapo_impl.dart';
import 'package:karlfive/features/create_job/domain/category_repo.dart';
import 'package:karlfive/features/job_listing/data/repo/job_listing_repository_impl.dart';
import 'package:karlfive/features/job_listing/data/repo/user_profile_repository_impl.dart';
import 'package:karlfive/features/job_listing/data/repositories/job_application_repository_impl.dart';
import 'package:karlfive/features/job_listing/domain/repo/job_listing_repository.dart';
import 'package:karlfive/features/job_listing/domain/repo/user_profile_repository.dart';
import 'package:karlfive/features/job_listing/domain/repositories/job_application_repository.dart';
import 'package:karlfive/features/plan_pricing/data/repositories/paypal_repository_impl.dart';
import 'package:karlfive/features/plan_pricing/domain/repositories/paypal_repository.dart';
import 'package:karlfive/features/recruiter_account/data/repo/repo_impl.dart';
import 'package:karlfive/features/recruiter_account/domain/repo/repo.dart';

void setupRepository() {
  Get.lazyPut<AuthRepository>(
    () => AuthRepositoryImpl(apiClient: Get.find()),
    fenix: true,
  );

  Get.lazyPut<Repo>(
    () => RepoImplementation(apiClient: Get.find()),
    fenix: true,
  );

  Get.lazyPut<JobListingRepository>(
    () => JobListingRepositoryImpl(apiClient: Get.find()),
    fenix: true,
  );

  Get.lazyPut<UserProfileRepository>(
    () => UserProfileRepositoryImpl(apiClient: Get.find()),
    fenix: true,
  );

  Get.lazyPut<PaypalRepository>(
    () => PaypalRepositoryImpl(apiClient: Get.find()),
    fenix: true,
  );

  Get.lazyPut<CategoryRepository>(
    () => CategoryRepoImpl(apiClient: Get.find()),
    fenix: true,
  );

  // repository
  Get.lazyPut<ContentRepository>(() => ContentRepositoryImpl(), fenix: true);
  
  Get.lazyPut<JobApplicationRepository>(() => JobApplicationRepositoryImpl(), fenix: true);
  Get.lazyPut<CompanyRepository>(() => CompanyRepoImplementation( apiClient: Get.find()), fenix: true);
}
