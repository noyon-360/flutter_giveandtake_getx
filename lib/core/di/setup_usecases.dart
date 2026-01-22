import 'package:get/get.dart';
import 'package:giveandtake/features/job_listing/domain/usecases/get_job_details_usecase.dart';
import 'package:giveandtake/features/job_listing/domain/usecases/get_jobs_usecase.dart';
import 'package:giveandtake/features/job_listing/domain/usecases/get_user_profile_usecase.dart';
import 'package:giveandtake/features/job_listing/domain/usecases/submit_job_application_usecase.dart';

void setupUsecases() {
  Get.lazyPut<GetJobsUseCase>(() => GetJobsUseCase(Get.find()), fenix: true);
  Get.lazyPut<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(Get.find()),
    fenix: true,
  );
  Get.lazyPut<SubmitJobApplicationUseCase>(
    () => SubmitJobApplicationUseCase(Get.find()),
    fenix: true,
  );
  Get.lazyPut<GetJobDetailsUseCase>(
    () => GetJobDetailsUseCase(Get.find()),
    fenix: true,
  );
}
