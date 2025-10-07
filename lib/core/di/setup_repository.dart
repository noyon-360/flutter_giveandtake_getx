import 'package:get/get.dart';
import 'package:karlfive/features/auth/data/repo/auth_repo_impl.dart';
import 'package:karlfive/features/auth/domain/repo/auth_repo.dart';
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
}
