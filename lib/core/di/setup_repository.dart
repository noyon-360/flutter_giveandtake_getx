import 'package:get/get.dart';
import 'package:karlfive/features/EntireScreen/data/repo/user_info_repo_impl.dart';
import 'package:karlfive/features/EntireScreen/domain/repo/user_info_repo.dart';
import 'package:karlfive/features/auth/data/repo/auth_repo_impl.dart';
import 'package:karlfive/features/auth/domain/repo/auth_repo.dart';
import 'package:karlfive/features/home/data/home_repository.dart';
import 'package:karlfive/features/join_league/data/repositories/join_league/join_league.dart';
import 'package:karlfive/features/join_league/domain/repo/team_repo.dart';
import 'package:karlfive/features/league/models/league_model.dart';

import 'package:karlfive/features/team_members_profile/data/repo/contact_us_repo_impl.dart';
import '../../features/home/data/home_repository_impl.dart';
import '../../features/league/data/league_repository.dart';
import '../../features/league/data/league_repository_impl.dart';
import '../../features/team_members_profile/domain/repo/contact_us_repo.dart';
import 'package:karlfive/features/team_members_profile/data/repo/user_profile_repo_impl.dart';
import 'package:karlfive/features/team_members_profile/domain/repo/user_profile_repo.dart';
import 'package:karlfive/features/team_members_profile/presentation/controllers/profile_controller.dart';
import 'package:karlfive/features/team_members_profile/presentation/controllers/edit_profile_controller.dart';
import 'package:karlfive/features/team_details/data/repo/team_repo_impl.dart';
import 'package:karlfive/features/team_details/domain/repo/team_repo.dart';
import 'package:karlfive/features/team_details/presentation/controllers/team_controller.dart';

import 'package:karlfive/features/payment/data/repo/payment_repo_impl.dart';
import 'package:karlfive/features/payment/domain/payment_repo_stripe.dart';
import 'package:karlfive/features/payment/domain/payment_repo.dart';
import 'package:karlfive/features/payment/data/model/create_pay_response_stripe.dart';
import 'package:karlfive/features/payment/data/repo/payment_repo_impl.dart'
    as stripe_repo;

void setupRepository() {
  Get.lazyPut<AuthRepository>(
    () => AuthRepositoryImpl(apiClient: Get.find()),
    fenix: true,
  );

  Get.lazyPut<UserInfoRepo>(
    () => UserInfoRepoImpl(apiClient: Get.find()),
    fenix: true,
  );

  Get.lazyPut<JoinLeagueRepository>(
    () => JoinLeagueRepositoryImpl(apiClient: Get.find()),
    fenix: true,
  );

  Get.lazyPut<ContactUsRepo>(
    () => ContactUsRepoImpl(apiClient: Get.find()),
    fenix: true,
  );

  // User profile repo & controller
  Get.lazyPut<UserProfileRepo>(
    () => UserProfileRepoImpl(apiClient: Get.find()),
    fenix: true,
  );

  Get.lazyPut<ProfileController>(
    () => ProfileController(repository: Get.find()),
    fenix: true,
  );

  // Edit profile controller (uses existing UserInfoRepo)
  Get.lazyPut(
    () => EditProfileController(Get.find<UserInfoRepo>()),
    fenix: true,
  );

  // Team details
  Get.lazyPut<TeamRepo>(() => TeamRepoImpl(apiClient: Get.find()), fenix: true);

  Get.lazyPut<TeamController>(
    () => TeamController(repo: Get.find()),
    fenix: true,
  );

  // Register server-side payment API repository (used by CreatePayment API flow)
  Get.lazyPut<PaymentApiRepository>(
    () => PaymentApiRepositoryImpl(Get.find()),
    fenix: true,
  );

  // Register Stripe payment repository implementation
  Get.lazyPut<PaymentRepository>(
    () => PaymentRepositoryStripeImpl(Get.find()),
    fenix: true,
  );

  Get.lazyPut<HomeRepository>(
    () => HomeRepositoryImpl(apiClient: Get.find()),
    fenix: true,
  );

  Get.lazyPut<LeagueRepository>(
    () => LeagueRepositoryImpl(apiClient: Get.find()),
    fenix: true,
  );

  Get.lazyPut<UserInfoRepo>(
    () => UserInfoRepoImpl(apiClient: Get.find()),
    fenix: true,
  );
}
