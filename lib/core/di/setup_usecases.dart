import 'package:get/get.dart';
import 'package:karlfive/features/job_listing/domain/usecases/get_jobs_usecase.dart';

void setupUsecases() {
  Get.lazyPut<GetJobsUseCase>(() => GetJobsUseCase(Get.find()), fenix: true);
}
