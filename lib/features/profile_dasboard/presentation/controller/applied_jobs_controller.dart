import 'package:get/get.dart';

import '../../data/models/applied_jobs_response_model.dart';
import '../../data/repo/applied_jobs_repo_impl.dart';

class AppliedJobsController extends GetxController {
  final AppliedJobsRepoImpl _repo = AppliedJobsRepoImpl();

  final isLoading = false.obs;
  final error = RxnString();
  final applications = <ApplicationModel>[].obs;
  final resume = Rxn<CreateResumeModel>();

  Future<void> fetchUserApplications(String userId, {int page = 1}) async {
    print(
      '📋 [JobHistoryController] Starting fetch for userId: $userId, page: $page',
    );
    isLoading.value = true;
    error.value = null;

    final result = await _repo.fetchUserApplications(
      userId: userId,
      page: page,
    );

    result.fold(
      (fail) {
        print('❌ [JobHistoryController] Fetch failed: ${fail.message}');
        error.value = fail.message;
        isLoading.value = false;
      },
      (success) {
        print('✅ [JobHistoryController] Fetch succeeded');
        final data = success.data;
        print(
          '📋 [JobHistoryController] Applications count: ${data.applications.length}',
        );
        applications.assignAll(data.applications);
        resume.value = data.createResume;
        isLoading.value = false;
      },
    );
  }
}
