import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/applied_jobs_response_model.dart';
import '../../data/repo/applied_jobs_repo_impl.dart';

class AppliedJobsController extends GetxController {
  final AppliedJobsRepoImpl _repo = AppliedJobsRepoImpl(apiClient: ApiClient());

  final isLoading = false.obs;
  final error = RxnString();
  final applications = <ApplicationModel>[].obs;
  final resume = Rxn<CreateResumeModel>();

  Future<void> fetchUserApplications(String userId, {int page = 1}) async {
    isLoading.value = true;
    error.value = null;
    final result = await _repo.fetchUserApplications(userId: userId, page: page);
    result.fold((fail) {
      error.value = fail.message;
      isLoading.value = false;
    }, (success) {
      final data = success.data;
      applications.assignAll(data.applications);
      resume.value = data.createResume;
      isLoading.value = false;
    });
  }
}
